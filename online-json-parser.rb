#!/usr/bin/ruby

require 'net/http'
require 'json'

# eg: https://api.covid19india.org/state_district_wise.json
URL = ''.freeze
uri = URI(URL)
response = Net::HTTP.get(uri)
json = JSON.parse(response).freeze

pp json
