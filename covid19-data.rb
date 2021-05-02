#!/usr/bin/ruby

require 'net/http'
require 'json'

NO_OF_DISTRICTS_TO_FETCH = 64
MIN_NUMBER_OF_CASES = 0
CASE_TYPES = %w[confirmed active recovered deceased].freeze
STATES_WITH_MISSING_DISTRICT_DATA = ['Andaman and Nicobar Islands', 'Assam', 'Delhi', 'Goa', 'Manipur', 'Sikkim', 'Telangana'].freeze

URL = 'https://api.covid19india.org/state_district_wise.json'.freeze
uri = URI(URL)
response = Net::HTTP.get(uri)
DISTRICT_WISE_DATA = JSON.parse(response).freeze

def parse_district_wise_data(case_type)
  district_case_count = {}
  DISTRICT_WISE_DATA.each do |state, state_data|
    if STATES_WITH_MISSING_DISTRICT_DATA.include?(state)
      state_case_count = state_data['districtData'].values.map { |val| val[case_type] }.reduce(&:+)
      district_case_count[state] = state_case_count if state_case_count > MIN_NUMBER_OF_CASES
    else
      state_data['districtData'].each do |district, district_data|
        district_case_count[district] = district_data[case_type] if district_data[case_type] > MIN_NUMBER_OF_CASES
      end
    end
  end
  district_case_count.sort_by(&:last).reverse.to_h
end

def table(confirmed, active, recovered, deceased)
  table_string = '_' * 169

  # Header
  table_string += "\n|   Index   |"
  CASE_TYPES.each do |case_type|
    table_string += "   #{case_type.capitalize.ljust(25)} #{'Count'.rjust(6)}   |"
  end

  table_string += "\n|#{'-' * 167}|\n"

  # Body
  def separate_number_with_commas(number) number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse end
  def fill_cell(cell_data) "#{cell_data[0].ljust(22)} #{separate_number_with_commas(cell_data[1]).to_s.rjust(9)}" end
  (0..NO_OF_DISTRICTS_TO_FETCH - 1).each do |row|
    table_string += "|   #{(row + 1).to_s.ljust(5)}   "
    table_string += "|   #{fill_cell(confirmed[row])}   "
    table_string += "|   #{fill_cell(active[row])}   "
    table_string += "|   #{fill_cell(recovered[row])}   "
    table_string += "|   #{fill_cell(deceased[row])}   |\n"
  end

  table_string += '_' * 169
end

# Main
confirmed, active, recovered, deceased = CASE_TYPES.map { |case_type| parse_district_wise_data(case_type) }
puts table(confirmed.to_a, active.to_a, recovered.to_a, deceased.to_a)
