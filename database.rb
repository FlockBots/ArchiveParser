require 'data_mapper'

module Database
  class Review
    include DataMapper::Resource
    property :whisky,       String, length: 255, key: true
    property :region,       String, length: 255
    property :redditor,     String, length: 255, key: true
    property :url,          String, length: 255, key: true
    property :subreddit,    String, length: 31
    property :rating,       Integer
    property :region,       String, length: 255
    property :published_at, DateTime
  end
  DataMapper.finalize

  def self.setup(path)
    path = File.expand_path(path)
    DataMapper.setup(:default, "sqlite://#{path}")
    DataMapper.auto_upgrade!
  end
end
