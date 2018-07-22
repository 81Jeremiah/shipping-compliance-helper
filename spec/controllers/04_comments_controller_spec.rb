require 'spec_helper'
require 'pry'


describe CommentsController do

  describe "add comments to existing company" do
    it 'allows a user to add comments to an existing company if logged in' do
      user = User.create(:username => "milhouse", :email => "mymomsaysimcool@yahoo.com", :password => "imadud")
      company = Company.create(:name => "Bed Bath", :user_id => user.id)

      visit '/'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'login'
      
      visit "/companies/#{company.id}"
      fill_in(:user_comment, :with => "max box weight is no 50 lbs")
      click_button 'submit'

      # params = {
      #   :username => "nelsonmuntz",
      #   :password => "nukethewales",
      #   :name => "Bed Bath",
      #   :comment => "max box weight is no 50 lbs"
      # }

      #post '/comments/', params
      get "/companies/#{company.id}"
      expect(last_response.body).to include("max box weight is no 50 lbs")
    end
  end
end