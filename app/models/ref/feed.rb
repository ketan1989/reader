class Ref::Feed < ActiveRecord::Base
  
  #GEMS USED
  #ACCESSORS
  attr_accessible :app_url, :entity_name, :is_pending, :last_processed, :last_requested_processing, :incoming_channel, :rss_last_modified_at, :html_url
  
  attr_accessor :incoming_channel
    
  #ASSOCIATIONS
  has_many    :entries   , dependent: :destroy, class_name: "Ref::Entry"
  has_many    :my_feeds, dependent: :destroy
  
  #VALIDATIONS
  validates :app_url, :format => URI::regexp(%w(http https)), :presence => true
  
  #CALLBACKS
  before_create :before_create_set
  after_create :after_create_set
  
  #SCOPES
  #CUSTOM SCOPES
  #OTHER METHODS
    
  def self.import(u, a_json)
    a_json.each do |t|
      url_u = t[0].gsub("feed/http://", "http://")
      feed_exists = Ref::Feed.create_and_save(url_u, t[1], t[2])
      if !feed_exists.blank?
        my_feed = MyFeed.create_and_save(feed_exists.id, u.id, t[3])
        if !t[5].blank?
          if !t[5].first.blank?
            t[5].each do |t_g|
              tag_o = u.tags.where(name: t_g).first
              if !tag_o.blank?
                TagEntry.import(my_feed.id, tag_o.id)
              end              
            end
          end
        end
      end
    end
  end
  
  def self.create_and_save(u, e, h)
    feed_exists = Ref::Feed.where(app_url: u).first
    if feed_exists.blank?
      feed_exists = Ref::Feed.new(app_url: u, entity_name: e, html_url: h)
      feed_exists.save
    end
    return feed_exists
  end
  
  def to_s
    self.entity_name
  end
      
  #JOBS
  #PRIVATE
  
  private
  
  def after_create_set
    Delayed::Job.enqueue Job::Dj1.new(self.id)
    true
  end
  
  def before_create_set
    self.entity_name = URI(self.app_url).host if self.entity_name.blank?
  	self.last_requested_processing = Time.now
  	self.last_processed = nil
  	#self.html_url = "http://" + URI(self.app_url).host if self.html_url.blank?
  	true
  end
    
end
