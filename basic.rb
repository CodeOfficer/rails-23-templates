# http://github.com/CodeOfficer/rails-templates/raw/master/basic.rb

git :init

# COMMON -----------------------------------------------------------------------

run "rm README"
run "cp config/database.yml config/database.yml.example"
run "rm public/index.html"
run "rm -f public/javascripts/*"

file 'public/stylesheets/application.js', ''
file 'public/stylesheets/application.css', ''

# GITIGNORE --------------------------------------------------------------------

file '.gitignore', %q{
log/*.log
log/*.pid
db/*.db
db/*.sqlite3
db/schema.rb
tmp/**/*
.DS_Store
config/database.yml
public/javascripts/all.js
public/stylesheets/all.js
}

# APP CONFIG -------------------------------------------------------------------

file 'config/config.yml', %q{
CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]
}
file 'config/config.yml', %q{
defaults: &defaults
  test_var: default
  
development:
  test_var: development
  <<: *defaults
  
test:
  test_var: test
  <<: *defaults

production:
  test_var: production
  <<: *defaults
}

# INITIALIZERS -----------------------------------------------------------------

initializer 'session_store.rb', <<-END
ActionController::Base.session = { :session_key => '_#{(1..6).map { |x| (65 + rand(26)).chr }.join}_session', :secret => '#{(1..40).map { |x| (65 + rand(26)).chr }.join}' }
ActionController::Base.session_store = :active_record_store
END

initializer 'date_time_formats.rb', <<-END
my_time_formats = {
  :human => '%b %d, %Y @ %l:%M %p',
  :input => '%l:%M %p'
}
my_date_formats = {
  :human => '%b %d, %Y',
  :input => '%Y/%m/%d',
}
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(my_time_formats)
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(my_date_formats)
END

# MISCELLANEOUS ----------------------------------------------------------------

rakefile "bootstrap.rake", <<-END
namespace :app do
  task :bootstrap do
  end
  
  task :seed do
  end
end
END

# ASSETS -----------------------------------------------------------------------

jquery = false
if yes?("\n INSTALL JQUERY AND FRIENDS?")
  jquery = true
  rake("rails:template LOCATION=http://github.com/CodeOfficer/rails-23-templates/raw/master/jquery_and_friends.rb")
end

if yes?("\n INSTALL 960 CSS FRAMEWORK?")
  rake("rails:template LOCATION=http://github.com/CodeOfficer/rails-23-templates/raw/master/960_css_framework.rb")
end

file 'public/stylesheets/application.css', %q{
body { margin-left: auto; width: 960px; margin-right: auto; }
}

# APP LAYOUT -------------------------------------------------------------------

file 'app/views/layouts/application.html.erb', %q{
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-type" content="text/html; charset=utf-8"/>
	<title>Page Title</title>	
	<%= stylesheet_link_tag '960/reset', '960/960', '960/text', 'application', :cache => true %>
	<%= javascript_include_tag 'jquery', 'jquery-ui', 'jquery.templates', 'application', :cache => true %>
</head>
<body>
  <%= yield %> #{jquery}
</body>
</html>
}

# PLUGINS ----------------------------------------------------------------------

  plugin 'rspec',             :git => 'git://github.com/dchelimsky/rspec.git'
  plugin 'rspec-rails',       :git => 'git://github.com/dchelimsky/rspec-rails.git'
  plugin 'cucumber',          :git => "git://github.com/aslakhellesoy/cucumber.git"
  plugin 'factory_girl',      :git => "git://github.com/thoughtbot/factory_girl.git"
  plugin 'paperclip',         :git => "git://github.com/thoughtbot/paperclip.git"
  plugin 'state-machine',     :git => 'git://github.com/pluginaweek/state_machine.git'
  plugin 'hoptoad_notifier',  :git => "git://github.com/thoughtbot/hoptoad_notifier.git" 
  plugin 'haml',              :git => "git://github.com/nex3/haml.git" 

# GEMS -------------------------------------------------------------------------

  # sudo gem install rails --source http://gems.rubyonrails.org
  # sudo gem install dchelimsky-rspec
  # sudo gem install dchelimsky-rspec-rails
  # sudo gem install cucumber
  # sudo gem install webrat

  gem "authlogic", 
    :lib => 'authlogic', 
    :source => 'http://gems.github.com'

  gem 'mislav-will_paginate', 
    :lib => 'will_paginate',  
    :source => 'http://gems.github.com'  

  gem "mbleigh-acts-as-taggable-on", 
    :lib => "acts-as-taggable-on",
    :source => "http://gems.github.com"
    
# COMMANDS ---------------------------------------------------------------------
  
rake("gems:install", :sudo => true)

generate("rspec")

generate("controller", "home index")
route("map.root :controller => 'home'")

# route "map.resources :accounts"

# rake('db:sessions:create')
# generate("authlogic", "user session")
# rake('db:migrate')

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}

git :add => "."
git :commit => " -m 'Initial commit'"

puts "SUCCESS!"

