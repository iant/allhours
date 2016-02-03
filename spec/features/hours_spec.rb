require 'rails_helper'

RSpec.feature "Hours", type: :feature, :js => true do
  describe "the signin process", :type => :feature do
    before :each do
      User.make(:email => 'user@example.com', :password => 'P45S30R2123')
    end
  end

  it "signs me in" do
    visit '/login'
    within("#new_user") do
      fill_in 'Email', :with => 'user@example.com'
      fill_in 'Password', :with => 'PA5S30R4123'
    end
    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_content 'Chart'
    expect(page).to have_content 'Hours'

    puts page.body
    # React Component - require's cabybara-webkit gem installed
    #within("#hours-form") do
    #  fill_in 'Client', :with => 'TestClient'
    #  fill_in 'Project', :with => 'TestProject'
    #  fill_in 'Date', :with => '01/11/2015'
    #  fill_in 'Hours', :with => '12'
    #end
    #click_button 'Create'


  end





end