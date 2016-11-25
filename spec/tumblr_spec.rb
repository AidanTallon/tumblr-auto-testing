describe 'Tumblr' do

  before(:all) do
    @username = 'auntiemation'
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
    sleep 5 # Allows cookies to be updated? I think
    expect(TumblrHelper.logged_in? @browser).to eq true
    expect(@browser.url).to eq 'https://www.tumblr.com/dashboard'
  end

  it 'should be able to post a text post' do
    TumblrHelper.login @browser, @email, @password
    # Test data
    title = 'Test Title'
    content = 'Test content 1234567'
    tags = '#testtag #automationtesting'
    # Create post
    sleep 5 # Would be a good idea to find out why this is needed
    @browser.goto 'https://www.tumblr.com/new/text'
    modal = @browser.li('id': 'new_post_buttons')
    modal.div('class': 'title-field').div('class': 'editor').send_keys title
    modal.div('class': 'caption-field').div('class': 'editor').send_keys content
    modal.div('class': 'tag-input-wrapper').div('class': 'editor').send_keys tags
    modal.div('class': 'post-form--controls').div('class': 'post-form--save-button').button(class: 'create_post_button').click
    sleep 5 # Wait for post to happen before navigating away from page
            # May be something that can be implicitly waited for?

    # Check post exists
    @browser.goto "https://www.tumblr.com/blog/#{@username}"
    post = @browser.div('class': 'post_wrapper')
    expect(post.text).to include @username
    expect(post.text).to include title
    expect(post.text).to include content
    expect(post.text).to include "\##{tags.gsub('#', '')}"

    # Tear down post
    binding.pry
    post.div(class: 'post_controls_inner').click
    @browser.div(class: 'popover--account-popover').div(class: 'ui_dialog').button(class: 'btn_1').click


  end

end