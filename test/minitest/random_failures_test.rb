require "test_helper"
require 'minitest/random_failures/reporter'
require 'minitest/random_failures/runner'

class Minitest::RandomFailuresTest < BaseTest

  test_fixture 'cross_dependencies'

  include Minitest::RandomFailures

  def setup
    super
    @reporter = Minitest::RandomFailures::Reporter.new
    CrossDependenciesTest.run(@reporter)
    @reporter.report
  end

  def test_reporter_saves_file
    assert @reporter.passed?
    assert File.exist?(ReportFile::DEFAULT_REPORT_FILE)
    report = File.read(ReportFile::DEFAULT_REPORT_FILE)
    results = report.each_line.map do |line|
      line.chomp!
      line.split("\0")
    end
    assert_equal 'failed', results.find{|line| line[1] == 'test_mutating_object' }.last
  end


  def test_runner
    runner = Runner.new
    tests = runner.run

    assert_equal 2, tests.size
  end
end
