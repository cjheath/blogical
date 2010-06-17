module Blogical
  module Blog
    def self.included(app)

      # GET /blog
      app.get %r{/blog/?} do
        @posts = options.repository.paginated(Integer(params['page']))
        @pages = options.repository.total_pages
        erb :blog
      end

      # GET /blog/2009/05/12/comma-intro
      app.get '/blog/:year/:month/:day/:title' do |year, month, day, title|
        @post = options.repository.find_by_permalink(title)
        raise Sinatra::NotFound, 'No such post' unless @post
        @title = @post.title
        erb :article
      end

      # GET /assets/2009/05/12/1-filename.pdf
      app.get '/assets/:year/:month/:day/:attachment' do |year, month, day, attachment|
        @attachment = options.repository.find_by_attachment(attachment)
        raise Sinatra::NotFound, 'No such attachment' unless @attachment
        send_file @attachment.content, :disposition => 'attachment'
      end

    end
  end
end
