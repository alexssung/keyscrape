# Model for scraping keyword counts from a list of urls and storing result
class KeywordScrape < ApplicationRecord
  require 'open-uri'
  
  belongs_to :user
  
  def completed?
    completed_at.present?
  end
  
  # performs scraping based on its urls and keywords
  def scrape!
    result = {}
    threads = []
    keywords = keywords.map(&:downcase)
    urls.each do |url|
      threads << Thread.new do
        begin
          retries ||= 0
          url = "http://#{url}" if URI.parse(url).scheme.nil?
          file = open(url)
          response_uri = file.base_uri # store response_uri in case of redirects
          doc = Nokogiri::HTML(file)
          inner_text = doc.at('body')&.inner_text
          Thread.exit if inner_text.nil?
          result[url] ||= {}
          # count keyword occurrences in page
          keywords.each do |keyword|
            keyword_count = inner_text.downcase.scan(/#{keyword}/).count
            result[url][keyword] = keyword_count
          end
          # get all relevant links on page
          links = doc.at('body').css('a')
          hrefs = links.collect { |link| link.attribute('href').to_s }.uniq!
          hrefs.select! do |href|
            uri = URI.parse(href) rescue next
            next if ["javascript","mailto","tel"].include?(uri.scheme)
            if uri.instance_of?(URI::HTTPS) || uri.instance_of?(URI::HTTP)
              uri.host == response_uri.host
            else
              true
            end
          end
          sub_urls = hrefs.map { |href| URI.join(response_uri.to_s, href).to_s }.uniq
          # scrape all subpages for keywords as well
          sub_urls.each do |sub_url|
            doc = Nokogiri::HTML(open(sub_url)) rescue next
            inner_text = doc.at('body')&.inner_text
            next if inner_text.nil?
            keywords.each do |keyword|
              keyword_count = inner_text.downcase.scan(/#{keyword}/).count
              result[url][keyword] += keyword_count
            end
          end
        rescue StandardError => e
          self.scrape_errors << e.inspect
          Thread.exit
        end
      end
    end
    threads.each(&:join)
    self.result = result
    self.completed_at = Time.current
    self.save
  end
end