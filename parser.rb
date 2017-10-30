require 'csv'
require 'logger'
require 'uri'
require_relative 'review'

class Parser
  FIELDS = {
    timestamp: 0,
    whisky: 1,
    redditor: 2,
    url: 3,
    rating: 4,
    region: 5,
    price: 6,
    date: 7
  }

  def initialize(source, has_header=true)
    @source = source
    @has_header = has_header
    @logger = Logger.new('parser.log')
  end

  def records
    @records || (@records = create_records)
  end

  def record_number
    @record_number || 0
  end

  def create_records
    rows = CSV.read @source
    rows.shift if @has_header

    Enumerator.new do |enum|
      i = 0
      rows.each do |row|
        @record_number = i += 1
        enum.yield Review.new(
          parse_redditor(row[FIELDS[:redditor]]),
          parse_whisky(row[FIELDS[:whisky]]),
          parse_date(row[FIELDS[:date]]),
          parse_url(row[FIELDS[:url]]),
          parse_rating(row[FIELDS[:rating]]),
          parse_region(row[FIELDS[:region]]),
          parse_date(row[FIELDS[:timestamp]]) || Date.today
        )
      end
    end
  end

  def parse_date(date)
    return nil if date.nil?
    string = date.gsub(/\s+/, '')
    m,d,y = string.split(/[^\d]/).reject(&:empty?)
    m, d = d, m if m.to_i > 12
    y = 2000 + y.to_i if y.to_i < 2000
    date_string = [m,d,y].join('/')
    begin
      Date.strptime(date_string, '%m/%d/%Y')
    rescue ArgumentError
      @logger.error "Invalid date '#{string} -> #{date_string}'"
      nil
    end
  end

  def parse_redditor(redditor)
    redditor.gsub(/\s+/, '')
  end

  def parse_whisky(whisky)
    whisky.strip
          .gsub(/\s+/, ' ')
  end

  def parse_url(url)
    url.gsub(/\s+/, '')
  end

  def parse_rating(rating)
    rating.gsub(/[^\d]/, '')
          .to_i
  end

  def parse_region(region)
    region.strip
          .gsub(/\s+/, ' ')
  end
end