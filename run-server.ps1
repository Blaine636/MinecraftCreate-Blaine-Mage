$ErrorActionPreference = "Stop"

$serverDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -LiteralPath $serverDirectory

$pullIntervalSeconds = 300
$gitBranch = "main"

function Write-Log {
    param(
        [string] $Message
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] $Message"
}

function Invoke-Git {
    param(
        [Parameter(Mandatory)]
        [string[]] $Arguments
    )

    & git @Arguments

    if ($LASTEXITCODE -ne 0) {
        throw "Git command failed with exit code $LASTEXITCODE`: git $($Arguments -join ' ')"
    }
}

$startTime = Get-Date
$startTimestamp = $startTime.ToString("yyyy-MM-dd HH:mm:ss zzz")

try {
    Write-Log "Pulling latest changes before server startup..."
    Invoke-Git @("pull", "--ff-only", "origin", $gitBranch)
}
catch {
    Write-Log "Initial git pull failed: $($_.Exception.Message)"
    exit 1
}

$pullJob = Start-Job -ScriptBlock {
    param(
        [string] $ServerDirectory,
        [int] $IntervalSeconds,
        [string] $Branch
    )

    Set-Location -LiteralPath $ServerDirectory

    while ($true) {
        Start-Sleep -Seconds $IntervalSeconds

        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Write-Output "[$timestamp] Pulling latest changes..."

        & git pull --ff-only origin $Branch

        if ($LASTEXITCODE -ne 0) {
            Write-Output "[$timestamp] git pull failed with exit code $LASTEXITCODE"
        }
    }
} -ArgumentList $serverDirectory, $pullIntervalSeconds, $gitBranch

Write-Log "Starting Minecraft server..."
Write-Log "Server start time: $startTimestamp"

$serverProcess = Start-Process `
    -FilePath "java.exe" `
    -ArgumentList @(
        "@user_jvm_args.txt",
        "@libraries/net/neoforged/neoforge/21.1.248/win_args.txt"
    ) `
    -WorkingDirectory $serverDirectory `
    -NoNewWindow `
    -PassThru

try {
    Write-Log "Minecraft is running with PID $($serverProcess.Id)."
    Write-Log "Type 'stop' in the Minecraft console to shut it down."

    Wait-Process -Id $serverProcess.Id

    $stopTime = Get-Date
    $stopTimestamp = $stopTime.ToString("yyyy-MM-dd HH:mm:ss zzz")

    Write-Log "Minecraft process exited."
    Write-Log "Server stop time: $stopTimestamp"
}
finally {
    if ($pullJob) {
        Write-Log "Stopping background git pull job..."

        Stop-Job -Job $pullJob -ErrorAction SilentlyContinue
        Receive-Job -Job $pullJob -ErrorAction SilentlyContinue
        Remove-Job -Job $pullJob -Force -ErrorAction SilentlyContinue
    }
}

$commitMessage = "Automated server run commit: $startTimestamp to $stopTimestamp"

try {
    Write-Log "Committing server changes..."
    Invoke-Git @("add", "-A")

    $status = & git status --porcelain

    if ([string]::IsNullOrWhiteSpace(($status -join ""))) {
        Write-Log "No changes detected; nothing to commit or push."
        exit 0
    }

    Invoke-Git @("commit", "-m", $commitMessage)

    Write-Log "Pushing server changes..."
    Invoke-Git @("push", "origin", $gitBranch)

    Write-Log "Git push completed."
}
catch {
    Write-Log "Final git commit/push failed: $($_.Exception.Message)"
    exit 1
}