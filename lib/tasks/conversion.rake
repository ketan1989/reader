namespace :conversion do
  
  task :do => :environment do |t, args|
    puts "Destroying Delayed Jobs..."
    DelayedJob.destroy_all
    puts "Destroying Useless TagEntries..."
    TagEntry.where("feed_id is null or tag_id is null").destroy_all
    puts "Updating published at..."
    MyEntry.where("published_at is null").all.each do |e|
      e.update_attributes(published_at: e.entry.published_at)
    end
    puts "Updaing TagEntries..."
    TagEntry.all.each do |t|
      app_key_user = MyFeed.where(feed_id: t.feed_id, user_id: t.tag.user_id).first
      if !app_key_user.blank?
        t.update_attributes(my_feed_id: app_key_user.id)
      end
    end
    puts "Eliminating duplicates..."
    Ref::Feed.select("distinct app_url, count(*) as count").group(:app_url).each do |feed|
      if feed.count.to_i > 1
        app_url = feed.app_url
        new_url_without_http = app_url.gsub("http://", "").gsub("https://", "")
        duplicates = Ref::Feed.where("app_url like '%#{new_url_without_http}%'")
        #Ref::Entry.where("feed_id IN (?)", duplicates.pluck(:id)).select("distinct guid, count(*) as count").group(:guid)
        master = duplicates.first
        duplicates[1..duplicates.length].each do |dup|
          dup.my_feeds.update_all(feed_id: master.id)
        end
        duplicates[1..duplicates.length].each do |s|
          s.destroy
        end
      end
    end
  end
  
  task :test_user_import => :environment do |t, args|
    user = User.where(email: "istoselidas@gmail.com").first
    user.my_feeds.destroy_all
    user.tags.destroy_all
  end
  
  #http://feeds.feedburner.com/wondermark
  #http://news.ycombinator.com/rss
  #http://rss.slashdot.org/Slashdot/slashdot
  #http://syndication.thedailywtf.com/TheDailyWtf
  #http://theoatmeal.com/feed/rss
  #http://timesofindia.indiatimes.com/rssfeedsdefault.cms
  #http://www.cad-comic.com/rss/rss.xml
  #http://www.geekologie.com/index.xml
  #http://www.ibnlive.com/xml/rss/India.xml
  #http://www.ibnlive.com/xml/top.xml
  #http://www.ndtv.com/convergence/ndtv/rssint.asp
  #http://www.passiveaggressivenotes.com/feed/
  #http://www.questionablecontent.net/QCRSS.xml
  #http://www.rsspect.com/rss/asw.xml
  #http://www.smbc-comics.com/rss.php
  #http://www.theverge.com/rss/index.xml
  #http://xkcd.com/rss.xml
  #https://news.ycombinator.com/rss
  
    
end