require 'rubygems'
require 'sinatra'

set :run, false
set :environment, :production

require 'application'
run Sinatra::Application