# frozen_string_literal: true

require 'minitest/random_failures/reporter'

module Minitest
  module RandomFailures
    class RunnerReporter < Reporter
      def current_failed?
        last_result = results.last
        last_result.failure && !last_result.skipped?
      end
    end
  end
end