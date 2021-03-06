require 'spec_helper'
require 'pry'

# def app
#   ApplicationController
# end

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome!")
    end
  end
end 