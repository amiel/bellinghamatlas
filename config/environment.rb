# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'spreadhead'
  config.gem 'sprockets'
  config.gem 'formtastic'
  config.gem 'authlogic'
  config.gem 'paperclip'
  config.gem 'less'
  config.gem 'will_paginate'

  config.gem 'geokit'
  config.gem 'inherited_resources', :version => '1.0.3'
  config.gem 'gravtastic', :version => '>= 2.1.0'
  config.gem 'video_info'

  config.time_zone = 'Pacific Time (US & Canada)'
  config.i18n.default_locale = :en
end