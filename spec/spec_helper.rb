require 'watir'
require 'pry'

class TumblrHelper
  attr_accessor :email, :password, :username, :browser

  @@base_url = 'https://www.tumblr.com'

  def self.url(path = '/')
    @@base_url + path
  end

  def initialize(email = 'rumblydude@hotmail.com',
                 password = 'testpassword123',
                 username = 'auntiemation')
    @browser = Watir::Browser.new :chrome
    @email = email
    @password = password
    @username = username
  end

  def goto(path)
    @browser.goto self.class.url path
  end

  def login
    if logged_in?
      return
    end
    unless @browser.url == self.class.url
      goto '/'
    end
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
    unless logged_in?
      return
    end
    unless @browser.url == self.class.url('/dashboard')
      goto '/dashboard'
    end
    @browser.div(id: 'tabs_outer_container').button(title: 'Account').click
    @browser.a(id: 'logout_button').click
    @browser.div(id: 'dialog_0').button(class: 'btn_1').click
    # Wait for redirect
    Watir::Wait.until { @browser.titles(text: 'Log in | Tumblr')[0].exists? }
  end

  def logged_in?
    @browser.cookies.to_a.each do |c|
      if c[:name] == 'logged_in' && c[:value] == '1' && c[:domain] == '.tumblr.com'
        return true
      end
    end
    return false
  end
end