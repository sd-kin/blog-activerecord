require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:blog.db"

class Post<ActiveRecord::Base
has_many :comments, inverse_of: :post, dependent: :destroy
end

class Comment<ActiveRecord::Base
belongs_to :post, inverse_of: :comments
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
	Post.create params[:post]
	return erb :new
end

get '/posts/:id' do
@current_post = Post.find(params[:id])
@comments=@current_post.comments
erb :post
end

post '/posts/:id' do
@current_post = Post.find(params[:id])
@current_post.comments.create params[:comment]
@comments=@current_post.comments
erb :post
end