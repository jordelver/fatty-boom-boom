require 'rubygems'
require 'sinatra'

set :run, false
set :environment, :production

# Log stdout and stderror to a file
log = File.new("log/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

require 'application'
run Sinatra::Application