gretel = yes?('do you want to use gretel?')

gem 'gretel' if gretel
gem 'jquery-turbolinks'
gem 'active_decorator'
gem 'haml-rails'
gem 'font-awesome-rails'
gem 'ransack'

gem_group :development do
  gem 'erb2haml'
  gem 'quiet_assets'

  if `uname` =~ /Darwin/
    gem 'rb-fsevent'
    gem 'guard-pow', require: false
    gem 'powder'
  end
end

gem_group :development, :test do
  gem 'brakeman'
  gem 'rubocop'

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'guard-rspec', require: false

  gem 'pry', '< 0.10.0'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'hirb'
  gem 'hirb-unicode'

  gem 'spring-commands-rspec'

  gem 'better_errors'
  gem 'binding_of_caller'
end

gem_group :test do
  gem 'faker'
  gem 'capybara'
  gem 'database_rewinder'
  gem 'launchy'
end

generate 'rspec:install'
generate 'gretel:install' if gretel
run 'bundle binstub guard'
run 'bin/guard init'
rake 'haml:replace_erbs'

application <<-APPLICATION_RB
config.generators do |g|
  g.template_engine :haml
  g.test_framework :rspec,
    fixtures:         true,
    view_specs:       false,
    routing_specs:    false,
    request_specs:    false,
    controller_specs: true,
    helper_specs:     true
  g.fixture_replacement :factory_girl, dir: "spec/factories"
end
APPLICATION_RB

File.rename('app/assets/stylesheets/application.css', 'app/assets/stylesheets/application.css.scss')

append_file 'app/assets/stylesheets/application.css.scss' do
<<-CSS
@import "font-awesome";
CSS
end

inject_into_file 'spec/rails_helper.rb', after: "require 'rspec/rails'\n" do
<<-CAPYBARA
require 'capybara/rails'
CAPYBARA
end

inject_into_file 'spec/rails_helper.rb', after: "RSpec.configure do |config|\n" do
<<-RSPEC_CONFIG
  config.include FactoryGirl::Syntax::Methods

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
RSPEC_CONFIG
end
