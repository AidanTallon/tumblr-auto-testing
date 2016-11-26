describe 'Tumblr' do

  before(:all) do
    @user = TumblrHelper.new
  end

  before(:each) do
    @user.login
    @user.goto '/'
  end

  after(:each) do

  end

  after(:all) do
    @user.logout
    @user.browser.close
  end

  it 'should login with correct details' do
    @user.login
    sleep 5 # Allows cookies to be updated? I think
    expect(@user.logged_in?).to eq true
    expect(@user.browser.url).to eq TumblrHelper.url '/dashboard'
  end

  it 'should be able to post a text post' do
    # Test data
    title = "Test Title #{rand(20000)}"
    content = "Test content #{rand(20000)}"
    tags = '#testtag #automationtesting'
    # Create post
    sleep 5 # Would be a good idea to find out why this is needed
    @user.goto '/new/text'
    modal = @user.browser.li('id': 'new_post_buttons')
    modal.div('class': 'title-field').div('class': 'editor').send_keys title
    modal.div('class': 'caption-field').div('class': 'editor').send_keys content
    modal.div('class': 'tag-input-wrapper').div('class': 'editor').send_keys tags
    modal.div('class': 'post-form--controls').div('class': 'post-form--save-button').button(class: 'create_post_button').click
    sleep 5 # Wait for post to happen before navigating away from page
            # May be something that can be implicitly waited for?

    # Check post exists
    @user.goto "/blog/#{@user.username}"
    post = @user.browser.div('class': 'post_wrapper')
    expect(post.text).to include @user.username
    expect(post.text).to include title
    expect(post.text).to include content
    expect(post.text).to include "\##{tags.gsub('#', '')}"

    # Tear down post
    post.div(class: 'post_control_menu').click
    post.div(title: 'Delete').click
    @user.browser.div(id: 'dialog_0').button(class: 'btn_1').click
  end

end