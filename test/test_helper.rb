$:.unshift File.dirname(__FILE__) + "/../lib", File.dirname(__FILE__)

require "rubygems"

if dm_version = ENV['DM_VERSION']
  gem 'dm-core',        dm_version
  gem 'dm-sweatshop',   dm_version
  gem 'dm-validations', dm_version
  gem 'dm-types',       dm_version
  gem 'dm-timestamps',  dm_version
  gem 'dm-aggregates',  dm_version
end

require "integrity"
require "integrity/notifier/test"
require "integrity/notifier/jabber"

require "test/unit"
require "xmpp4r"
require "mocha"
