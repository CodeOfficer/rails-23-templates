require 'open-uri'

# INSTALL 960 CSS --------------------------------------------------------------

file "public/stylesheets/960/reset.css", 
  open("http://github.com/CodeOfficer/960-grid-system-without-margins/raw/master/code/css/reset.css").read
file "public/stylesheets/960/960.css", 
  open("http://github.com/CodeOfficer/960-grid-system-without-margins/raw/master/code/css/960.css").read
file "public/stylesheets/960/text.css", 
  open("http://github.com/CodeOfficer/960-grid-system-without-margins/raw/master/code/css/text.css").read
  
# APPLICATION.CSS --------------------------------------------------------------

file 'public/stylesheets/application.css', %q{
body { margin-left: auto; width: 960px; margin-right: auto; }
}