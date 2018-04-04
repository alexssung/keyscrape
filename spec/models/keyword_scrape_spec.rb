require 'rails_helper'

describe KeywordScrape, type: :model do
  context "associations" do
    it { is_expected.to belong_to(:user) }
  end
  
  context "validations" do
    it { is_expected.to validate_presence_of(:urls) }
    it { is_expected.to validate_presence_of(:keywords) }
  end
  
  describe "#complete?" do
    let(:keyword_scrape) { KeywordScrape.new }
    
    context "as a new keyword scrape" do
      specify { expect(keyword_scrape.complete?).to be_falsy }
    end
    
    context "as a completed keyword scrape" do
      specify do
        keyword_scrape.completed_at = Time.now
        
        expect(keyword_scrape.complete?).to be_truthy
      end
    end
  end
end