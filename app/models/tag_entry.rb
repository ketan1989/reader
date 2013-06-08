class TagEntry < ActiveRecord::Base
  
  #GEMS USED
  #ACCESSORS
  attr_accessible :app_key_id, :tag_id
  
  #ASSOCIATIONS
  belongs_to :app_key
  belongs_to :tag
  
  #NESTED 
  #VALIDATIONS
  #CALLBACKS  
  #SCOPES  
  #OTHER METHODS
  def self.import(akid, tgid)
    a = TagEntry.where(app_key_id: akid, tag_id: tgid).first
    if a.blank?
      TagEntry.create(app_key_id: akid, tag_id: tgid)
    end
  end
  
  #JOBS
  #PRIVATE
  private
  
end
