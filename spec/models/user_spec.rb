require 'pry'
describe 'User' do
  before do
    @user = User.create(:username => "william henry harrison", :email => "idiedin30days@aol.com", :password => "coatsr4wimps")
  end
  it 'can slug the username' do
    expect(@user.slug).to eq("Willim-henry-harrison")
  end

  it 'can find a user based on the slug' do
    slug = @user.slug
    expect(User.find_by_slug(slug).username).to eq("william henry harrison")
  end

  it 'has a secure password' do

    expect(@user.authenticate("pantsrcool")).to eq(false)

    expect(@user.authenticate("coatsr4wimps")).to eq(@user)
  end
end