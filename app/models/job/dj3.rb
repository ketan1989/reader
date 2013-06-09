class Job::Dj3 < Struct.new(:akid)
  
  #DELETE
  
  def perform
    my_feed = MyFeed.find(akid)
    if !my_feed.blank?
      my_feed.my_entries.destroy_all
      my_feed.destroy
    end
  end
  
  #PRIVATE
  private
  
end