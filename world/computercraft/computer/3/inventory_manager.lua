local chest = peripheral.wrap('right')
local barrel = peripheral.wrap('bottom')

inventory = peripheral.getMethods('right')

for index, value in ipairs(inventory) do
    print(value)
end

chest_list = chest.list()

for i=1, #chest_list do
    barrel.pullItems('right',i)
end
