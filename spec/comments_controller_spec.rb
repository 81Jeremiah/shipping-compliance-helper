require_relative "spec_helper"
require 'pry'


describe CommentsController do

  describe "add comments to companies" do
    it 'allows a suer to add comments to an existing company if logged in' do
      it "lets a user logout if they are already logged in" do
      user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
      company1 = Company.create(:name => "Bed Bath", :user_id => user1.id)
      params = {
        :username => "nelsonmuntz",
        :password => "nukethewales",
        :name => "Bed Bath",
        :comment => "max box weight is no 50 lbs"
      }
      post '/comments', params
      get '/companies/1'
      expect(last_response.body).to include("max box weight is no 50 lbs")
    end
  end
