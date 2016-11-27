require 'watir'
require 'pry'
require 'yaml'

class TumblrHelper
  # Helper class for tests.
  # Instantiate with email, password, username of user.
  # Has instance methods for navigation in tumblr ,logging in,
  # logging out, and checking login status.
  attr_accessor :email, :password, :username, :browser

  @@base_url = 'https://www.tumblr.com'
  @@users = {} # Holds all instances of TumblrHelper with key of username

  def self.url(path = '/')
    # Helper method to return tumblr url
    @@base_url + path
  end

  def self.users
    @@users
  end

  def self.load_yaml(path)
    # Load user information from yaml file
    YAML.load_file(path).each do |file|
      TumblrHelper.new file['email'], file['password'], file['username']
    end
  end

  def initialize(email = 'rumblydude@hotmail.com',
                 password = 'testpassword123',
                 username = 'auntiemation')
    @browser = Watir::Browser.new :chrome
    @email = email
    @password = password
    @username = username

    @@users[self.username] = self
  end

  def goto(path)
    # Helper method to navigate to tumblr.com + path
    @browser.goto self.class.url path
  end

  def login
    # Check login status
    if logged_in?
      return
    end
    # Navigate to tumblr root
    unless @browser.url == self.class.url
      goto '/'
    end
    # Login
    @browser.element(id: 'signup_login_button').click
    @browser.element(id: 'signup_determine_email').send_keys @email
    @browser.element(id: 'signup_forms_submit').click
    if @browser.checkbox(id: 'persistent').set?
      @browser.div(id: 'persistency').click
    end
    @browser.element(id: 'login-signin').click
    @browser.element(id: 'login-passwd').send_keys @password
    @browser.element(id: 'login-signin').click
    # Wait for redirect
    Watir::Wait.until { @browser.titles(text: 'Tumblr')[0].exists? }
  end

  def logout
    # Check login status
    unless logged_in?
      return
    end
    # Navigate to dashboard
    unless @browser.url == self.class.url('/dashboard')
      goto '/dashboard'
    end
    # Logout
    @browser.div(id: 'tabs_outer_container').button(title: 'Account').click
    @browser.a(id: 'logout_button').click
    @browser.div(id: 'dialog_0').button(class: 'btn_1').click
    # Wait for redirect
    Watir::Wait.until { @browser.titles(text: 'Log in | Tumblr')[0].exists? }
  end

  def logged_in?
    # Use browser cookies to check if logged in
    @browser.cookies.to_a.each do |c|
      if c[:name] == 'logged_in' && c[:value] == '1' && c[:domain] == '.tumblr.com'
        # Return true once cookie found
        return true
      end
    end
    # If cookie not found, return false
    return false
  end
end