require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-timestamps'
require 'dm-serializer'
require 'dm-validations'

configure do
  DataMapper::Logger.new(STDOUT, 0)
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/fatty.sqlite3")
end

not_found do
  redirect '/'
end

class Item
  include DataMapper::Resource
  property :id, Serial
  property :item, String, :nullable => false
  property :kcal, Integer
  property :created_at, DateTime
  property :updated_at, DateTime

  def self.eaten_today
    today = Date.today
    all(:created_at => (today..today + 1), :order => [ :created_at.desc])
  end
end

helpers do
  def format_item(item)
    html = ""
    html = item.item
    unless item.kcal == 0
      html += " <em>#{item.kcal} kcal</em>"
    end
    html
  end

  def format_date(date)
    date.strftime("%l:%M%P")
  end
  
  def show_error_message(item)
    return if item.nil?
    if !item.valid?
      <<-eos
      <span class="error">
        Please enter an <strong>item</strong> and optionally a calorie amount
      </span>
      eos
    end
  end
end

before do
  @previously = Item.eaten_today if request.path_info == '/'
end

get '/' do
  erb :index
end

post '/' do
  @new = Item.new(:item => params[:item], :kcal => params[:kcal])
  redirect '/' if @new.save
  erb :index
end

get '/items' do
  content_type :json
  query = 'SELECT DISTINCT item, kcal FROM items WHERE item LIKE ? ORDER BY item ASC' 
  items = repository(:default).adapter.query(query, params[:q] + "%")
  output = []
  items.each do |item|
    output << { :item => item.item, :kcal => item.kcal }
  end
  output.to_json
end