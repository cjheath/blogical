module Blogical
  module Atom
    def self.included(app)

      app.get '/blog/atom.xml' do

        feed = ::Atom::Feed.new do |f|
          f.title = self.class.feed_title
          f.links << ::Atom::Link.new(:href => self.class.url)
          f.updated = options.repository.latest.posted.to_s(:iso8601)
          f.authors << ::Atom::Person.new(:name => self.class.full_name)
          f.id = 'tag:'+self.class.domain+',2010:blogical/blog'

          options.repository.recent(15).each do |post|
            entry = ::Atom::Entry.new do |e|
              e.title = post.title
              e.links << ::Atom::Link.new(:href => post.url)
              e.id = UUIDTools::UUID.sha1_create(UUIDTools::UUID_URL_NAMESPACE, post.url).to_uri.to_s
              e.updated = post.posted.to_s(:iso8601)
              e.content = ::Atom::Content::Html.new(markup(File.read(post.content)))
            end

            f.entries << entry
          end
        end

        feed.to_xml
      end
    end
  end
end
