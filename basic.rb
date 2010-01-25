# http://github.com/CodeOfficer/rails-templates/raw/master/basic.rb
# require 'open-uri'
JQUERY_VERSION = '1.4.0'
JQUERY_UI_VERSION = '1.7.2'

# GITIGNORE --------------------------------------------------------------------

git :init

file '.gitignore', %q{
.DS_Store
config/database.yml
db/*.sqlite3
db/schema.rb
log/*.log
tmp/**/*
}

git :add => ".gitignore"
git :commit => "-m 'Ignoring files'"

# COMMON -----------------------------------------------------------------------

run "rm README"
run "cp config/database.yml config/database.yml.example"
run "rm public/index.html"
run "rm -f public/javascripts/*"
# file 'public/stylesheets/application.css', ''

# INSTALL JQUERY & UI ----------------------------------------------------------

run "curl -L http://ajax.googleapis.com/ajax/libs/jquery/#{JQUERY_VERSION}/jquery.js > public/javascripts/jquery-#{JQUERY_VERSION}.js"
run "curl -L http://ajax.googleapis.com/ajax/libs/jqueryui/#{JQUERY_UI_VERSION}/jquery-ui.js > public/javascripts/jquery-ui-#{JQUERY_UI_VERSION}.js"

# INITIALIZERS -----------------------------------------------------------------

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

# BUNDLER ----------------------------------------------------------------------
# http://tomafro.net/2009/11/a-rails-template-for-gem-bundler

rake("rails:template LOCATION=http://github.com/CodeOfficer/bin/raw/master/resources/bundler.rb")

append_file 'Gemfile', <<-END

gem "haml"

only :development do
  gem "nifty-generators"
end

only :test do
  gem "rspec"
  gem "rspec-rails"
  gem "cucumber"
  gem "factory_girl"
end

END

run("gem bundle")

# PLUGINS ----------------------------------------------------------------------

plugin 'default_value_for', :git => "git://github.com/FooBarWidget/default_value_for.git"
    
# COMMANDS ---------------------------------------------------------------------
  
# rake("gems:install", :sudo => true) if yes?("Install gems ?")
# run("gem bundle") if yes?("Bundle gems ?")

generate("nifty_config")
generate("nifty_layout")
generate("nifty_authentication")
generate("rspec")
generate("cucumber", "--rspec", "--webrat")
generate("controller", "home index")

route("map.root :controller => 'home'")

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}

rake("db:create:all")

# CUSTOMIZATIONS ---------------------------------------------------------------

file 'config/app_config.yml', %q{
defaults: &DEFAULTS
  your: mom
  
development:
  domain: localhost:3000
  <<: *DEFAULTS
  
test:
  domain: test.local
  <<: *DEFAULTS

production:
  domain: example.com
  <<: *DEFAULTS
}

file 'public/javascripts/application.js', %q{
$(function() {
	// play that funky music white boy ...
});
}

# FINISH -----------------------------------------------------------------------

git :add => "."
git :commit => " -m 'Initial commit'"
puts "SUCCESS!"