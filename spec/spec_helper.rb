require 'watir'
require 'pry'

class TumblrHelper

  @@browser = Watir::Browser.new :chrome

  def self.login
    if logged_in?
      return
    end

  end

  def self.logout
    unless logged_in?
      return
    end

  end

  def self.logged_in?
    @@browser.cookies.to_a do |c|
      if c[:name] == 'logged_in' && c[:value] == 1 && c[:domain] == '.tumblr.com'
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
