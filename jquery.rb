# INSTALL JQUERY & UI ----------------------------------------------------------

run "rm -f public/javascripts/*"

file 'public/javascripts/application.js', %q{
$(function() {
	// Stuff to do as soon as the DOM is ready;
});
}

file "public/javascripts/jquery.js", 
  open("http://ajax.googleapis.com/ajax/libs/jquery/1.3/jquery.min.js").read
file "public/javascripts/jquery-ui.js", 
  open("http://ajax.googleapis.com/ajax/libs/jqueryui/1.7/jquery-ui.min.js").read

# INSTALL JQUERY TEMPLATES -----------------------------------------------------

file "public/javascripts/jquery.templates.js", 
  open("http://github.com/wayneeseguin/jquery_templates/raw/master/jquery.templates.js").read