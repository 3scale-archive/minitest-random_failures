# frozen_string_literal: true

require 'minitest/random_failures/report_file'

module Minitest
  module RandomFailures
    class Report
      DELIMITER = "\0"

      def initialize(file_name = nil)
        @report_file = ReportFile.new(file_name)
      end

      def write(result)
        @report_file << [result.klass, result.name, failure_state(result)].join(DELIMITER)
      end

      def close
        @report_file.close if @report_file #rubocop:disable Style/SafeNavigation
      end

      def parse
        @tests ||= @report_file.open_read
        @report_file.each_line.map do |line|
          yield line.chomp.split(DELIMITER)
        end
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