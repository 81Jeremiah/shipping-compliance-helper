require 'spec_helper'
require 'pry'


describe CommentsController do

  describe "add comments to existing company if comapany wan't created by current user" do
    it 'allows a user to add comments to an existing company if logged in' do
      user = User.create(:username => "nelsonmuntz", :email => "mymomsaysimcool@yahoo.com", :password => "nukethewales")
      company = Company.create(:name => "Bed Bath", :user_id => user.id)
      user2 = User.create(:username => "captain wacky", :email => "singleandsassy@gmail.com", :password => "grimey_rules")
      visit '/'

        fill_in(:username, :with => "captain wacky")
        fill_in(:password, :with => "grimey_rules")
        click_button 'login'
      
      visit "/companies/#{company.slug}"
      fill_in(:user_comment, :with => "max box weight is 50 lbs")
      click_button 'submit'

       params = {
        :user_comment => "max box weight is no 50 lbs",
        :user_id => "#{user.id}",
        :company_id => "#{company.id}"
        
      }

      post "/comments/#{company.id}", params
      expect(last_response.body).to include("max box weight is 50 lbs")
    end
  end
end