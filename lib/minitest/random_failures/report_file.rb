# frozen_string_literal: true

require 'fileutils'
require 'forwardable'

module Minitest
  module RandomFailures
    class ReportFile
      DEFAULT_REPORT_FILE = 'test/reports/minitest-cross-deps'

      extend Forwardable
      def_delegators :@file, :close, :each_line

      def initialize(file_name=nil)
        @file_name = file_name || DEFAULT_REPORT_FILE
      end

      def puts(string)
        @file ||= create
        @file.puts string
      end
      alias_method :<<, :puts

      def open_read
        @file ||= File.read(@file_name, mode: 'rb:UTF-8')
      end

      private

      def create
        dir = File.dirname(@file_name)
        FileUtils.mkdir_p(dir)
        @file = File.new(@file_name, 'wb:UTF-8')
      end
    end
  end
end
