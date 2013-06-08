class AppKeyUser < ActiveRecord::Base
  
  #GEMS USED
  #ACCESSORS
  attr_accessible :app_key_id, :user_id, :colour, :categories
  
  #ASSOCIATIONS
  belongs_to :app_key
  belongs_to :user
  
  #NESTED 
  #VALIDATIONS
  #CALLBACKS  
  #SCOPES  
  #OTHER METHODS
  def self.import(akid, uid)
    a = AppKeyUser.where(app_key_id: akid, user_id: uid).first
    if a.blank?
      AppKeyUser.create(app_key_id: akid, user_id: uid)
    end
  end
  
  def self.create_and_save(akid, uid, col, cat)
    a = AppKeyUser.where(app_key_id: akid, user_id: uid).first
    if a.blank?
      a = AppKey.new(app_key_id: akid, user_id: uid)
    end
    a.colour = a.colour
    a.categories = a.categories
    a.save
    return a
  end
  
  #JOBS
  #PRIVATE
  private
  
end
