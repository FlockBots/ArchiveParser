class Review <
  Struct.new(:redditor, :whisky, :published_at, :url, :rating, :region, :archived_at)

  def hash
    [redditor, whisky, url].hash
  end

  def valid?
    valid_link? && on_reddit?
  end

  def invalid?
    !valid?
  end

  def uri
    return @uri unless @uri.nil?
    new_uri = url.gsub(/\P{ASCII}/, '')
    new_uri = 'http://' + new_uri if (new_uri =~ /^https?:\/\//).nil?
    @uri = URI.parse new_uri
  end

  def valid_link?
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  end

  def on_reddit?
    !!((uri.host =~ /reddit.com$/) || (uri.host =~ /redd.it$/))
  end

  def subreddit
    return nil if !on_reddit?
    parts = uri.path.split('/')
    return nil if parts.count < 3 || parts[1] != 'r'
    return parts[2].downcase
  end
end