require 'nokogiri'
require 'digest/md5'

def cd_baby_batch_parser
	route_to_xmls = Dir.glob('./**/*.xml')
	xmlfeed = []
	route_to_xmls.each do |route|
		xmlfeed << Nokogiri::XML(open(route))
	end
	hash_sums = []
	xmlfeed.each do |feed|
		items = feed.xpath("//HashSum/HashSum")
		items.each do |item|
			hash_sums << item.children.text
		end
	end
	hash_sums
end

def hash_sum_for_batch_files
	route_to_files = Dir.glob('./**/*.{flac,jpg}')
	files_hash_sums = []
	route_to_files.each do |route|
		files_hash_sums << Digest::MD5.file(route).to_s.upcase 
	end
	files_hash_sums
end

def delivered_method(cd_baby_batch_parser, hash_sum_for_batch_files)
	puts 'All Batches are delivered' if (cd_baby_batch_parser - hash_sum_for_batch_files).empty?
end