#!/usr/bin/env ruby

require 'rubygems'
require 'rapidshare'

files_to_download = %w{
  https://rapidshare.com/files/829628035/HornyRhinos.jpg
  https://rapidshare.com/files/3103991314/HappyHippos.jpg
  https://rapidshare.com/files/3882189288/ElegantElephants.jpg
}

rs = Rapidshare::API.new(:login => 'my_login', :password => 'my_password')

files_to_download.each do |file|
  result = rs.download(file)
  puts "[#{file}] cannot be downloaded: #{result.error}" unless result.downloaded? 
end
