#!/usr/bin/ruby

require 'net/http'
require 'json'

URL = 'https://api.covid19india.org/state_district_wise.json'.freeze
uri = URI(URL)
response = Net::HTTP.get(uri)
DISTRICT_WISE_DATA = JSON.parse(response).freeze

def parse_district_wise_data(case_type, min_number_of_cases = 0)
  delhi_cases_count = 0
  districts_with_min_num_of_cases = {}
  DISTRICT_WISE_DATA.each do |state, state_data|
    state_data['districtData'].each do |district, district_data|
      districts_with_min_num_of_cases[district] = district_data[case_type] if state != 'Delhi' && district_data[case_type] > min_number_of_cases
      delhi_cases_count += district_data[case_type] if state == 'Delhi'
    end
  end
  districts_with_min_num_of_cases['Delhi'] = delhi_cases_count if delhi_cases_count > min_number_of_cases
  districts_with_min_num_of_cases.sort_by(&:last).reverse.to_h
end

def districts_with_min_num_of_confirmed_cases
  parse_district_wise_data('confirmed')
end

def districts_with_min_num_of_active_cases
  parse_district_wise_data('active')
end

def districts_with_min_num_of_recovered_cases
  parse_district_wise_data('recovered')
end

def districts_with_min_num_of_deceased_cases
  parse_district_wise_data('deceased')
end

pp districts_with_min_num_of_confirmed_cases
pp districts_with_min_num_of_active_cases
pp districts_with_min_num_of_recovered_cases
pp districts_with_min_num_of_deceased_cases
