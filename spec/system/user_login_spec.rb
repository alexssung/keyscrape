require 'rails_helper'

describe "user logging in", js: true do
  before { create(:user, email: "user@example.com", password: "password", password_confirmation: "password") }
  
  scenario "with correct credentials" do
    visit root_path
    
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "password"
    click_on "Log in"
    
    expect(page).to have_css("div#dashboard", visible: false)
  end
end