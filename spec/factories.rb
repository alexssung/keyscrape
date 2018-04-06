FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password "1234567890"
    password_confirmation "1234567890"
  end
  
  factory :keyword_scrape do
    user
    urls ['example.com']
    keywords ['example']
  end
end
