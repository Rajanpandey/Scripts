#!/usr/bin/ruby

# File should be in the same directory

FILE_TO_READ_FROM = ''.freeze
FILE_TO_WRITE_INTO = ''.freeze
BODY_TO_BE_WRITTEN = ''.freeze

def read_text_from_file
  File.read(FILE_TO_READ_FROM)
end

def write_text_into_file
  File.write(FILE_TO_WRITE_INTO, BODY_TO_BE_WRITTEN, mode: 'a')
end

read_text_from_file
write_text_into_file
