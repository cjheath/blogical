# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'blogical'
  s.version = "0.0.1"

  s.authors = ["Clifford Heath", "Marcus Crafter"]
  s.date = %q{2010-07-01}
  s.description = %q{Blogical is a Sinatra-based micro-blogging engine that requires no database support}
  s.email = ["clifford.heath@gmail.com"]
  s.files = Dir['{Gemfile,README.markdown,config.ru,{app,content,logs,public,tmp,views}/**}']
  s.has_rdoc = false
  s.homepage = %q{http://github.com/cjheath/blogical}
  s.require_paths = ["app"]
  s.summary = %q{Blogical is a Sinatra-based micro-blogging engine that requires no database support}
end
