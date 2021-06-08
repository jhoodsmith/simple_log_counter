# frozen_string_literal: true

require 'simple_log_counter'

RSpec.describe SimpleLogCounter::Parser do
  describe 'Counting non-unique visits' do
    context 'when /home as 1 visit and /about has 2' do
      let(:log) do
        '/about 1.2.3.4
/home 1.2.3.4
/about 1.2.3.4
'
      end

      it 'counts one for /home' do
        expect(described_class.parse(log)['/home']).to eql 1
      end

      it 'counts two for /about' do
        expect(described_class.parse(log)['/about']).to eql 2
      end
    end

    context 'when /home has 2, /about has 3 and /contact has 1' do
      let(:log) do
        '/home 1.2.3.4
/home 1.2.3.4
/about 1.2.3.4
/contact 1.2.3.4
/about 1.2.3.4
/contact 1.2.3.4
/about 1.2.3.4
'
      end

      it 'returns hash in desending order of page vists' do
        expect(described_class.parse(log).keys).to eql ['/about', '/home', '/contact']
      end
    end

    context 'when empty string' do
      it 'returns empty hash' do
        expect(described_class.parse('')).to eql({})
      end
    end
  end

  describe 'Counting unique visits' do
    context 'when /home has 2 unique vists out of a total of 5' do
      let(:log) do
        '/home 1.2.3.4
/home 1.2.3.5
/home 1.2.3.4
/home 1.2.3.4
/home 1.2.3.4
'
      end

      it 'counts 2 visits for /home' do
        expect(described_class.parse(log, unique: true)['/home']).to eql 2
      end
    end

    context 'when /home has 3 unique vists and /about has 2' do
      let(:log) do
        '/home 1.2.3.4
/home 10.20.30.50
/home 100.200.300.600
/home 1.2.3.4
/home 1.2.3.4
/about 1.2.3.4
/about 1.2.3.4
/about 10.20.30.60
'
      end
      it 'returns hash in descending order of page visits' do
        expect(described_class.parse(log).keys).to eql ['/home', '/about']
      end

      it 'counts correct unique visits' do
        counts = described_class.parse(log, unique: true)
        expect(counts['/home']).to eql 3
        expect(counts['/about']).to eql 2
      end
    end
  end
end
