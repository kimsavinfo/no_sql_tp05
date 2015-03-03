require 'open-uri'
require 'zlib'
require 'yajl'
require 'mongo'
require 'mongoid'

# > sudo mongod
# > ruby main.rb

# Connection with MongoDB and drop the connection
db = Mongo::Connection.new["github"]
db.collection("events").drop

# Set which day we want to import
year = "2015"
month = "01"
day = "01"

# Save github events in the collection "events"
(0..23).each do |hour|
	puts "Hour #{hour}"
	gitUri = "http://data.githubarchive.org/#{year}-#{month}-#{day}-#{hour}.json.gz"
	puts gitUri
	gz = open(URI.encode(gitUri))
	js = Zlib::GzipReader.new(gz).read

	Yajl::Parser.parse(js) do |event|
		event['created_at'] = Time.parse(event['created_at'])
		db['events'] << event
	end
end