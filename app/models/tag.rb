class Tag < ActiveRecord::Base
  
  #GEMS USED
  #ACCESSORS
  attr_accessible :name, :sort_id, :sort_order, :user_id
  
  #ASSOCIATIONS
  belongs_to :user
  has_many :tag_entries
  has_many :my_feeds, through: :tag_entries
  
  #NESTED 
  #VALIDATIONS
  validates :user_id, presence: true
  validates :name, presence: true
  
  #CALLBACKS  
  #SCOPES  
  #OTHER METHODS
  def self.import(u, a_json)
    a_json.each do |t|
      if u.tags.where(name: t[0]).first.blank?
        Tag.create(user_id: u.id, name: t[0], sort_id: t[1])
      end
    end
  end
  
  #JOBS
  #PRIVATE
  private
  
end
