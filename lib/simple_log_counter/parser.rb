# frozen_string_literal: true

require 'set'

module SimpleLogCounter
  # Parser class for translating web log to dictionary of indiviual page counts.
  # Algorithm centres around a reduction operation, time complexity = O(n)

  class Parser
    class << self
      # Parses web log file to dicionary of page counts
      # Time complexity
      def parse(log, unique: false)
        page_count_pairs = if unique
                             unique_visitor_counter(log)
                           else
                             visitor_counter(log)
                           end

        # Convert back to hash and sort in descending order.
        # TODO: make the direction of sorting a parameter
        Hash[page_count_pairs.sort_by { |_, n| -n }]
      end

      private

      def visitor_counter(log)
        counter = Hash.new { |h, k| h[k] = 0 }
        log.each_line
           .each_with_object(counter) { |line, hsh| hsh[page_from_line(line)] += 1 }
      end

      def unique_visitor_counter(log)
        counter = Hash.new { |h, k| h[k] = Set.new }
        log.each_line
           .each_with_object(counter) { |line, hsh| hsh[page_from_line(line)].add(visitor_from_line(line)) }
           .map { |page, visitors| [page, visitors.size] }
      end

      def page_from_line(line)
        line.match(%r{(^|(?<=\s))/\S*((?=\s)|$)}).to_s
      end

      def visitor_from_line(line)
        line.match(/(\d+\.){3}\d+/).to_s
      end
    end
  end
end
