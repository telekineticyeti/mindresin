###
#  Project Settings
###
set :site_title, "mindResin"
set :site_url, "http://mindresin.co.uk"
set :site_description, "mindResin - Home of Aberdeen based independent web designer and illustrator Paul Castle"
set :site_keywords, ""
set :site_author, "http://twitter.com/mindresin"
set :site_analyticsID, "UA-5299581-5"


###
#  Asset Locations
###
set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'images'
set :fonts_dir, 'fonts'
set :partials_dir, 'partials'


###
#  Use Relative Links
###
set :relative_links, true


###
#  Livereload
###
activate :livereload, :host => '127.0.0.1'


###
#  Slim Template Engine Settings
###
set :haml, :format => :xhtml
Slim::Engine.set_default_options :pretty => true, :sort_attrs => false, :indent => '	'
Slim::Engine.disable_option_validator!


###
#  Compass Settings
###
compass_config do |config|
	config.output_style = :compact
	config.sass_options = {
		:line_comments => false,
		:debug_info => false
	}
end


###
#  Page options, layouts, aliases and proxies
###
# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }


###
#  Helpers
###
# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end


###
#  Susy Grid System & Breakpoints
#  http://susy.oddbird.net/
###
require 'susy'
require 'breakpoint'


###
#  Build Specific Configuration
###
configure :build do

	set :build, true

	compass_config do |config| 
		
		config.output_style = :expanded
		
		config.sass_options = {
			:line_comments => false,
			:debug_info => false
		}

	end

	# Minify Javascript on build
	# activate :minify_javascript

	# Enable cache buster
	# activate :asset_hash

	# Use relative URLs
	# activate :relative_assets

	# Or use a different image path
	# set :http_prefix, "/Content/images/"

	# Minify CSS Output
	# activate :minify_css
end