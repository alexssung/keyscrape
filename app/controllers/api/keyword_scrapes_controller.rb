class Api::KeywordScrapesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @keyword_scrapes = current_user.keyword_scrapes
  end
end