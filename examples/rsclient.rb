#!/usr/bin/env ruby
#
# rsclient.rb is a simple rapidshare download client build over rapidshare gem
#
# * loads rapidshare settings from external YAML file
#   (default: ~/.rapidshare, configurable in RSCONFIG environment variable)
#
# * loads list of files from a queue - separate txt file
#   (default: ./queue_example.txt, configurable in YAML file)
#
# * saves files into specific directory
#   (default: current dir, configurable in YAML file)
#
require 'rubygems'
require 'rapidshare'
require 'yaml'

# load rapidshare settings from YAML file
# default: ~/.rapidshare, configurable in RSCONFIG environment variable
#
# example of YAML config file:
# :login: 'your_login'
# :password: 'your_password'
# :cookie: 'your_cookie'
# :queue: 'path_to_queue/queue_file'
# :downloads_dir: 'path_to_downloads_dir'
#
file_path = ENV['RSCONFIG'] || File.join(ENV['HOME'],'.rapidshare')
settings = YAML::load(File.read(file_path))

# PS: Rapidshare API uses cookie if it's set, otherwise uses login and password
rs = Rapidshare::API.new(settings)

# use queue_example from current directory by default
settings[:queue] ||= 'queue_example.txt'

# parse files from file into array, omit blank lines and comments
files_to_download = File.read(settings[:queue]).split(/\s*\n\s*/).select do |line|
  line =~ /^https?\:\/\/rapidshare\.com\/files\/\d+\//
end

# download files to current directory by default
settings[:downloads_dir] ||= Dir.pwd

files_to_download.each do |file|
  result = rs.download(file, :downloads_dir => settings[:downloads_dir])
  puts "[#{file}] cannot be downloaded: #{result.error}" unless result.downloaded? 
end
