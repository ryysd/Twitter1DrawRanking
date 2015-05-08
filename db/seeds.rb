# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Genre.create id: 1, name: '艦これ', hash_tag: '艦これ版深夜の真剣お絵描き60分一本勝負'
Genre.create id: 2, name: 'わんどろ', hash_tag: '深夜の真剣お絵描き60分一本勝負'

RankingType.create id: 1, name: 'hourly'
RankingType.create id: 2, name: 'daily'
RankingType.create id: 3, name: 'monthly'
