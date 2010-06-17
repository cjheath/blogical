#
# A Sinatra startup file for using bundled gems and multiple applications
#
# The applications are expected to be under the apps directory.
#
begin
  require 'rubygems'
  require 'bundler'
rescue LoadError
  # This is required on some shared hosting environments where local gems won't get picked up:
  # Change it to the path of your unpacked bundler:
  require 'gems/bundler-0.9.26/lib/bundler.rb'
end
Bundler.setup

# We don't want to use the traditional global style with Sinatra, so just require /base:
require 'sinatra/base'

# Again, some shared hosting doesn't allow us to create a file in the logs directory
log = File.new("sinatra.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

path = File.dirname(File.expand_path(__FILE__))
$:.unshift path+"/app"

# Set config settings for Blogical. You should edit things in here:
def configure(ba)
  root = File.dirname(File.expand_path(__FILE__))
  ba.set :views, root + '/views/blogical'       # Tell Sinatra where to find the views
  # Configure things for the ATOM feed:
  ba.set :domain, "my.domain.name"
  ba.set :url, "http://"+ba.domain+"/blog"
  ba.set :author, "Your Name Here"
  # Configure the name and email address for display:
  ba.set :nickname, "nickname"
  ba.set :email, "your_email@domain.com"
  # Configure tags to appear on every page:
  ba.set :description_tags, ["my blog", "please edit these"]
  ba.set :keyword_tags, %w{Put your global relevance keywords here}
  ba.set :title, "New Blogical Blog, please edit this"
  ba.set :urchin_account_id, "UA-2825576-1";
end

# Load the applications, skipping them if a LoadError is raised
begin
  require 'blogical'
  configure(Blogical::Application)
  puts Blogical::Application.content
  use Blogical::Application
rescue LoadError
  puts "Can't load blogical application"
end

# Modify, delete or duplicate this section to add additional Sinatra applications:
begin
  require 'your_other_app'
  use YourOther::Application
rescue LoadError
  puts "Can't load your other application"
end

run Sinatra::Base
