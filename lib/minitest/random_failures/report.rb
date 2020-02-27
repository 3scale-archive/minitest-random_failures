# frozen_string_literal: true

require 'minitest/random_failures/report_file'

module Minitest
  module RandomFailures
    class Report
      DEFAULT_REPORT_FILE = 'test/reports/minitest-cross-deps'
      DELIMITER = "\0"

      def initialize(file_name = nil)
        @report_file = ReportFile.new(file_name || DEFAULT_REPORT_FILE)
      end

      def write(result)
        @report_file << [result.klass, result.name, failure_state(result)].join(DELIMITER)
      end

      def close
        @report_file.close if @report_file #rubocop:disable Style/SafeNavigation
      end

      private

      def failure_state(result)
        case
        when result.passed?
          :passed
        when result.skipped?
          :skipped
        else
          :failed
        end
      end
    end
  end
end