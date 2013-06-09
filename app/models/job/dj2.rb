class Job::Dj2 < Struct.new(:my_feed_id, :uid)
  
  #add my_entries to new user from existing feed
    
  def perform
    ak = MyFeed.find(my_feed_id).feed
    ak.entries.each do |a|
      MyEntry.create_and_save(my_feed_id, uid, a.id)
    end
  end
  
end