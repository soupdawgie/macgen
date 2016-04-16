# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Query.create!(amount: 700, vendor: "00abcd", start: "0000ff", separator: ":")
Query.create!(amount: 100, vendor: "001fce", start: "000000", separator: "-")
Query.create!(amount: 500, vendor: "001fce", start: "fa628a", separator: ":")
