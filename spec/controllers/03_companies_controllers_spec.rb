require 'spec_helper'
require 'pry'

describe CompaniesController do

  describe "companies index page" do

    it 'does not load companies if user not logged in' do
      get '/companies'
      expect(last_response.location).to include("/")
      visit "/companies"
      expect(page).to have_content("You must login to view that page.")
    end

    it 'does load /companies if user is logged in' do
      user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")


      visit '/'

      fill_in(:username, :with => "nelsonmuntz")
      fill_in(:password, :with => "nukethewales")
      click_button 'login'
      expect(page.current_path).to eq('/companies')
    end
  end

  describe 'users company contribution page' do
    it 'shows companies that a single user has added' do
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
      it 'lets a user view the companies full list page if logged in' do
        user1 = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company1 = Company.create(:name => "Bed Bath", :user_id => user1.id)

        user2 = User.create(:username => "milhouse", :email => "mymomsaysimcool@gmail.com", :password => "imadud")
        company2 = Company.create(:name => "Hot Topic", :user_id => user2.id)

        visit '/'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'login'
        visit "/companies"
        expect(page.body).to include(company1.name)
        expect(page.body).to include(company2.name)
      end
    end
  

    context 'logged out' do
      it 'does not let a user view the all companies if not logged in' do
        get '/companies'
        expect(last_response.location).to include("/")
        visit "/companies"
        expect(page).to have_content("You must login to view that page.")
      end
    end
  end

  describe 'add a company' do
    context 'logged in' do
      it 'lets user view new company form if logged in' do
        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")

        visit '/'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'login'
        visit '/companies/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a company if they are logged in' do
        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")

        visit '/'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'login'

        visit '/companies/new'
        fill_in(:name, :with => "Ace Hardware")
        click_button 'submit'

        user = User.find_by(:username => "nelsonmuntz")
        company = Company.find_by(:name => "Ace Hardware")
        #expect(company).to be_instance_of(Company)
        expect(company.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let allow a user to make a company that already exists' do
      	user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company = Company.create(:name => "Bed Bath", :user_id => user.id)
        
        visit '/'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'login'

        visit '/companies/new'
        fill_in(:name, :with => "Bed Bath")
        click_button 'submit'
         
        expect(page.current_path).to eq("/companies/new")
        expect(page).to have_content("A company must have a name and can't already be in the database.")
      end


      it 'does not let a user create a company without a name' do
        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")

        visit '/'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'login'

        visit '/companies/new'

        fill_in(:name, :with => "")
        click_button 'submit'

        expect(Company.find_by(:name => "")).to eq(nil)
        expect(page.current_path).to eq("/companies/new")
        
      end
    end

    context 'logged out' do
      it 'does not let user view new company form if not logged in' do
        get '/companies/new'
        expect(last_response.location).to include("/")
        visit '/companies/new'
        expect(page).to have_content("You must login to view that page.")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single Company' do

        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company = Company.create(:name => "Staples", :user_id => user.id)

        visit '/'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'login'

        visit "/companies/#{company.slug}"
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
        expect(last_response.location).to include("/")
        visit "/companies/#{company.id}"
        expect(page).to have_content("You must login to view that page.")
      end
    end
  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view Company edit form if they are logged in' do
        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company = Company.create(:name => "Bed Bath!", :user_id => user.id)
        visit '/'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'login'
        visit "/companies/#{company.slug}/edit"
        expect(page.status_code).to eq(200)
        expect(page.body).to include(company.name)
      end

      it 'does not let a user edit a company they did not create' do
        user1 = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company1 = Company.create(:name => "Bed Bath", :user_id => user1.id)

        user2 = User.create(:username => "milhouse", :email => "mymomsaysimcool@gmail.com", :password => "imadud")
        company2 = Company.create(:name => "Hot Topic", :user_id => user2.id)

        visit '/'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'login'
        visit "/companies/#{company2.slug}/edit"
        expect(page.current_path).to include('/companies')
        expect(page).to have_content("You cannot edit a company you didn't create")
      end

      it 'lets a user edit their own created company if they are logged in' do
        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company = Company.create(:name => "Bed Bath", :user_id => 1)
        visit '/'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'login'
        visit "/companies/#{company.slug}/edit"

        fill_in(:name, :with => "Bed Bath & Beyond")

        click_button 'submit'
        expect(Company.find_by(:name => "Bed Bath & Beyond")).to be_instance_of(Company)
        expect(Company.find_by(:name => "Bed Bath")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a text with blank name' do
        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company = Company.create(:name => "Bed Bath", :user_id => 1)
        visit '/'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'login'
        visit "/companies/#{company.slug}/edit"

        fill_in(:name, :with => "")

        click_button 'submit'
        expect(page.current_path).to eq("/companies/#{company.slug}/edit")
      end
    end

    context "logged out" do
      it 'does not load -- instead redirects to login' do
        get '/companies/1/edit'
        expect(last_response.location).to include("/")
      end
    end
  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete a company they created if they are logged in' do
        user = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company = Company.create(:name => "Bed Bath", :user_id => 1)
        visit '/'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'login'
        visit "companies/#{company.slug}"
        click_button "Delete Company"
        expect(page.status_code).to eq(200)
        expect(Company.find_by(:name => "Bed Bath")).to eq(nil)
      end

      it 'does not let a user delete a company they did not create' do
        user1 = User.create(:username => "nelsonmuntz", :email => "haha@juno.com", :password => "nukethewales")
        company1 = Company.create(:name => "Bed Bath", :user_id => user1.id)

        user2 = User.create(:username => "millhouse", :email => "mymomsaysimcool@gmail.com", :password => "imadud")
        company2 = Company.create(:name => "Hot Topic", :user_id => user2.id)

        visit '/'

        fill_in(:username, :with => "nelsonmuntz")
        fill_in(:password, :with => "nukethewales")
        click_button 'login'
        expect(page.current_path).to include('/companies')
      end
    end

    context "logged out" do
      it 'does not let user delete a company if not logged in' do
        company = Company.create(:name => "Bed Bath", :user_id => 1)
        visit '/companies/1'
        expect(page.current_path).to eq("/")
        expect(page).to have_content("You must login to view that page.")
      end
    end
  end
end
