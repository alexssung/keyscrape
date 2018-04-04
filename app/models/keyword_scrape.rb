# Model for storing keyword scrape data
class KeywordScrape < ApplicationRecord
  validates :urls, presence: true
  validates :keywords, presence: true
  
  belongs_to :user
  
  def complete?
    completed_at.present?
  end
end