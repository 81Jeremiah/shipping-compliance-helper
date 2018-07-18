require_relative "spec_helper"

def app
  ApplicationController
end

describe ApplicationController do
  it "responds with a welcome message" do
    get '/'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include("Welcome to the Sinatra Template!")
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

end 
