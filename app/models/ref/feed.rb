class Ref::Feed < ActiveRecord::Base
  
  #GEMS USED
  #ACCESSORS
  attr_accessible :app_url, :entity_name, :is_pending, :last_processed, :last_requested_processing, :incoming_channel, :rss_last_modified_at, :html_url
  
  attr_accessor :incoming_channel
    
  #ASSOCIATIONS
  has_many    :entries   , dependent: :destroy, class_name: "Ref::Entry"
  has_many    :my_feeds, dependent: :destroy
  
  #VALIDATIONS
  validates :app_url, :format => URI::regexp(%w(http https)), :presence => true, :uniqueness => { case_sensitive: false }, :length => { :minimum => 11 }
  
  #CALLBACKS
  before_create :before_create_set
  after_create :after_create_set
  
  #SCOPES
  #CUSTOM SCOPES
  #OTHER METHODS
    
  def self.import(u, a_json)
    a_json.each do |t|
      url_u = Ref::Feed.sanitise_url(t[0])
      feed_exists = Ref::Feed.where(app_url: url_u).first
      if feed_exists.blank?
        feed_exists = Ref::Feed.new(app_url: url_u, entity_name: t[1], html_url: t[2])
        feed_exists.save
        exists = false
      else
        exists = true
      end
      if !feed_exists.blank?
        if !feed_exists.id.blank?
          my_feed = MyFeed.create_and_save(feed_exists.id, u.id, t[3])
          if exists
            Delayed::Job.enqueue Job::Dj2.new(my_feed.id, u.id)
          end
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
  end
  
  def to_s
    self.entity_name
  end
  
  def self.sanitise_url(a)
    if !a.blank?
      return a.gsub("feed/http://", "http://").gsub("feed/https://", "http://").gsub("https://", "http://")
    end
    return a
  end
      
  #JOBS
  #PRIVATE
  
  private
  
  def after_create_set
    Delayed::Job.enqueue Job::Dj1.new(self.id)
    true
  end
  
  def before_create_set
    self.app_url = Ref::Feed.sanitise_url(self.app_url)
    self.entity_name = URI(self.app_url).host if self.entity_name.blank?
  	self.last_requested_processing = Time.now
  	self.last_processed = nil
  	#self.html_url = "http://" + URI(self.app_url).host if self.html_url.blank?
  	true
  end
    
end
