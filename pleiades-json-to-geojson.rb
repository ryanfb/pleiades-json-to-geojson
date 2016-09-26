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
  # translate Pleiades place resources to GeoJSON features
  if place['reprPoint'] # omit places with no reprPoint
    place_feature = {}
    place_feature['type'] = 'Feature'
    place_feature['bbox'] = place['bbox'] if place['bbox']
    place_feature['geometry'] = {}
    place_feature['geometry']['type'] = 'Point'
    place_feature['geometry']['coordinates'] = place['reprPoint']
    place_feature['properties'] = {}
    place_feature['properties']['title'] = place['title']
    place_feature['properties']['description'] = place['description']
    place_feature['properties']['link'] = place['uri']
    pleiades_geojson["features"] << place_feature
  end

  # translate Pleiades location resources to GeoJSON features
  place['features'].each do |feature|
    pleiades_geojson["features"] << feature
  end
end

$stderr.puts "#{pleiades_geojson["features"].length} features"
puts JSON.pretty_generate(pleiades_geojson)
