require_relative '../review'

describe Review do
  subject do
    described_class.new("user", "bottle", Time.now, "http://redd.it", 0, "Scotland")
  end

  describe '#uri' do
    it "prefixes with 'https://' when no scheme is specified" do
      subject.url = 'reddit.com'
      expect(subject.uri.to_s).to eq 'https://reddit.com'
    end

    it "removes any unicode characters for parsing" do
      subject.url = 'http://reddit.com/r/haskell/λ-calculus'
      expect(subject.uri.to_s).to eq 'http://reddit.com/r/haskell/-calculus'
    end
  end

  describe '#on_reddit?' do
    it 'returns true for reddit.com' do
      subject.url = 'de.reddit.com/r/scotch'
      expect(subject.on_reddit?).to be true
    end

    it 'returns true for redd.it' do
      subject.url = 'redd.it/4f68Gx'
      expect(subject.on_reddit?).to be true
    end
  end

  describe '#subreddit' do
    it 'returns nil if not on_reddit?' do
      subject.url = 'google.com'
      expect(subject.subreddit).to be nil
    end

    it 'returns the part after /r/' do
      subject.url = 'reddit.com/r/scotch/test'
      expect(subject.subreddit).to eq 'scotch'

      subject.url = 'http://reddit.com/r/scotch'
      expect(subject.subreddit).to eq 'scotch'
    end
  end
end
