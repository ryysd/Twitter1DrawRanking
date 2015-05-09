namespace :one_draw do
  namespace :illust do

    desc 'fetch illusts from twitter'
    task :fetch, [:genre_id] => :environment do |t, args|
      logger = Logger.new('log/fetch.log')
      genre = Genre.find_by_id args.genre_id

      logger.info "#{Time.now} -- #{genre.hash_tag} fetch start --"
      begin
        tweets = genre.fetch
        logger.info "#{Time.now} -- #{genre.hash_tag} fetch end (#{tweets.size} fetched)--"
      rescue => e
        logger.info "#{Time.now} -- #{genre.hash_tag} fetch error (#{e}) --"
      end
    end

    desc 'update values of tweet in DB'
    task :update => :environment do
      logger = Logger.new('log/update.log')

      to = Time.now
      from = Time.now - (60 * 60 * 24)

      logger.info "#{Time.now} -- update start --"
      begin
        values = Tweet.update_values_by_updated_at from...to
        logger.info "#{Time.now} -- update end (#{values.size} updated)--"
      rescue => e
        logger.info "#{Time.now} -- update error (#{e})--"
      end
    end

    task fetch_and_update: :environment do
    end

    desc ''
    task fetch_and_update: :environment do
      Rake::Task["one_draw:illust:fetch"].invoke 2
      Rake::Task["one_draw:illust:update"].execute
    end
  end
end
