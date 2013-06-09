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
  
  def self.add_entries(ak, entries)
    entries.each do |entry|
      a = Ref::Entry.where(feed_id: ak.id, guid: entry.id).first
      if a.blank?
        a = Ref::Entry.new(feed_id: ak.id, guid: entry.id, name: entry.title, summary: entry.summary, content: entry.content, url: entry.url, published_at: entry.published.blank? ? Time.now : entry.published, author: entry.author)
        a.save
      end
      ak.my_feeds.each do |my_f|
        feu = MyEntry.create_and_save(my_f.id, my_f.user_id, a.id)
        feu.update_attributes(categories: entry.categories)
      end
    end
  end
  
  #PRIVATE
  private
  
end
