# Processor for KeywordScrape
# Fetches keyword occurence counts from urls (and their subpages) and storing result in @keyword_scrape
class KeywordScrape::Processor
  require 'open-uri'
  
  delegate :urls, :keywords, to: :@keyword_scrape
  
  HtmlFile = Struct.new(:doc, :response_uri)
  
  READ_TIMEOUT = 5
  THREAD_POOL_SIZE = 50
  MAX_SUB_URLS = 100
  
  def initialize(keyword_scrape)
    @keyword_scrape = keyword_scrape
    @result = {}
    @errors = []
  end
  
  # performs scraping and stores result in @keyword_scrape
  def process!
    keywords = self.keywords.map(&:downcase)
    thread_pool = Concurrent::FixedThreadPool.new(THREAD_POOL_SIZE)
    urls.each do |url|
      thread_pool.post do
        begin
          html_file = fetch_html_file(url)
          body = html_file.doc.at('body')
          next if body.blank?
          set_keyword_counts(url, body.inner_text)
          sub_urls = get_sub_urls(html_file)
          # scrape all subpages for keywords as well
          sub_urls.each do |sub_url|
            html_file = fetch_html_file(sub_url)
            body = html_file.doc.at('body')
            next if body.blank?
            set_keyword_counts(url, body.inner_text)
          end
        rescue StandardError => e
          @errors << "#{url}: #{e.inspect}"
          break
        end
      end
    end
    thread_pool.shutdown
    thread_pool.wait_for_termination
    complete_scrape!
  end

  private
  
    # fetches html from url and stores the data in a HtmlFile struct
    def fetch_html_file(url)
      file = open(normalize_url(url), read_timeout: READ_TIMEOUT)
      response_uri = response_uri(file)
      doc = Nokogiri::HTML.parse(file)
      HtmlFile.new(doc, response_uri)
    end
    
    # get response uri in case of redirects
    def response_uri(file)
      file.base_uri
    end
    
    def normalize_url(url)
      URI.parse(url).scheme.blank? ? "http://#{url}" : url
    end
    
    # get relevant subpage urls in html file
    def get_sub_urls(html_file)
      doc, response_uri = html_file.doc, html_file.response_uri
      links = doc.at('body').css('a')
      hrefs = links.collect { |link| link.attribute('href').to_s }.uniq
      hrefs = hrefs.select do |href|
        uri = URI.parse(href) rescue next
        next if non_http_uri?(uri)
        if uri.instance_of?(URI::HTTPS) || uri.instance_of?(URI::HTTP)
          uri.host == response_uri.host
        else
          true
        end
      end.sample(MAX_SUB_URLS)
      hrefs.map { |href| URI.join(response_uri.to_s, href).to_s }
    end
    
    def non_http_uri?(uri)
      ["javascript","mailto","tel"].include?(uri.scheme)
    end
  
    def set_keyword_counts(url, text)
      keywords.each do |keyword|
        keyword_count = text.scan(/#{keyword}/i).count
        @result[url] ||= Hash.new(0)
        @result[url][keyword] += keyword_count
      end
    end
    
    def complete_scrape!
      @keyword_scrape.update_attributes(result: @result, scrape_errors: @errors, completed_at: Time.current)
    end
end