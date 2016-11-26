require 'watir'
require 'pry'

class TumblrHelper

  @@browser = Watir::Browser.new :chrome
  @@base_url = 'https://www.tumblr.com'

  def self.browser
    @@browser
  end

  def self.url(path = '/')
    @@base_url + path
  end

  def self.login(email = 'rumblydude@hotmail.com', password = 'testpassword123')
    if logged_in?
      return
    end
    unless @@browser.url == self.url
      @@browser.goto self.url
    end
    @@browser.element(id: 'signup_login_button').click
    @@browser.element(id: 'signup_determine_email').send_keys email
    @@browser.element(id: 'signup_forms_submit').click
    if @@browser.checkbox(id: 'persistent').set?
      @@browser.div(id: 'persistency').click
    end
    @@browser.element(id: 'login-signin').click
    @@browser.element(id: 'login-passwd').send_keys password
    @@browser.element(id: 'login-signin').click
  end

  def self.logout
    unless logged_in?
      return
    end
    unless @@browser.url == self.url('/dashboard')
      @@browser.goto self.url('/dashboard')
    end
    @@browser.div(id: 'tabs_outer_container').button(title: 'Account').click
    @@browser.a(id: 'logout_button').click
    @@browser.div(id: 'dialog_0').button(class: 'btn_1').click
  end

  def self.logged_in?
    @@browser.cookies.to_a.each do |c|
      if c[:name] == 'logged_in' && c[:value] == '1' && c[:domain] == '.tumblr.com'
        return true
      end
    end
    return false
  end

end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
