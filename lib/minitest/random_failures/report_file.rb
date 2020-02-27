# frozen_string_literal: true

require 'fileutils'

module Minitest
  module RandomFailures
    class ReportFile
      extend Forwardable
      def_delegators :@file, :close, :each_line

      def initialize(file_name)
        @file_name = file_name
      end

      def puts(string)
        @file ||= create
        @file.puts string
      end
      alias_method :<<, :puts

      def open_read
        @file ||= File.read(@file_name, 'rb:UTF-8')
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
