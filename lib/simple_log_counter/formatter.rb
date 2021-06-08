# frozen_string_literal: true

module SimpleLogCounter
  class Formatter
    class << self
      def format(page_visits, unique: false)
        page_visits.map do |page, n|
          visits = n == 1 ? 'visit' : 'visits'
          "#{page} #{n}#{unique ? ' unique ' : ' '}#{visits}\n"
        end.join
      end
    end
  end
end
