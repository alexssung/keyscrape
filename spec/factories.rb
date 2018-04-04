FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password "12345678"
    password_confirmation "12345678"
  end
  
  factory :keyword_scrape do
    user
    urls ['example.com']
    keywords ['example']
  end
end
