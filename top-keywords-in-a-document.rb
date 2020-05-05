#!/usr/bin/ruby
require 'json'

MIN_NO_OF_OCCURRENCES = 1
ACCEPTED_DOC_EXTENTIONS = ['.pdf', '.txt'].freeze
MEGA_DICTIONARY_NAME = 'Mega Dictionary'.freeze
OUTPUT_FILE = 'result.txt'.freeze

def write_output_to_file(file_name, dictionary)
  File.write(OUTPUT_FILE, "#{file_name}: \n #{JSON.pretty_generate(sort_and_reject_uncommon_words(dictionary))} \n\n", mode: 'a')
end

def sort_and_reject_uncommon_words(dictionary)
  dictionary.sort_by(&:last).reverse.to_h.select { |_, value| value >= MIN_NO_OF_OCCURRENCES }
end

def add_dictionary_to_mega_dictionary(dictionary, mega_dictionary)
  dictionary.each { |word, count| mega_dictionary[word] += count }
end

def dictionary_of_word_count(document_body)
  dictionary = Hash.new(0)
  document_body.split(' ').each { |word| dictionary[word.downcase] += 1 }
  dictionary
end

def format_body(body)
  body.gsub!(/[^a-z0-9\s]/i, '')
end

def parse_pdf(pdf_file_to_parse)
  # If running for the first time, either run 'gem install pdf-reader' in cmd
  # or uncomment the line below for one time (otherwise it'll install the gem every time you run the script)
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

def documents_in_this_directory
  Dir.entries('.').select! { |file_name| ACCEPTED_DOC_EXTENTIONS.include?(File.extname(file_name)) }
end

mega_dictionary = Hash.new(0)
documents_in_this_directory.each do |file_name|
  body = parse_file(file_name)
  formatted_body = format_body(body)
  dictionary = dictionary_of_word_count(formatted_body)
  add_dictionary_to_mega_dictionary(dictionary, mega_dictionary)
  # Comment below line if you dont want individual dictionary of every document in the output file
  write_output_to_file(file_name, dictionary)
end
write_output_to_file(MEGA_DICTIONARY_NAME, mega_dictionary)
