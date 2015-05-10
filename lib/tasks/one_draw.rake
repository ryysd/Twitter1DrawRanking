namespace :one_draw do
  namespace :illust do

    desc 'fetch illusts from twitter'
    task :fetch, [:genre_id] => :environment do |t, args|
      logger = Logger.new('log/fetch.log')
      genre = Genre.find_by_id args.genre_id

      logger.info "#{Time.now} -- #{genre.hash_tag} fetch start --"
      begin
        tweets = Tweet.fetch genre
        logger.info "#{Time.now} -- #{genre.hash_tag} fetch end (#{tweets.size} fetched)--"
      rescue => e
        logger.info "#{Time.now} -- #{genre.hash_tag} fetch error (#{e}) --"
        logger.info e.backtrace
      end
    end

    desc 'update tweet values '
    task :update, [:genre_id] => :environment do |t, args|
      logger = Logger.new('log/update.log')
      genre = Genre.find_by_id args.genre_id

      logger.info "#{Time.now} -- update start --"
      begin
        values = Tweet.update genre
        logger.info "#{Time.now} -- update end (#{values.size} updated)--"
      rescue => e
        logger.info "#{Time.now} -- update error (#{e})--"
        logger.info e.backtrace
      end
    end

    desc ''
    task update_and_fetch: :environment do
      Rake::Task["one_draw:illust:update"].invoke 2
      Rake::Task["one_draw:illust:fetch"].invoke 2
    end
  end
end
