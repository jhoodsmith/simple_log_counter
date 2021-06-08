# frozen_string_literal: true

require 'simple_log_counter'

RSpec.describe SimpleLogCounter::Formatter do
  context 'when page visits not unique' do
    it 'formats single count with one visit' do
      expect(described_class.format({ '/home' => 1 })).to eql "/home 1 visit\n"
    end

    it 'formats single count with multiple visits' do
      expect(described_class.format({ '/home' => 2 })).to eql "/home 2 visits\n"
    end

    it 'formats multiple counts with mixed visits' do
      expect(
        described_class.format({ '/home' => 2, '/about' => 1 })
      ).to eql "/home 2 visits\n/about 1 visit\n"
    end
  end

  context 'when page visits unique' do
    it 'formats single count with one visit' do
      expect(described_class.format({ '/home' => 1 }, unique: true)).to eql "/home 1 unique visit\n"
    end

    it 'formats single count with multiple visits' do
      expect(described_class.format({ '/home' => 2 }, unique: true)).to eql "/home 2 unique visits\n"
    end

    it 'formats multiple counts with mixed visits' do
      expect(
        described_class.format({ '/home' => 2, '/about' => 1 }, unique: true)
      ).to eql "/home 2 unique visits\n/about 1 unique visit\n"
    end
  end
end
