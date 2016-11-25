describe 'Tumblr' do

  before(:all) do
    @email = 'rumblydude@hotmail.com'
    @password = 'testpassword123'
  end

  before(:each) do
    @browser = Watir::Browser.new :chrome
    @browser.goto 'https://www.tumblr.com'
  end

  after(:each) do
    TumblrHelper.logout @browser
    @browser.close
  end

  it 'should login with correct details' do
    TumblrHelper.login @browser, @email, @password
    sleep 5
    expect(TumblrHelper.logged_in? @browser).to eq true
    expect(@browser.url).to eq 'https://www.tumblr.com/dashboard'
  end

  it 'should be able to post a text post'

end