local lib = require('library')
local args = {...}

print('Oh, ')
term.write('hello!')

print()
print('...\nIm Bot! What\'s your name?')
local input = term.read()
term.clear()
term.setCursorPos(20,10)
print('Nice to meet you '..input)
