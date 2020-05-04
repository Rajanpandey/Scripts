#!/usr/bin/ruby

# File should be in the same directory
# Eg of file name: 'README.md', 'file.txt' etc

def read_text_from_file
  file_to_read_from = ''
  File.read(file_to_read_from)
end

def write_text_into_file
  file_to_write_into = ''
  body_to_be_written = ''
  File.open("#{__dir__}/#{file_to_write_into}", 'w') do |file|
    file.write(body_to_be_written)
  end
end

# Call whichever function is required
# read_text_from_file
# write_text_into_file
