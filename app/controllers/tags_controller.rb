class TagsController < ApplicationController
  
  before_filter :authenticate_user!, :allowed?  

  private
  
  def allowed?
  end
  
end
