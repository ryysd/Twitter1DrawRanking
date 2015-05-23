# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

UserStatus.create id: 1, value: 'none'
UserStatus.create id: 2, value: 'black_listed'
UserStatus.create id: 3, value: 'white_listed'

Genre.create id: 1, name: 'オリジナル', alias: 'original', hash_tag: '', start_time: '00:00:00'
Genre.create id: 2, name: '艦これ', alias: 'kancolle', hash_tag: '艦これ版深夜の真剣お絵描き60分一本勝負', start_time: '22:00:00'
Genre.create id: 3, name: '東方', alias: 'toho', hash_tag: '深夜の真剣お絵描き60分一本勝負', start_time: '22:00:00'
Genre.create id: 4, name: '背景', alias: 'background', hash_tag: '背景版深夜の真剣お絵描き60分一本勝負', start_time: '23:00:00'

RankingType.create id: 1, name: 'hourly'
RankingType.create id: 2, name: 'daily'
RankingType.create id: 3, name: 'weekly'
