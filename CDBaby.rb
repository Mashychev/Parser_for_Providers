require 'nokogiri'
require 'digest/md5'

def cd_baby_batch_parser
	xml_feed = Dir.glob('./**/*.xml').map! do |route| 
		Nokogiri::XML(open(route))
	end
	xml_feed.each_with_object([]) do |feed, hash_sums|
		feed.xpath("//HashSum/HashSum").each do |item|
			hash_sums << item.children.text.upcase
		end
	end
end

def hash_sum_for_batch_files
	Dir.glob('./**/*.{flac,jpg,mp3,mp4}').map do |route|
		Digest::MD5.file(route).to_s.upcase 
	end
end

def all_batches_delivered?
	(cd_baby_batch_parser - hash_sum_for_batch_files).empty?
end