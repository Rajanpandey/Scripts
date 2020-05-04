#!/usr/bin/ruby
require 'json'

# Modify the MIN_NO_OF_OCCURRENCES value acc to your need
MIN_NO_OF_OCCURRENCES = 1
OUTPUT_FILE = 'result.txt'.freeze
$mega_dictionary = Hash.new(0)

def write_output_to_file(file_name, dictionary)
  File.open("#{__dir__}/#{OUTPUT_FILE}", 'a') { |output_file| output_file.write("#{file_name}: \n #{JSON.pretty_generate(sort_and_reject_uncommon_words(dictionary))} \n\n") }
end

def sort_and_reject_uncommon_words(dictionary)
  dictionary.sort_by(&:last).reverse.to_h.select { |_, value| value >= MIN_NO_OF_OCCURRENCES }
end

def dictionary_of_word_count(string)
  frequency = Hash.new(0)
  string.split(' ').each { |word| frequency[word.downcase] += 1 }
  frequency.each { |word, count| $mega_dictionary[word] += count }
  frequency
end

def parse_pdf(pdf_file_to_parse)
  # If running for the first time, either run 'gem install pdf-reader' in cmd or uncomment the line below for one time
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

def documents_in_this_directory
  Dir.entries('.').select! { |file_name| File.extname(file_name) == '.pdf' || File.extname(file_name) == '.doc' || File.extname(file_name) == '.docx' }
end

documents_in_this_directory.each do |file_name|
  body = parse_file(file_name)
  # Comment below line if you dont want individual dictionary of every document in the output file
  write_output_to_file(file_name, dictionary_of_word_count(body))
end
write_output_to_file('Mega Dictionary', $mega_dictionary)
