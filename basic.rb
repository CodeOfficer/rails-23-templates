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
file 'public/stylesheets/application.css', ''
file 'public/javascripts/application.js', %q{
$(function() {
	// play that funky music white boy ...
});
}

# INSTALL JQUERY & UI ----------------------------------------------------------

run "curl -L http://ajax.googleapis.com/ajax/libs/jquery/#{JQUERY_VERSION}/jquery.js > public/javascripts/jquery-#{JQUERY_VERSION}.js"
run "curl -L http://ajax.googleapis.com/ajax/libs/jqueryui/#{JQUERY_UI_VERSION}/jquery-ui.js > public/javascripts/jquery-ui-#{JQUERY_UI_VERSION}.js"

# APP CONFIG & LAYOUT ----------------------------------------------------------

file 'config/config.yml', %q{
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

# GEMS & PLUGINS ---------------------------------------------------------------

rake("rails:template LOCATION=http://github.com/tomafro/dotfiles/raw/master/resources/rails/bundler.rb")

append_file 'Gemfile', <<-END
gem "haml"
only :test do
  gem "rspec"
  gem "rspec-rails"
  gem "cucumber"
  gem "factory_girl"
end
END

plugin 'default_value_for', :git => "git://github.com/FooBarWidget/default_value_for.git"
    
# COMMANDS ---------------------------------------------------------------------
  
# rake("gems:install", :sudo => true) if yes?("Install gems ?")
rake("gem bundle") if yes?("Bundle gems ?")

generate("nifty_config")
generate("nifty_layout")
generate("nifty_authentication")
generate("rspec")
generate("cucumber", "--rspec", "--webrat")
generate("controller", "home index")

route("map.root :controller => 'home'")

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}

git :add => "."
git :commit => " -m 'Initial commit'"

puts "SUCCESS!"

# # Run a regular expression replacement on a file
# #
# # ==== Example
# #
# #   gsub_file 'app/controllers/application_controller.rb', /#\s*(filter_parameter_logging :password)/, '\1'
# #
# def gsub_file(relative_destination, regexp, *args, &block)
#   path = destination_path(relative_destination)
#   content = File.read(path).gsub(regexp, *args, &block)
#   File.open(path, 'wb') { |file| file.write(content) }
# end
# 
# # Append text to a file
# #
# # ==== Example
# #
# #   append_file 'config/environments/test.rb', 'config.gem "rspec"'
# #
# def append_file(relative_destination, data)
#   path = destination_path(relative_destination)
#   File.open(path, 'ab') { |file| file.write(data) }
# end