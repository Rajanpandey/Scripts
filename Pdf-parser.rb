#!/usr/bin/ruby

# system 'gem install pdf-reader'
require 'rubygems'
require 'pdf/reader'

# Pdf file in the same directory
filename = ""

PDF::Reader.open(filename) do |reader|
    reader.pages.each do |page|
        puts page.text
    end
end
