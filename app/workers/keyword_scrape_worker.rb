class KeywordScrapeWorker
  include Sidekiq::Worker
  require 'open-uri'

  def perform(*args)
    url_list = []
    keywords = []
    result = {}
    url_list.each do |url|
      begin
        result[url] = {}
        url = "http://#{url}" if URI.parse(url).scheme.nil?
        file = open(url)
        response_uri = file.base_uri # store response_uri in case of redirects
        doc = Nokogiri::HTML(file)
        inner_text = doc.at('body').inner_text
        keywords.each do |keyword|
          keyword_count = inner_text.downcase.scan(/#{keyword}/).count
          result[url][keyword] = keyword_count
        end
        # get all relevant links on page
        links = doc.at('body').css('a')
        hrefs = links.collect { |link| link.attribute('href').to_s }.uniq
        hrefs.select! do |href|
          uri = URI(href)
          if uri.instance_of?(URI::Generic)
            true
          elsif uri.instance_of?(URI::HTTPS) || uri.instance_of?(URI::HTTP)
            uri.host == response_uri.host
          else
            false
          end
        end
        sub_urls = hrefs.map do |href|
          if href.first == "/"
            URI::Generic.build(scheme: response_uri.scheme, host: response_uri.host, path: href).to_s
          elsif URI.parse(href).scheme.nil?
            URI.join(url, href).to_s
          else
            href
          end
        end
        # scrape all subpages for keywords as well
        sub_urls.each do |sub_url|
          doc = Nokogiri::HTML(open(sub_url))
          inner_text = doc.at('body').inner_text
          keywords.each do |keyword|
            keyword_count = inner_text.downcase.scan(/#{keyword}/).count
            result[url][keyword] = keyword_count
          end
        end
      rescue StandardError
        next
      ensure
        file.close
      end
    end
  end
end
