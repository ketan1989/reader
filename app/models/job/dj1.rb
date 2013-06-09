class Job::Dj1 < Struct.new(:akid)
    
  def perform
    ak = Ref::Feed.find(akid)
    entries = nil
    feed = Feedzirra::Feed.fetch_and_parse(ak.app_url)
    if !feed.blank?
      if feed.class.to_s != "Fixnum"
        if ak.last_processed.blank? or (!ak.last_processed.blank? and ((Time.now - ak.last_processed)/3600) > 2 and !ak.last_processed.blank?) or ak.entries.first.blank?
          #if first_time
            if ak.entity_name.blank? or ak.html_url.blank?
              ak.update_attributes(entity_name: feed.title, html_url: feed.url)
            end
            entries = feed.entries
          #else
            #updated_feed = Feedzirra::Feed.update(feed)
            #if !updated_feed.blank?
              #if updated_feed.class.to_s != "Fixnum"
                #if !updated_feed.first.blank?
                  #if updated_feed.updated?
                    #entries = updated_feed.new_entries
                  #end
                #end
              #end
            #end
          #end
          if !entries.blank?
            Ref::Entry.add_entries(ak, entries)
          end
          ak.update_attributes(is_pending: "done", last_processed: Time.now, rss_last_modified_at: feed.last_modified)
        end
      end
    end
  end
  
end