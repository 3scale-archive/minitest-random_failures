# frozen_string_literal: true

module Minitest
  module RandomFailures
    class TestProxy

      def initialize(klassname, name, original_state)
        @test = Object.const_get(klassname).new(name)
        @original_state = original_state
      end

      def run(reporter)
        reporter.record @test.run
        self
      end

      def passed?
        @original_state == 'passed'
      end
      alias_method :success?, :passed?

      def failed?
        @original_state == 'failed'
      end

      def skipped?
        @original_state == 'skipped?'
      end
    end
  end
end