remove_file '.gitignore'
get 'http://github.com/rainux/rails3_template/raw/master/gitignore', '.gitignore'
git :init
git :add => '.gitignore'
git :commit => "-am 'Initial commit'"

run 'rm -Rf README public/index.html public/javascripts/* test app/views/layouts/* log/*'
create_file 'log/.gitkeep'
create_file 'tmp/cache/.gitkeep'
create_file 'tmp/pids/.gitkeep'
create_file 'tmp/sessions/.gitkeep'
create_file 'tmp/sockets/.gitkeep'
run 'cp config/database.yml config/database.yml.example'
git :add => '.'
git :commit => "-am 'Rails 3 app generated'"

remove_file 'Gemfile'
create_file 'Gemfile' do
<<-GEMS
source 'http://rubygems.org'

gem 'rails', '3.0.0.beta4'
gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'haml', '>= 3.0.4'
gem 'inherited_resources', '>= 1.1.2'
gem 'will_paginate', '>= 3.0.pre'
gem 'devise', '>= 1.1.rc2'
gem 'formtastic', :git => 'git://github.com/justinfrench/formtastic.git', :branch => 'rails3'
gem 'friendly_id', '~> 3.0'
gem 'compass', '>= 0.10.1'

gem 'rails3-generators', :git => 'git://github.com/indirect/rails3-generators.git'
gem 'inploy'

gem 'factory_girl_rails'

group :test do
  gem 'rspec', '>= 2.0.0.alpha.11'
  gem 'rspec-rails', '>= 2.0.0.alpha.11'
  gem 'remarkable', '>= 4.0.0.alpha4'
  gem 'remarkable_activemodel', '>= 4.0.0.alpha4'
  gem 'remarkable_activerecord', '>= 4.0.0.alpha4'
end

group :cucumber do
  gem 'cucumber', '>= 0.6.3'
  gem 'cucumber-rails', '>= 0.3.2'
  gem 'capybara', '>= 0.3.6'
  gem 'database_cleaner', '>= 0.5.0'
  gem 'spork', '>= 0.8.4'
  gem 'pickle', :git => 'git://github.com/codegram/pickle.git'
end
GEMS
end

application <<-GENERATORS
  config.generators do |g|
      g.template_engine :haml
      g.test_framework  :rspec, :fixture => true, :views => false
      g.fixture_replacement :factory_girl, :dir => 'spec/support/factories'
    end
GENERATORS

run "bundle install"
generate "rspec:install"
generate "cucumber:install --capybara --rspec --spork"
generate "pickle:skeleton --path --email"
generate "friendly_id"
generate "formtastic:install"
run "gem install compass"
run "compass init --using blueprint --app rails --css-dir public/stylesheets"

run "rm public/stylesheets/*"

get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"
get "http://github.com/rainux/rails3_template/raw/master/gitignore", ".gitignore"
get "http://github.com/rainux/rails3_template/raw/master/screen.scss", "app/stylesheets/screen.scss"
get "http://github.com/rainux/rails3_template/raw/master/application.html.haml", "app/views/layouts/application.html.haml"
get "http://github.com/rainux/rails3_template/raw/master/factory_girl.rb", "features/support/factory_girl.rb"
get "http://github.com/rainux/rails3_template/raw/master/remarkable.rb", "spec/support/remarkable.rb"
get "http://github.com/rainux/rails3_template/raw/master/build.rake", "lib/tasks/build.rake"

create_file 'config/deploy.rb', <<-DEPLOY
application = '#{app_name}'
repository = ''
hosts = %w()
DEPLOY

git :add => '.'
git :commit => '-m "Gems installed"'

puts "SUCCESS!"
