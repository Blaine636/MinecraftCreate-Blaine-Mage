local hitCount = 0

term.clear()
term.setCursorPos(1, 1)
print("Attacking...")
print("Hold Ctrl+T to terminate.")

while true do
    local success = turtle.attack()
    if success then
        hitCount = hitCount + 1
        
        term.clear()
        term.setCursorPos(1, 1)
        print("Attacking...")
        print("Successful hits: " .. hitCount)
    end
    -- Short delay to prevent excessive CPU usage if the attack loop runs too fast
    sleep(0.1)
end