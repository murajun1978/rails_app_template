ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'simplecov'

SimpleCov.start do
  add_group 'Models',      'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers',     'app/helpers'
  add_filter '/spec|db/'
end

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseRewinder.strategy = :truncation
  end

  config.before(:each) do
    DatabaseRewinder.start
  end

  config.after(:each) do
    DatabaseRewinder.clean
  end

  config.before(:all) do
    FactoryGirl.reload
  end

  config.infer_spec_type_from_file_location!
end
