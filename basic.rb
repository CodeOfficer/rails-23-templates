# BASIC ------------------------------------------------------------------------
run "rm README"
run "cp config/database.yml config/database.yml.example"


# GITIGNORE --------------------------------------------------------------------
file '.gitignore', 
%q{
log/*.log
log/*.pid
db/*.db
db/*.sqlite3
db/schema.rb
tmp/**/*
.DS_Store
doc/api
doc/app
config/database.yml
public/javascripts/all.js
public/stylesheets/all.js
}
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}


# INSTALL JQUERY & UI ----------------------------------------------------------
run "rm -f public/javascripts/*"
file 'public/javascripts/application.js', ''
require 'open-uri'
file "public/javascripts/jquery.js", open("http://ajax.googleapis.com/ajax/libs/jquery/1.3/jquery.min.js").read
file "public/javascripts/jquery-ui.js", open("http://ajax.googleapis.com/ajax/libs/jqueryui/1.7/jquery-ui.min.js").read


# INSTALL STYLESHEET -----------------------------------------------------------
file 'public/stylesheets/application.css', ''


# INSTALL CONFIG ---------------------------------------------------------------
file 'config/config.yml', %q{
CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]
}
file 'config/config.yml', %q{
defaults: &defaults
  per_page: 15
  
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


# DATE & TIME FORMATS ----------------------------------------------------------
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


# PLUGINS ----------------------------------------------------------------------
# plugin 'rspec', :git => 'git://github.com/dchelimsky/rspec.git', :submodule => true
# plugin 'rspec-rails', :git => 'git://github.com/dchelimsky/rspec-rails.git', :submodule => true
# plugin 'state-machine', :git => 'git://github.com/pluginaweek/state_machine.git', :submodule => true
# 
# 
# # GEMS -------------------------------------------------------------------------
# gem "authlogic", :lib => 'authlogic', :source => 'http://gems.github.com'
# gem "rich-acts_as_revisable", :lib => "acts_as_revisable", :source => "http://gems.github.com"
# gem "mbleigh-acts-as-taggable-on", :source => "http://gems.github.com", :lib => "acts-as-taggable-on"



git :init
# git :submodule => "init"



# # route "map.resources :accounts"

# 
# generate("rspec")
# rake('db:sessions:create')
# generate("authlogic", "user session")
# rake('db:migrate')
# 

git :add => "."
git :commit => "-a -m 'Initial commit'"

puts "SUCCESS!"