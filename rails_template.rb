gem 'simple_form'

gem 'pg',      group: :production

gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
gem 'semantic-ui-sass', '~> 0.19.3.0'
gem 'font-awesome-rails'
gem 'haml-rails'

gem 'bcrypt', '~> 3.1.7'
gem 'unicorn'

group :development do
  gem 'erb2haml'
  gem 'html2haml'
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano3-unicorn'
end

group :development, :test do
  gem 'brakeman'
  gem 'rubocop'

  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'rspec-nc' if `uname` =~ /Darwin/

  gem 'pry', '< 0.10.0'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'hirb'
  gem 'hirb-unicode'

  if RUBY_VERSION >= '2.0.0'
    gem 'pry-byebug'
  else
    gem 'pry-debugger'
  end

  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'quiet_assets'
end

group :test do
  gem 'faker'
  gem 'gimei'
  gem 'capybara'
  gem 'database_rewinder'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
end

generate 'rspec:install'
run 'spring binstub --all'
run 'guard init'

<<-APPLICATION_RB
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
