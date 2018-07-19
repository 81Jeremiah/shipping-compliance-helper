require_relative "spec_helper"
require 'pry'

def app
  ApplicationController
end

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome, please log in")
    end
  end

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
      params = {
        :username => "nelsonmuntz",
        :email => "",
        :password => "nukethewales"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
      expect(page).to have_content("You Must Enter an Email to Continue.")

    end

    it 'does not let a user sign up without a password' do
      params = {
        :username => "nelsonmuntz",
        :email => "haha@juno.com",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
      expect(page).to have_content("You Must Enter an Password to Continue.")
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

    it 'does not load /Companys if user not logged in' do
      get '/Companys'
      expect(last_response.location).to include("/login")
      expect(page).to have_content("You Must login First.")
    end

    it 'does load /Companys if user is logged in' do
      user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")


      visit '/login'

      fill_in(:username, :with => "nelsonmuntz")
      fill_in(:password, :with => "nukethewales")
      click_button 'submit'
      expect(page.current_path).to eq('/companies')
    end
  end

  describe 'user show page' do
    it 'shows all a single users Companys' do
      user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
      company1 = Company.create(:name => "Bed Bath", :user_id => user.id)
      company2 = Company.create(:name => "Hot Topic", :user_id => user.id)
      get "/users/#{user.slug}"

      expect(last_response.body).to include("Bed Bath")
      expect(last_response.body).to include("Hot Topic")

    end
  end

  describe 'index action' do
    context 'logged in' do
      it 'lets a user view the Companys index if logged in' do
        user1 = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company1 = Company.create(:name => "Bed Bath", :user_id => user1.id)

        user2 = User.create(:username => "milhouse", :email => "mymomsaysimcool@gmail.com", :password => "imadud")
        company2 = Company.create(:name => "Hot Topic", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'submit'
        visit "/companies"
        expect(page.body).to include(company1.name)
        expect(page.body).to include(comapny2.name)
      end
    end

    context 'logged out' do
      it 'does not let a user view the all companies if not logged in' do
        get '/companies'
        expect(last_response.location).to include("/login")
        expect(page).to have_content("Please login to view that page.")
      end
    end
  end

  describe 'add a company' do
    context 'logged in' do
      it 'lets user view new company form if logged in' do
        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")

        visit '/login'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'submit'
        visit '/companies/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a company if they are logged in' do
        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")

        visit '/login'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'submit'

        visit '/companies/new'
        fill_in(:name, :with => "Ace Harwdare")
        click_button 'submit'

        user = User.find_by(:username => "nelsonmuntz")
        company = Comapany.find_by(:name => "Justice")
        expect(Company).to be_instance_of(Company)
        expect(company.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let allow a user to make a company that already exists' do
      	user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company = Company.create(:name => "Bed Bath", :user_id => user.id)
        
        visit '/login'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'submit'

        visit '/companies/new'
        fill_in(:name, :with => "Bed Bath")
        click_button 'submit'
         
        expect(page.current_path).to eq("/companies/new")
        expect(page).to have_content("That company already exists, please create a new company or comment on an existing company.")
      end


      it 'does not let a user create a company without a name' do
        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")

        visit '/login'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'submit'

        visit '/companies/new'

        fill_in(:name, :with => "")
        click_button 'submit'

        expect(Company.find_by(:name => "")).to eq(nil)
        expect(page.current_path).to eq("/companies/new")
        expect(page).to have_content("Please enter a name")
      end
    end

    context 'logged out' do
      it 'does not let user view new company form if not logged in' do
        get '/companies/new'
        expect(last_response.location).to include("/login")
        expect(page).to have_content("You must login to view that page.")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single Company' do

        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company = Company.create(:name => "Staples", :user_id => user.id)

        visit '/login'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'submit'

        visit "/Companys/#{company.id}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("Delete Company")
        expect(page.body).to include(company.name)
        expect(page.body).to include("Edit Company")
      end
    end

    context 'logged out' do
      it 'does not let a user view a company' do
        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company = Company.create(:name => "Amaramrk", :user_id => user.id)
        get "/companies/#{company.id}"
        expect(last_response.location).to include("/login")
        expect(page).to have_content("You must login to view that page.")
      end
    end
  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view Company edit form if they are logged in' do
        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company = Company.create(:name => "Bed Bath!", :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'submit'
        visit '/companies/1/edit'
        expect(page.status_code).to eq(200)
        expect(page.body).to include(company.name)
      end

      it 'does not let a user edit a company they did not create' do
        user1 = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company1 = Company.create(:name => "Bed Bath", :user_id => user1.id)

        user2 = User.create(:username => "milhouse", :email => "mymomsaysimcool@gmail.com", :password => "imadud")
        company2 = Company.create(:name => "Hot Topic", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'submit'
        visit "/Companys/#{company2.id}/edit"
        expect(page.current_path).to include('/companies')
        expect(page).to have_content("You cannot eidt a company you didn't create")
      end

      it 'lets a user edit their own created company if they are logged in' do
        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company = Company.create(:name => "Bed Bath", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'submit'
        visit '/companies/1/edit'

        fill_in(:name, :with => "Bed Bath & Beyond")

        click_button 'submit'
        expect(Company.find_by(:name => "Bed Bath & Beyond")).to be_instance_of(Company)
        expect(Company.find_by(:name => "Bed Bath")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a text with blank name' do
        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company = Company.create(:name => "Bed Bath", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'submit'
        visit '/Companys/1/edit'

        fill_in(:name, :with => "")

        click_button 'submit'
        expect(Company.find_by(:name => "Bed Bath")).to be(nil)
        expect(page.current_path).to eq("/companiess/1/edit")
        expect(page).to have_content("Please enter a name")
      end
    end

    context "logged out" do
      it 'does not load -- instead redirects to login' do
        get '/companies/1/edit'
        expect(last_response.location).to include("/login")
        expect(page).to have_content("You must login to view that page.")
      end
    end
  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete a comapny they created if they are logged in' do
        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company = Company.create(:name => "Bed Bath", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'submit'
        visit 'comapnies/1'
        click_button "Delete Company"
        expect(page.status_code).to eq(200)
        expect(Company.find_by(:name => "Bed Bath")).to eq(nil)
      end

      it 'does not let a user delete a company they did not create' do
        user1 = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company1 = Company.create(:name => "Bed Bath", :user_id => user1.id)

        user2 = User.create(:username => "millhouse", :email => "mymomsaysimcool@gmail.com", :password => "imadud")
        company2 = Company.create(:name => "Hot Topic", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'submit'
        visit "companies/#{company2.id}"
        click_button "Delete Company"
        expect(page.status_code).to eq(200)
        expect(Company.find_by(:name => "Hot Topic")).to be_instance_of(Company)
        expect(page.current_path).to include('/companies')
      end
    end

    context "logged out" do
      it 'does not load let user delete a company if not logged in' do
        company = Company.create(:name => "Bed Bath", :user_id => 1)
        visit '/companies/1'
        expect(page.current_path).to eq("/login")
        expect(page).to have_content("You must login to view that page.")
      end
    end
  end


end 