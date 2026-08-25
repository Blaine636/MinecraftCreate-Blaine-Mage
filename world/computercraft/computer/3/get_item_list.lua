local file = fs.open("item_list.txt", "a")
file.writeLine(' ')

for slot, item in pairs(peripheral.call('back', 'list')) do
    file.writeLine('\''..item.name..'\',')
end

file.close()

