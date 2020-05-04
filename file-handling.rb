#!/usr/bin/ruby

#File should be in the same directory
#Eg of file name: 'README.md', 'file.txt' etc

file_to_read_from = ''
body = File.read(file_to_read_from)

file_to_write_into = ''
body_to_be_written = ''
File.open("#{__dir__}/#{file_to_write_into}", 'w') { |file| file.write(body_to_be_written) }
