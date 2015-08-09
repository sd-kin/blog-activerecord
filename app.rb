require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:blog.db"

class Post<ActiveRecord::Base
has_many :comments, inverse_of: :post, dependent: :destroy
validates :post_text, presence: true, length: {minimum: 3}
end

class Comment<ActiveRecord::Base
belongs_to :post, inverse_of: :comments
validates :comment_text, presence: true, length: {minimum: 3}
end



before do
@posts=Post.order("updated_at DESC")
end

get '/' do
	erb :main			
end

get '/posts/new' do
	erb :new
end


post '/posts/new' do
	post=Post.create params[:post]
	unless post.valid? then 
		@error=post.errors.full_messages.uniq.join(", ")
		return erb :new
	else redirect "/"
	end
end

get '/posts/:id' do
@current_post = Post.find(params[:id])
@comments=@current_post.comments
erb :post
end

post '/posts/:id' do
@current_post = Post.find(params[:id])
comment=@current_post.comments.create params[:comment]
@comments=@current_post.comments(true)
unless comment.valid? then 
		@error=comment.errors.full_messages.uniq.join(", ")
		return erb :post
	else 
		
		erb :post
		
	end

end