#!/usr/bin/env ruby1.9.1

require "net/http"
require "uri"
require 'nokogiri'

if ARGV[0]
  file = File.new(ARGV[0])
  isbn = ARGV[0].match('^\d*')[0]
  
  puts "Requesting information for ISBN: ${isbn}"
else
  isbn = '3836215012'
end

uri = URI.parse('http://books.google.com/books/feeds/volumes?q=' + isbn)

http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)

response = http.request(request)

doc = Nokogiri::XML(response.body)             # => The body (HTML, XML, blob, whatever)

t = ''
i=0
doc.xpath('//dc:title').each do |title|
  if i > 0
    t += '.-.'
  end
  
  t += title.text.split(' ').join('.')
  i +=1
end

t += '.-.'

doc.xpath('//dc:creator').each do |author|
  t += author.text.split(' ').join('.')
  i +=1
end

t += '.'

doc.xpath('//dc:date').each do |date|
  t += date.text.split(' ').join('.')
  i +=1
end


puts t