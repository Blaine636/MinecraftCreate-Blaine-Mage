function swipe(duration)
    redstone.setOutput('left', true)
    sleep(duration)
    redstone.setOutput('left', false)
    sleep(duration)
end

print('Sweep program running...')
while true do
    active = redstone.getInput('top')
    if active then
        swipe(11)
    else
        sleep(1)
    end
end
