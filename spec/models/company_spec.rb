require 'spec_helper'
require 'pry'

describe 'Company' do
  before do
    @company = Company.create(:name => "Bed Bath" )
  end
  it 'can slug the username' do
    expect(@company.slug).to eq("bed-bath")
  end

  it 'can find a company based on the slug' do
    slug = @company.slug
    expect(Company.find_by_slug(slug).name).to eq("Bed Bath")
  end

end