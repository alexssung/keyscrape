# Processor for KeywordScrape
# Fetches keyword occurence counts from urls (and their subpages) and storing result in @keyword_scrape
class KeywordScrape::Processor
  require 'open-uri'
  
  delegate :urls, :keywords, to: :@keyword_scrape
  
  def initialize(keyword_scrape)
    @keyword_scrape = keyword_scrape
  end
  
  # performs scraping and stores result in @keyword_scrape
  def process!
    result = {}
    errors = []
    keywords = self.keywords.map(&:downcase)
    urls.each_slice(500) do |batch|
      threads = []
      batch.each do |url|
        threads << Thread.new do
          begin
            url = "http://#{url}" if URI.parse(url).scheme.nil?
            file = open(url, read_timeout: 5)
            response_uri = response_uri(file) # store response_uri in case of redirects
            doc = Nokogiri::HTML.parse(file)
            inner_text = doc.at('body')&.inner_text
            Thread.exit if inner_text.nil?
            result[url] ||= {}
            # count keyword occurrences in page
            keywords.each do |keyword|
              keyword_count = inner_text.scan(/#{keyword}/i).count
              result[url][keyword] = keyword_count
            end
            # get all relevant links on page
            links = doc.at('body').css('a')
            hrefs = links.collect { |link| link.attribute('href').to_s }.uniq
            hrefs.select! do |href|
              uri = URI.parse(href) rescue next
              next if ["javascript","mailto","tel"].include?(uri.scheme)
              if uri.instance_of?(URI::HTTPS) || uri.instance_of?(URI::HTTP)
                uri.host == response_uri.host
              else
                true
              end
            end
            sub_urls = hrefs.map { |href| URI.join(response_uri.to_s, href).to_s }.uniq.sample(50)
            # scrape all subpages for keywords as well
            sub_urls.each do |sub_url|
              Timeout::timeout(30) do
                doc = Nokogiri::HTML.parse(open(sub_url, read_timeout: 5)) rescue next
                inner_text = doc.at('body')&.inner_text
                next if inner_text.nil?
                keywords.each do |keyword|
                  keyword_count = inner_text.scan(/#{keyword}/i).count
                  result[url][keyword] += keyword_count
                end
              end
            end
          rescue StandardError => e
            errors << e.inspect
            Thread.exit
          end
        end
      end
      threads.each(&:join)
    end
    complete_scrape(result, errors)
  end

  private
  
    def complete_scrape(result, errors)
      @keyword_scrape.update_attributes(result: result, scrape_errors: errors, completed_at: Time.current)
    end
    
    def response_uri(file)
      file.base_uri
    end
end