require 'rails_helper'

describe KeywordScrape::Processor do
  let(:keyword_scrape) { build(:keyword_scrape, urls: ["example.com"], keywords: ["waldo", "wilma"]) }
  let(:processor) { KeywordScrape::Processor.new(keyword_scrape) }
  
  describe "#process!" do
    it "fetches keyword occurences in its urls and stores it in its keyword_scrape's result" do
      allow(processor).to receive(:response_uri).and_return(URI.parse("http://example.com"))
      expect(processor).to receive(:open).with("http://example.com", any_args).and_return(example_html)
      expect(processor).to receive(:open).with("http://example.com/subpage", any_args).and_return(subpage_html)
      
      processor.process!
      
      expect(keyword_scrape.result).to match(
        a_hash_including(
          "example.com" => { "waldo" => 1, "wilma" => 1 }
        )
      )
      expect(keyword_scrape.complete?).to be_truthy
    end
  end
  
  def example_html
    %(
      <html>
        <body>
          <a href="/subpage">Waldo</a>
        </body>
      </html>
    )
  end
  
  def subpage_html
    %(
      <html>
        <body>
          <div>Wilma</div>
        </body>
      </html>
    )
  end
end