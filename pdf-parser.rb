#!/usr/bin/ruby

# system 'gem install pdf-reader'
require 'rubygems'
require 'pdf/reader'

# Pdf file in the same directory
FILE_NAME = ''

def validate_file
  raise 'Provide file name' if FILE_TO_PARSE.strip.empty?
  raise 'File not supported' unless File.extname(FILE_NAME) == '.pdf'
end

validate_file
PDF::Reader.open(FILE_NAME) do |reader|
  reader.pages.each do |page|
    puts page.text
  end
end
