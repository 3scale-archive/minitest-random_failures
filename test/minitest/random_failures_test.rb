require "test_helper"
require 'minitest/random_failures/reporter'

class Minitest::RandomFailuresTest < BaseTest

  test_fixture 'cross_dependencies'

  include Minitest::RandomFailures

  def test_reporter_saves_file
    reporter = Minitest::RandomFailures::Reporter.new

    CrossDependenciesTest.run(reporter)

    reporter.report
    assert reporter.passed?
    assert File.exist?(Report::DEFAULT_REPORT_FILE)
    report = File.read(Report::DEFAULT_REPORT_FILE)
    report.chomp!
    results = report.each_line.map do |line|
      line.split("\0")
    end
    assert_equal 'failed', results.find{|line| line[1] == 'test_mutating_object' }.last
  end
end
