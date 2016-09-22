#!/usr/bin/env ruby

require 'json'

$stderr.puts "Reading Pleiades JSON..."
pleiades_json = JSON.parse(File.read(ARGV[0]))

$stderr.puts "#{pleiades_json['@graph'].length} places"

$stderr.puts "Converting to GeoJSON..."
pleiades_geojson = {}
pleiades_geojson["type"] = "FeatureCollection"
pleiades_geojson["features"] = []

pleiades_json['@graph'].each do |place|
  place['features'].each do |feature|
    pleiades_geojson["features"] << feature
  end
end

$stderr.puts "#{pleiades_geojson["features"].length} features"
puts JSON.pretty_generate(pleiades_geojson)
