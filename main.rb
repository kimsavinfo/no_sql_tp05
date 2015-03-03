require 'mongo'
require 'mongoid'

# > sudo bundle install
# > ruby import_github_events.rb
# > ruby main.rb

db = Mongo::Connection.new["github"]

puts "=================================="
puts "Number of events by hour"
puts "=================================="
puts db['events'].aggregate([
	{ :$group=>{:_id=>{ hour: {:$hour=>"$created_at"}, type: "$type"}, :count=>{:$sum => 1 } } },
	{ :$sort => {_id: 1}}
])

puts "=================================="
puts "Number of event by hour on the repository 'rails/rails'"
puts "=================================="
puts db['events'].aggregate([
	{:$match=>{ "repo.name" => "rails/rails"}},
	{:$group=>{:_id=>{ hour: {:$hour=>"$created_at"}, type: "$type"}, :count=>{:$sum => 1}}},
	{ :$sort => {_id: 1}}
])

puts "=================================="
puts "Repositories with more than 1000 events"
puts "=================================="
puts db['events'].aggregate([
	{:$group=>{:_id=>{ name: "$repo.name"}, :count=>{:$sum => 1}}},
	{:$match=>{:count=>{ :$gt => 1000 }}},
	{ :$sort=>{count: 1}}
])

puts "=================================="
puts "Order repositories : the most active to the least"
puts "=================================="
puts db['events'].aggregate([
	{ :$group=>{:_id=>{repo: "$repo.name"}, :count=>{:$sum => 1 } } },
	{ :$sort=>{count: -1}}
])

puts "=================================="
puts "Top 10 most active repositories"
puts "=================================="
puts db['events'].aggregate([
	{ :$group=>{:_id=>{repo: "$repo.name"}, :count=>{:$sum => 1 } } },
	{ :$sort=>{count: -1}},
	{ :$limit=>10 }
])


puts "=================================="
puts "The most active repository"
puts "=================================="
puts db['events'].aggregate([
	{ :$group=>{:_id=>{repo: "$repo.name"}, :count=>{:$sum => 1 } } },
	{ :$sort=>{count: -1}},
	{ :$limit=>1 }
])

puts "=================================="
puts "The 5 most active author by hour"
puts "=================================="
puts = db['events'].aggregate([
	{:$group=>{:_id =>{ hour: {:$hour=>"$created_at"}, :user=>"$actor.id"}, :count =>{:$sum => 1}}},
	{:$sort=>{:count=>-1}},
	{:$limit=>5}
])