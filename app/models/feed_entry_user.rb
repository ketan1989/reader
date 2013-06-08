class FeedEntryUser < ActiveRecord::Base
  
  # CONSTANTS
  STARS = ['star0', 'star1', 'star2', 'star3', 'star4', 'star5', 'star6',
           'star7', 'star8', 'star9', 'star10', 'star11', 'star12']

  #GEMS USED
  #ACCESSORS
  attr_accessible :categories, :current_star, :feed_entry_id, :is_star, :is_to_read, :last_clicked_on, :last_starred_at, :user_id, :app_key_user_id
  
  #ASSOCIATIONS
  belongs_to :feed_entry
  belongs_to :user
  belongs_to :app_key_user
  
  #VALIDATIONS
  validates :feed_entry_id, presence: true
  validates :user_id, presence: true
  validates :app_key_user_id, presence: true
  
  #CALLBACKS
  #SCOPES
  #default_scope order: 'feed_entries.published_at DESC'
  scope :read,    where("last_clicked_on is not null")
  scope :to_read, where(is_to_read: true)
  scope :star,    where(is_star: true)
  
  #CUSTOM SCOPES  
  #OTHER METHODS
  
  def guid
    self.feed_entry.guid
  end
  
  def name
    self.feed_entry.name
  end
  
  def published_at
    self.feed_entry.published_at
  end
  
  def summary
    self.feed_entry.summary
  end
  
  def url
    self.feed_entry.url
  end
  
  def author
    self.feed_entry.author
  end
  
  def content
    self.feed_entry.content
  end
  
  def self.create_and_save(akuid, uid, feid, is_s, is_t_r, l_c_o, cat, l_s_at, c_s)
    f = FeedEntryUser.where(user_id: uid, feed_entry_id: feid, app_key_user_id: akuid).first
    if f.blank?
      f = FeedEntryUser.new(user_id: uid, feed_entry_id: feid, app_key_user_id: akuid)
    end
    f.categories = cat
    f.current_star = c_s 
    f.is_star = is_s
    f.is_to_read = is_t_r
    f.last_clicked_on = l_c_o
    f.last_starred_at = l_s_at
    f.save
  end
  
  def is_read
    self.last_clicked_on.blank? ? false : true
  end
    
  #PRIVATE
  private
  
  
end
