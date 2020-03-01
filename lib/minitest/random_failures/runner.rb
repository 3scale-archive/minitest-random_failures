# frozen_string_literal: true

require 'optparse'
require 'minitest'
require 'minitest/random_failures/report'
require 'minitest/random_failures/runner_reporter'
require 'minitest/random_failures/test_proxy'
require 'minitest/random_failures/algorithm/dichotomy'

module Minitest
  module RandomFailures
    class Runner

      def self.parse_argv(args)
        options = {}

        OptionParser.new do |opts|
          opts.banner  = "minitest_random_failures options:"
          opts.version = Minitest::RandomFailures::VERSION

          opts.on "-h", "--help", "Display this help." do
            puts opts
            exit
          end

          opts.on "-v", "--version", "Display the version." do
            puts opts.version
            exit
          end

          opts.on '--replay-cross-deps FILE', 'Replay cross dependencies failing tests. Trying to find minimal combination of failing tests' do |file|
            options[:replay_cross_deps] = true
            options[:replay_cross_dep_file] = file
          end

          # TODO: should be saved in the report file
          opts.on '-r', '--test-files FILES', Array, 'Requiring your test files first' do |files|
            options[:test_files] = files
          end
          opts.parse!(args)
        end
        options
      end

      def self.run(args)
        options = parse_argv(args)
        new(options).run
      end

      attr_reader :options
      def initialize(options = {})
        @options = options
        @report = Report.new(options[:replay_cross_dep_file])
      end

      def run
        reporter = RunnerReporter.new(options[:replay])
        dichotomy  = Algorithm::Dichotomy.new(tests_to_run)
        dichotomy.run(reporter)
        reporter
      end

      def tests_to_run
        options[:test_files].each(&method(:require))

        @tests ||= @report.parse do |report_array|
          TestProxy.new(*report_array)
        end
      end
    end
  end
end
