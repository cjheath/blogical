require 'rubygems'
require 'sinatra/base'

require 'uuidtools'
require 'chronic'
require 'atom'

require 'blogical/blog'
require 'blogical/atom'
require 'blogical/content'
require 'blogical/helpers'
require 'blogical/extensions'

module Blogical
  class Application < Sinatra::Base
    BLOGICAL_ROOT = File.dirname(File.dirname(File.expand_path(__FILE__))) unless defined?(BLOGICAL_ROOT)
    BLOGICAL_CONTENT_ROOT = File.join(BLOGICAL_ROOT, 'content') unless defined?(BLOGICAL_CONTENT_ROOT)
    set :content, BLOGICAL_CONTENT_ROOT
    set :public, 'public'
    enable :raise_errors
    enable :logging

    get '/blog/info' do
      "Running Blogical " # + version number
    end

    include Blogical::Blog
    include Blogical::Atom
    include Blogical::Content
    include Blogical::Helpers
  end
end
