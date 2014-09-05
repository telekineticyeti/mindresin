source "https://rubygems.org"

if RUBY_PLATFORM=~ /win32|win64|cygwin|mingw32/ # Windows
	gem 'wdm', '~> 0.1.0'
	# Windows does not come with time zone data
	gem 'tzinfo-data'
elsif RUBY_PLATFORM=~ /darwin/ # OSX
	gem "rb-fsevent"
else
	gem 'rb-inotify' # Linux
end

# Middleman Gems
gem 'middleman', '3.3.3'
gem 'middleman-smusher', '~> 3.0.0'
gem 'middleman-livereload', '~> 3.3.4'

# Precompilers
gem 'slim', '~> 2.0.3'
gem 'sass', '~> 3.3.14'
# Using compass temporarily so we can have sass 3.3, remove this when Middleman without compass dependency is released
gem 'compass', '~> 1.0.0.rc.0'
gem 'coffee-script', '~> 2.2.0'
gem 'susy'
gem 'breakpoint'
gem 'padrino-support', '0.12.2'
gem 'padrino-helpers', '0.12.2'