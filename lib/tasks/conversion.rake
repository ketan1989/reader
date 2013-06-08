namespace :conversion do
  
  task :do => :environment do |t, args|
    AppKey.each do |a|
      aku = AppKeyUser.create_and_save(a.id, a.user_id, a.colour, a.categories)
      a.feed_entries.each do |f|
        FeedEntryUser.create_and_save(a.id, aku.id, a.user_id, f.id, f.is_star, f.is_to_read, f.last_clicked_on, f.categories, f.last_starred_at, f.current_star)
      end
    end
  end
    
  task :fav => :environment do |t, args|
  end
  
end