class Api::KeywordScrapesController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, only: :download
  
  def index
    @keyword_scrapes = current_user.keyword_scrapes.reverse
  end
  
  def create
    keywords = parse_keywords(keyword_scrape_params[:keywords])
    urls = parse_urls(keyword_scrape_params[:csv_file])
    keyword_scrape = current_user.keyword_scrapes.new(keywords: keywords, urls: urls)
    if keyword_scrape.save
      KeywordScrapeWorker.perform_async(keyword_scrape.id)
      render json: { keyword_scrape: keyword_scrape }, status: :ok
    else
      render json: keyword_scrape.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  def download
    keyword_scrape = KeywordScrape.find(params[:id])
    if keyword_scrape.user_id == current_user.id
      send_data keyword_scrape.to_csv, filename: "scrape_report.csv", type: "application/csv"
    else
      render plain: "forbidden"
    end
  end
  
  private
    
    def keyword_scrape_params
      params.permit(:csv_file, :keywords)
    end
    
    def parse_keywords(string)
      string.split(',').reject(&:blank?).map(&:strip).uniq
    end
    
    def parse_urls(csv)
      csv.read.split("\n").reject(&:blank?).uniq
    end
end