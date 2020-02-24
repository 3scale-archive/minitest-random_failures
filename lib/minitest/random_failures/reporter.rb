# frozen_string_literal: true

require 'fileutils'

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

      def report
        # super is noop but in case for compatibility with future versions
        super

        results.each do |result|
          @report.write(result)
        end
      rescue => error
        puts error.message
        @error = true
      ensure
        @report.close
      end

      def passed?
        !@error
      end

      def report_file_name
        @report.file_name
      end
    end

    class Report
      DEFAULT_REPORT_FILE = 'test/reports/minitest-cross-deps'
      DELIMITER = "\0"

      attr_reader :file_name

      def initialize(file_name = nil)
        @file_name = file_name || DEFAULT_REPORT_FILE
        @report_file = create_report_file
      end

      def write(result)
        @report_file.puts [result.klass, result.name, failure_state(result)].join(DELIMITER)
      end

      def close
        @report_file.close if @report_file #rubocop:disable Style/SafeNavigation
      end

      private

      def create_report_file
        dir = File.dirname(@file_name)
        FileUtils.mkdir_p(dir)
        File.new(@file_name, 'wb:UTF-8')
      end

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

