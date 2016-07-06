require 'thor'

app_path = File.expand_path('../../app', __FILE__)
$LOAD_PATH.unshift(app_path) unless $LOAD_PATH.include?(app_path)

require 'kaigara/version'
require 'kaigara/base_controller'
require 'kaigara/application'

require 'controllers/sysops'
require 'controllers/docker'
require 'kaigara/client'
require 'kaigara/metadata'
