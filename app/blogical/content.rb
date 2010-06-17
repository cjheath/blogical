require 'find'

module Blogical
  module Content

    def self.included(app)
      app.configure do |app|
        app.set :repository, Repository.new(app.content)
      end
    end

    class Repository
      attr_accessor :articles, :path

      def initialize(path)
        @path, @index, @articles, @attachments = path, [], {}, {}
        scan
      end

      def find_by_permalink(link)
        @articles[link]
      end

      def find_by_attachment(attachment)
        @attachments[attachment]
      end

      def recent(count = 3)
        raise "Requested more articles (#{count}) than existing in repository (#{@index.size})" if count > @index.size
        @index[0..(count - 1)]
      end

      def latest
        @index[0]
      end

      def total_pages
        @index.total_pages
      end

      def paginated(page_number = 1)
        @index.page(page_number)
      end

      private

        def page_size
          @index.page_size
        end

        def article(meta)
          article = Article.new(meta)
          @index << article
          @articles[article.permalink] = article
          article.attachments.each { |a| @attachments[a.name] = a } if article.attachments
          puts "Registered article #{article.permalink} (posted #{article.posted})"
        end

        def scan
          metafiles = []
          Find.find(@path) do |path|
            next unless FileTest.directory?(path)
            meta = "#{path}/meta.rb"
            next unless File.exists?(meta)
            metafiles << meta
            Find.prune
          end
          metafiles.sort.reverse.each do |meta|
            article(meta)
          end
        end

    end

    class Article
      attr_accessor :permalink, :posted, :attachments, :tags, :content, :title

      def initialize(meta)
        @path, @content = meta, File.join(File.expand_path(File.dirname(meta)), 'content.markdown')
        instance_eval File.read(meta)
      end

      def article(title, &block)
        @title = title
        instance_eval &block
      end

      def permalink(link = nil)
        return @permalink unless link
        @permalink = link
      end

      def posted(date = nil)
        if date
          @posted = date
        else
          return Chronic.parse(@posted)
        end
      end

      # REVISIT: most recent content file git commit author
      def nickname
        Blogical::Application.nickname
      end

      def email
        Blogical::Application.email
      end

      def url
        "/blog/#{@posted}/#{@permalink}"
      end

      def attachments(*attachments)
        return @attachments if attachments.empty?
        @attachments = attachments.collect { |attachment| Attachment.new(self, attachment) }
      end

      def tags(*tags)
        return @tags if tags.empty?
        @tags = tags.collect { |tag| Tag.new(self, tag) }
      end

    end

    class Attachment
      attr_accessor :article, :name, :content

      def initialize(article, name)
        @article, @name = article, name
        @content = File.join(File.expand_path(File.dirname(article.content)), name)
      end

    end

    class Tag
      attr_accessor :article, :name

      def initialize(article, name)
        @article, @name = article, name
      end

    end

  end
end
