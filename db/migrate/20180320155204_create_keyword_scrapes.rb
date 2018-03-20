class CreateKeywordScrapes < ActiveRecord::Migration[5.2]
  def change
    create_table :keyword_scrapes do |t|
      t.references :user
      t.string :urls, array: true, default: []
      t.string :keywords, array: true, default: []
      t.jsonb :result
      t.datetime :completed_at
      t.string :scrape_errors, array: true, default: []
      
      t.timestamps
    end
  end
end
