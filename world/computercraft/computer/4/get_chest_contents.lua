local chest = peripheral.wrap('back')
local file = fs.open('chest_contents.txt', 'w')

for key, value in ipairs(chest.list()) do
    local formated_string = '\''..value.name..'\','
    file.writeLine(formated_string)
end

file.close()
