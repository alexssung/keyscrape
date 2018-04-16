# Model for storing keyword scrape data
class KeywordScrape < ApplicationRecord
  validates :urls, presence: true
  validates :keywords, presence: true
  
  belongs_to :user
  
  def complete?
    completed_at.present?
  end
  
  def to_csv
    if result.present?
      csv = "site,#{keywords.join(',')}\n"
      sorted_result = result.sort_by { |url, data| data.values.sum }.reverse
      sorted_result.each do |url, data|
        keyword_counts = keywords.map { |keyword| data[keyword] }.join(",")
        csv << "#{url},#{keyword_counts}\n"
      end
      csv
    else
      ""
    end
  end
end