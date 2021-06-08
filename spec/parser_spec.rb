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

  describe '#visitor_from_line' do
    # NOTE: as this is a private method of Parser it needs to be called with #send
    it 'reads from simple log format' do
      expect(
        described_class.send(:visitor_from_line, '/ 1.2.3.4')
      ).to eql '1.2.3.4'
    end

    it 'reads from reversed simple log format' do
      expect(
        described_class.send(:visitor_from_line, '1.2.3.4 /')
      ).to eql '1.2.3.4'
    end

    it 'reads from IIS format' do
      expect(
        described_class.send(:visitor_from_line, '02:49:12 127.0.0.1 GET / 200')
      ).to eql '127.0.0.1'
    end

    it 'reads from Apache format' do
      line = '192.168.198.92 - - [22/Dec/2002:23:08:37 -0400] "GET / HTTP/1.1" 200 6394 www.yahoo.com "-" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1...)" "-"'
      expect(
        described_class.send(:visitor_from_line, line)
      ).to eql '192.168.198.92'
    end
  end

  describe '#page_from_line' do
    # NOTE: as this is a private method of Parser it needs to be called with #send
    context 'when root page' do
      it 'reads from simple log format' do
        expect(
          described_class.send(:page_from_line, '/ 1.2.3.4')
        ).to eql '/'
      end

      it 'reads from reversed simple log format' do
        expect(
          described_class.send(:page_from_line, '1.2.3.4 /')
        ).to eql '/'
      end

      it 'reads from IIS format' do
        expect(
          described_class.send(:page_from_line, '02:49:12 127.0.0.1 GET / 200')
        ).to eql '/'
      end

      it 'reads from Apache format' do
        line = '192.168.198.92 - - [22/Dec/2002:23:08:37 -0400] "GET / HTTP/1.1" 200 6394 www.yahoo.com "-" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1...)" "-"'
        expect(
          described_class.send(:page_from_line, line)
        ).to eql '/'
      end
    end

    context 'when non-root page' do
      it 'reads from simple log format' do
        expect(
          described_class.send(:page_from_line, '/home 1.2.3.4')
        ).to eql '/home'
      end

      it 'reads from reversed simple log format' do
        expect(
          described_class.send(:page_from_line, '1.2.3.4 /home/2')
        ).to eql '/home/2'
      end

      it 'reads from IIS format' do
        expect(
          described_class.send(:page_from_line, '02:49:12 127.0.0.1 GET /home.html 200')
        ).to eql '/home.html'
      end

      it 'reads from Apache format' do
        line = '192.168.198.92 - - [22/Dec/2002:23:08:37 -0400] "GET /home HTTP/1.1" 200 6394 www.yahoo.com "-" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1...)" "-"'
        expect(
          described_class.send(:page_from_line, line)
        ).to eql '/home'
      end
    end
  end
end
