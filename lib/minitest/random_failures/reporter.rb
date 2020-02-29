# frozen_string_literal: true

require 'minitest/random_failures/report'

module Minitest
  module RandomFailures
    class Reporter < Minitest::Reporter

      attr_accessor :results

      def initialize(*)
        super
        self.results = []
        @report = Report.new(options[:save_cross_deps_file])
      end

      attr_reader :results

      def record(result)
        super
        self.results << result
      end

      def start
      end

      def report
        # super is noop but in case for compatibility with future versions
        super

        results.each do |result|
          @report.write(result)
        end
      rescue => error
        # TODO: log the message
        puts error.message
        @error = true
      ensure
        @report.close
      end

      def passed?
        !@error
      end
    end
  end
end

