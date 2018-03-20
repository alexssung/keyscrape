class KeywordScrapeWorker
  include Sidekiq::Worker

  def perform(keyword_scrape_id)
    keyword_scrape = KeywordScrape.find(keyword_scrape_id)
    keyword_scrape.scrape!
  end
end
