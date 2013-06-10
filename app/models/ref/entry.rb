class Ref::Entry < ActiveRecord::Base
  
  # CONSTANTS
  #GEMS USED
  #ACCESSORS
  attr_accessible :feed_id, :guid, :name, :published_at, :summary, :url, :author, :content
  
  #ASSOCIATIONS
  belongs_to :feed, class_name: "Ref::Feed"
  
  #VALIDATIONS
  validates :feed_id, presence: true
  validates :guid, presence: true
  validates :url, presence: true
  
  #CALLBACKS
  #SCOPES
  #CUSTOM SCOPES  
  #OTHER METHODS
  #PRIVATE
  private
  
end
