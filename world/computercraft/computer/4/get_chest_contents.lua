local chest = peripheral.wrap('back')
local file = fs.open('chest_contents.txt', 'w')

for key, value in ipairs(chest.list()) do
    local quote_1 = '\''
    print(quote_1)
    local step = quote_1 .. value.name
    print(step)
    local quote_2 = '\','
    print(quote_2)
    local formated_string = step..quote_2
    print(formated_string)
    file.writeLine(formated_string)
end

file.close()
