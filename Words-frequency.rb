#!/usr/bin/ruby

# Script to count frequency of every keyword in a document in descending order

def count_words(string)
  frequency = Hash.new(0)
  string.split(' ').each { |word| frequency[word.downcase] += 1 }
  frequency.sort_by(&:last).reverse.to_h
end

def parse_pdf(pdf_file_to_parse)
  # system 'gem install pdf-reader'
  require 'rubygems'
  require 'pdf/reader'
  text_string = ''
  PDF::Reader.open(pdf_file_to_parse) do |reader|
    reader.pages.each do |page|
      text_string += page.text
    end
  end
  text_string
end

def parse_file(file_to_parse)
  return File.read(file_to_parse) unless File.extname(file_to_parse) == '.pdf'

  parse_pdf(file_to_parse)
end

# File can be any text file or a pdf
file_to_parse = ''
body = parse_file(file_to_parse)

pp count_words(body)
