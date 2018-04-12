class Api::KeywordScrapesController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, only: :download
  
  def index
    @keyword_scrapes = current_user.keyword_scrapes
  end
  
  def download
    keyword_scrape = KeywordScrape.find(params[:id])
    if keyword_scrape.user_id == current_user.id
      send_data keyword_scrape.to_csv, filename: "scrape_report.csv", type: "application/csv"
    else
      render text: "forbidden"
    end
  end
end