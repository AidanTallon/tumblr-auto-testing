require 'watir'
require 'pry'

class TumblrHelper

  @@browser = Watir::Browser.new :chrome

  def self.browser
    @@browser
  end

  def self.login(email, password)
    if logged_in?
      return
    end
    unless @@browser.url == 'https://www.tumblr.com'
      @@browser.goto 'https://www.tumblr.com'
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

  end


# WAAAAAAAAAAAAAAAAAAAHHHHHHHHHHHHHHHHH
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
