#!/usr/bin/ruby

require 'net/http'
require 'json'

NO_OF_DISTRICTS_TO_FETCH = 64
MIN_NUMBER_OF_CASES = 0
CASE_TYPE = %w[confirmed active recovered deceased].freeze
URL = 'https://api.covid19india.org/state_district_wise.json'.freeze
uri = URI(URL)
response = Net::HTTP.get(uri)
DISTRICT_WISE_DATA = JSON.parse(response).freeze

def parse_district_wise_data(case_type)
  delhi_cases_count = 0
  districts_with_min_num_of_cases = {}
  DISTRICT_WISE_DATA.each do |state, state_data|
    state_data['districtData'].each do |district, district_data|
      districts_with_min_num_of_cases[district] = district_data[case_type] if state != 'Delhi' && district_data[case_type] > MIN_NUMBER_OF_CASES
      delhi_cases_count += district_data[case_type] if state == 'Delhi'
    end
  end
  districts_with_min_num_of_cases['Delhi'] = delhi_cases_count if delhi_cases_count > MIN_NUMBER_OF_CASES
  districts_with_min_num_of_cases.sort_by(&:last).reverse.to_h
end

def fill_cell(data)
  data ? "#{data[0].ljust(25)} #{data[1].to_s.rjust(5)}" : ' '.ljust(31)
end

def table(confirmed, active, recovered, deceased)
  table_string = '_' * 165

  table_string += "\n|   Index   |"
  CASE_TYPE.each do |case_type|
    table_string += "   #{case_type.capitalize.ljust(25)} #{'Count'.rjust(5)}   |"
  end

  table_string += "\n|#{'-' * 163}|\n"

  (0..NO_OF_DISTRICTS_TO_FETCH - 1).each do |row|
    table_string += "|   #{(row + 1).to_s.ljust(5)}   "
    table_string += "|   #{fill_cell(confirmed[row])}   "
    table_string += "|   #{fill_cell(active[row])}   "
    table_string += "|   #{fill_cell(recovered[row])}   "
    table_string += "|   #{fill_cell(deceased[row])}   |\n"
  end

  table_string += '_' * 165
end

confirmed, active, recovered, deceased = CASE_TYPE.map do |case_type|
  parse_district_wise_data(case_type)
end

puts table(confirmed.to_a, active.to_a, recovered.to_a, deceased.to_a)
