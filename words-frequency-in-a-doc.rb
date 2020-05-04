#!/usr/bin/ruby

# Script to count frequency of every keyword in a pdf or txt file in
# descending order which occurs more than MIN_NO_OF_OCCURRENCES times

FILE_TO_PARSE = ''.freeze
MIN_NO_OF_OCCURRENCES = 1
ACCEPTED_DOC_EXTENTIONS = ['.pdf', '.txt'].freeze

def sort_and_reject_uncommon_words(dictionary)
  dictionary.sort_by(&:last).reverse.to_h.select { |_, value| value >= MIN_NO_OF_OCCURRENCES }
end

def hash_of_word_count(string)
  dictionary = Hash.new(0)
  string.split(' ').each { |word| dictionary[word.downcase] += 1 }
  dictionary
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
  return File.read(file_to_parse) if File.extname(file_to_parse) == '.txt'

  parse_pdf(file_to_parse)
end

def validate_file
  raise 'Provide file name' if FILE_TO_PARSE.strip.empty?
  raise 'File not supported' unless ACCEPTED_DOC_EXTENTIONS.include?(File.extname(FILE_TO_PARSE))
end

validate_file
body = parse_file(FILE_TO_PARSE)
dictionary = hash_of_word_count(body)
pp sort_and_reject_uncommon_words(dictionary)
