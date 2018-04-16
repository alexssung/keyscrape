class KeywordScrapeWorker
  include Sidekiq::Worker

  def perform(keyword_scrape_id)
    keyword_scrape = KeywordScrape.find(keyword_scrape_id)
    processor = KeywordScrape::Processor.new(keyword_scrape)
    processor.process!
  end
end
