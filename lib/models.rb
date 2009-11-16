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