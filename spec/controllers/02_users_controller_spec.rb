require 'spec_helper'
require 'pry'

# def app
#   ApplicationController
# end

describe UsersController do
	
  describe "Signup Page" do

  	it 'loads the signup page' do
  	  get '/signup'
  	  expect(last_response.status).to eq(200)
  	end

    it 'signup directs user to shipper-compliance index' do
      params = {
        :username => "nelsonmuntz",
        :email => "haha@juno.com",
        :password => "nukethewales"
      }
      post '/signup', params
      expect(last_response.location).to include("/companies")     
    end

    it 'does not let a user sign up without a username' do
      params = {
        :username => "",
        :email => "haha@juno.com",
        :password => "nukethewales"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without an email' do
      visit "/signup"
      fill_in "username", with: "nelsonmuntz"
      fill_in "email", with: ""
      fill_in "password", with: "nukethewales"
      click_on "submit"
      expect(page).to have_content("You Must Enter an Email to Continue.")

      params = {
        :username => "nelsonmuntz",
        :email => "",
        :password => "nukethewales"
      }
      post '/signup', params
      
      expect(last_response.location).to include('/signup')
     

    end

    it 'does not let a user sign up without a password' do
      visit "/signup"
      fill_in "username", with: "nelsonmuntz"
      fill_in "email", with: "haha@juno.com"
      fill_in "password", with: ""
      click_on "submit"
      expect(page).to have_content("You Must Enter an Password to Continue.")

      params = {
        :username => "nelsonmuntz",
        :email => "haha@juno.com",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user choose a username that is already taken' do
    	user =  User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
    	
      visit "/signup"
      fill_in "username", with: "nelsonmuntz"
      fill_in "email", with: "haha@juno.com"
      fill_in "password", with: "nukethewales"
      click_on "submit"
      expect(page).to have_content("Sorry that username is already taken")

      params = {
        :username => "nelsonmuntz",
        :email => "haha@juno.com",
        :password => "nukethewales"
      }
      post '/signup', params
      expect(last_response.location).to include("/signup")
      
    end

    it 'does not let a user enter an email that is already in the database' do
    	user =  User.create(:username => "milhouse", :email => "mymomsaysimcool@yahoo.com", :password => "imadud")
    	visit "/signup"
      fill_in "username", with: "joeyjojojrshabadoo"
      fill_in "email", with: "mymomsaysimcool@yahoo.com"
      fill_in "password", with: "imadud"
      click_on "submit"
      expect(page).to have_content("That email already has an account, did you mean to login?")

      params = {
        :username => "milhouse",
        :email => "mymomsaysimcool@yahoo.com",
        :password => "imadud"
      }
      post '/signup', params
      expect(last_response.location).to include("/signup")
    end

    it 'creates a new user and logs them in on valid submission and does not let a logged in user view the signup page' do
      params = {
        :username => "nelsonmuntz",
        :email => "haha@juno.com",
        :password => "nukethewales"
      }
      post '/signup', params
      get '/signup'
      expect(last_response.location).to include('/companies')
    end
  end
  
  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads all current companies after login' do
      user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
      params = {
        :username => "nelsonmuntz",
        :password => "nukethewales"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Please see below")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
      params = {
        :username => "nelsonmuntz",
        :password => "nukethewales"
      }
      post '/login', params
      get '/login'
      expect(last_response.location).to include("/companies")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")

      params = {
        :username => "nelsonmuntz",
        :password => "nukethewales"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end
  end
end