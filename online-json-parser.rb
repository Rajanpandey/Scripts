#!/usr/bin/ruby

require 'net/http'
require 'json'

MIN_NUM_OF_CASES = 400

# eg: https://api.covid19india.org/state_district_wise.json
URL = ''.freeze
uri = URI(URL)
response = Net::HTTP.get(uri)
json = JSON.parse(response).freeze

pp json
