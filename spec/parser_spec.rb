require_relative '../parser'

describe Parser do

  subject do
    Parser.new(nil)
  end

  RSpec.shared_examples "whitespace remover" do
    let(:input) {"\twh\nit  e"}
    it 'removes whitespace' do
      expect(operation_result).to eq "white"
    end
  end

  RSpec.shared_examples "whitespace trimmer" do
    let(:input) {"\twh\nit  e"}
    it 'trims whitespace' do
      expect(operation_result).to eq "wh it e"
    end
  end

  describe '#parse_redditor' do
    it_behaves_like 'whitespace remover' do
      let(:operation_result) {subject.parse_redditor(input)}
    end
  end

  describe '#parse_url' do
    it_behaves_like 'whitespace remover' do
      let(:operation_result) {subject.parse_url(input)}
    end
  end

  describe '#parse_whisky' do
    it_behaves_like 'whitespace trimmer' do
      let(:operation_result) {subject.parse_whisky(input)}
    end
  end

  describe '#parse_region' do
    it_behaves_like 'whitespace trimmer' do
      let(:operation_result) {subject.parse_region(input)}
    end
  end

  describe '#parse_rating' do
    it 'converts to Fixnum' do
      expect(subject.parse_rating('86')).to be_a Fixnum
    end

    it 'removes any non-digits' do
      expect(subject.parse_rating('4a3b/100')).to eq 43100
    end
  end

  describe '#parse_date' do
    it 'converts to Date' do
      expect(subject.parse_date('01/01/1970')).to be_a Date
    end

    it 'assumes %m-%d-%Y format' do
      expect(subject.parse_date('12-25-2010')).to eq Date.new(2010,12,25)
    end

    it 'ignores can use any non-digit as a delimiter' do
      expect(subject.parse_date('12.25.2011')).to eq Date.new(2011,12,25)
      expect(subject.parse_date('12-25.2012')).to eq Date.new(2012,12,25)
      expect(subject.parse_date('12m25d2013')).to eq Date.new(2013,12,25)
    end

    it 'handles two digit years' do
      expect(subject.parse_date('12.25.10')).to eq Date.new(2010,12,25)
    end

    it 'handles four digit years' do
      expect(subject.parse_date('12.25.2010')).to eq Date.new(2010,12,25)
    end

    it 'swaps month and day if month > 12' do
      expect(subject.parse_date('25.12.2010')).to eq Date.new(2010,12,25)
    end
  end
end