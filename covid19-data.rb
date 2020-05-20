#!/usr/bin/ruby

require 'net/http'
require 'json'

URL = 'https://api.covid19india.org/state_district_wise.json'.freeze
uri = URI(URL)
response = Net::HTTP.get(uri)
DISTRICT_WISE_DATA = JSON.parse(response).freeze
CASE_TYPE = %w[confirmed active recovered deceased].freeze
NO_OF_CASES_TO_FETCH = 64
MIN_NUMBER_OF_CASES = 100

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
  data ? "#{data[0].ljust(19)} #{data[1].to_s.rjust(5)}" : ' '.ljust(25)
end

def gridview(confirmed, active, recovered, deceased)
  ans = '_' * 141

  ans += "\n|   Index   |"
  CASE_TYPE.each do |case_type|
    ans += "   #{case_type.capitalize.ljust(19)} #{'Count'.rjust(5)}   |"
  end

  ans += "\n|#{'-' * 139}|\n"

  (0..NO_OF_CASES_TO_FETCH - 1).each do |row|
    ans += "|   #{(row + 1).to_s.ljust(5)}   "
    ans += "|   #{fill_cell(confirmed[row])}   "
    ans += "|   #{fill_cell(active[row])}   "
    ans += "|   #{fill_cell(recovered[row])}   "
    ans += "|   #{fill_cell(deceased[row])}   |\n"
  end

  ans += '_' * 141
end

confirmed, active, recovered, deceased = CASE_TYPE.map do |case_type|
  parse_district_wise_data(case_type)
end

puts gridview(confirmed.to_a, active.to_a, recovered.to_a, deceased.to_a)
