run "rm README"
run "rm public/index.html"

file '.gitignore', 
%q{coverage/*
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

rakefile "bootstrap.rake", <<CODE
  namespace :app do
    task :bootstrap do
    end
    
    task :seed do
    end
  end
CODE

# route "map.resources :accounts"

git :init

plugin 'rspec',           :git => 'git://github.com/dchelimsky/rspec.git', :submodule => true
plugin 'rspec-rails',     :git => 'git://github.com/dchelimsky/rspec-rails.git', :submodule => true
plugin 'authlogic',       :git => 'git://github.com/binarylogic/authlogic.git', :submodule => true
plugin 'will_paginate',   :git => 'git://github.com/mislav/will_paginate.git', :submodule => true

git :submodule => "init"

generate("rspec")
rake('db:sessions:create')
generate("authlogic", "user session")
rake('db:migrate')

git :add => "."
git :commit => "-a -m 'Initial commit'"

puts "SUCCESS!"