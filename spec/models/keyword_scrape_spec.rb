require 'rails_helper'

describe KeywordScrape do
  context "associations" do
    it { is_expected.to belong_to(:user) }
  end
  
  context "validations" do
    it { is_expected.to validate_presence_of(:urls) }
    it { is_expected.to validate_presence_of(:keywords) }
  end
  
  describe "#complete?" do
    context "as a new keyword scrape" do
      specify do
        keyword_scrape = build(:keyword_scrape)
        
        expect(keyword_scrape.complete?).to be_falsy
      end
    end
    
    context "as a completed keyword scrape" do
      specify do
        keyword_scrape = build(:keyword_scrape, completed_at: Time.now)
        
        expect(keyword_scrape.complete?).to be_truthy
      end
    end
  end
  
  describe "#to_csv" do
    it "returns a CSV representation of its results" do
      keyword_scrape = build(:keyword_scrape, keywords: ["apple", "orange"], result: example_result)
      
      expect(keyword_scrape.to_csv).to eq("site,apple,orange\nexample1.com,10,0\nexample2.com,0,10\n")
    end
    
    context "when result is blank" do
      it "returns a blank string" do
        keyword_scrape = build(:keyword_scrape)
        expect(keyword_scrape.to_csv).to eq("")
      end
    end
    
    def example_result
      {
        "example1.com" => { "apple" => 10, "orange" => 0 },
        "example2.com" => { "apple" => 0, "orange" => 10 }
      }
    end
  end
end