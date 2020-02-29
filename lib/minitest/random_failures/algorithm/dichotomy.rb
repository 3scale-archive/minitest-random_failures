# frozen_string_literal: true

module Minitest
  module RandomFailures
    module Algorithm
      class Dichotomy
        attr_reader :tests

        def initialize(tests)
          @tests = tests.dup
          remove_trailing_success
        end

        def run(reporter)
          results = nil
          # Launching new Threads to run the tests to clear Thread states
          Thread.new do
            reporter.start

            tests.map do |test|
              test.run(reporter)
            end

            if reporter.current_failed? && tests.size > 2
              size = (tests.size / 2)
              results = self.class.new(tests[size..-1]).run(reporter)
            else
              results = tests
            end
          end.join
          results
        end

        protected

        def remove_trailing_success
          @tests.pop while @tests.last.success?
        end
      end
    end
  end
end
