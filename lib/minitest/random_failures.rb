require "minitest/random_failures/version"

module Minitest
  def self.plugin_random_failures_init(options)
    # We do not use the standard Minitest::Report @io to do the report
    self.reporter << Minitest::RandomFailures::Reporter.new if options[:save_cross_deps]
  end

  def self.plugin_random_failures_options(opts, options)
    opts.on "--save-cross-deps", "Saving cross dependencies tests in a file to be replayed later" do |file|
      options[:save_cross_deps] = true
      options[:save_cross_deps_file] = file
    end
  end

  module RandomFailures
    class Error < StandardError; end
    # Your code goes here...
    #

  end
end
