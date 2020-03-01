# frozen_string_literal: true

require 'minitest/random_failures/reporter'

module Minitest
  module RandomFailures
    class RunnerReporter < Reporter
      def start
        results.clear
      end

      def current_failed?
        last_result = results.last
        last_result.failure && !last_result.skipped?
      end

      def report
        super
        results.each do |result|
          puts result.source_location.inspect
        end
      end
    end
  end
end