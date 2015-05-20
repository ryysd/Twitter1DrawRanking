namespace :one_draw do
  namespace :illust do

    desc 'fetch illusts from twitter'
    task :fetch, [:genre_id] => :environment do |t, args|
      logger = Logger.new('log/fetch.log')
      genre = Genre.find_by_id args.genre_id

      logger.info "#{Time.now} -- #{genre.name} fetch start --"
      begin
        tweets = Tweet.fetch genre
        logger.info "#{Time.now} -- #{genre.name} fetch end (#{tweets.size} fetched)--"
        logger.info ""
      rescue => e
        logger.info "#{Time.now} -- #{genre.name} fetch error (#{e}) --"
        logger.info e.backtrace
      end
    end

    desc 'update tweet values '
    task :update, [:genre_id] => :environment do |t, args|
      logger = Logger.new('log/update.log')
      genre = Genre.find_by_id args.genre_id

      logger.info "#{Time.now} -- #{genre.name} update start --"
      begin
        values = Tweet.update genre
        logger.info "#{Time.now} -- #{genre.name} update end (#{values.size} updated)--"
      rescue => e
        logger.info "#{Time.now} -- #{genre.name} update error (#{e})--"
      end
    end

    desc ''
    task update_and_fetch: :environment do
      (3..4).each do |i|
        Rake::Task["one_draw:illust:update"].invoke i
        Rake::Task["one_draw:illust:fetch"].invoke i

        Rake::Task["one_draw:illust:update"].reenable
        Rake::Task["one_draw:illust:fetch"].reenable
      end
    end
  end
end
