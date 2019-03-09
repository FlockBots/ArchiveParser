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
    logfile = File.join(__dir__, 'parser.log')
    @logger = Logger.new(logfile)
  end

  def records
    @records || (@records = create_records)
  end

  def create_records
    rows = CSV.read @source, encoding: "UTF-8"
    rows.shift if @has_header

    Enumerator.new do |enum|
      rows.each do |row|
        begin
          enum.yield Review.new(
            parse_redditor(row[FIELDS[:redditor]]),
            parse_whisky(row[FIELDS[:whisky]]),
            parse_date(row[FIELDS[:date]]),
            parse_url(row[FIELDS[:url]]),
            parse_rating(row[FIELDS[:rating]]),
            parse_region(row[FIELDS[:region]]),
            parse_date(row[FIELDS[:timestamp]]) || Date.today
          )
        rescue => e
          @logger.error e.backtrace.inspect
        end
      end
    end
  end

  def parse_date(date)
    return nil if date.nil?
    string = date.strip
    m, d, y = string.split(/[^\d]/).reject(&:empty?)

    m, d = d, m if m.to_i > 12
    y = 2000 + y.to_i if y.to_i < 2000

    begin
      Date.new(y.to_i, m.to_i, d.to_i)
    rescue ArgumentError
      @logger.error "Invalid date '#{date}' (#{y}/#{m}/#{d})"
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
    return nil if rating.nil?
    rating.gsub(/[^\d\.,]/, '')
          .to_i
  end

  def parse_region(region)
    region.strip
          .gsub(/\s+/, ' ')
  end
end
