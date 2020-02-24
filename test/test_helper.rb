$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require 'bundler'

Bundler.require(:default, :test)

require "minitest/random_failures"

require "minitest/autorun"

# Requiring the minitest helpers
# minitest_dir = Gem::Specification.find_by_name("minitest").gem_dir
# require File.join(minitest_dir, 'test', 'minitest', 'metametameta')

# Always inherit from this test instead of Minitest::Test
# To gain advantage of helpers
class BaseTest < Minitest::Test
  def self.test_fixture(fixture)
    require File.join(File.dirname(__FILE__), 'fixtures', "#{fixture}_test.rb")
  end
end

# Do not run the tests with autorun
class NonAutorunTest < Minitest::Test

  def self.seed(seed)
    @seed = seed
  end

  def self.run(*)
    srand @seed if @seed
    super
    srand
  end

  def self.inherited(klass)
    super
    Minitest::Runnable.runnables.delete klass
  end
end
Minitest::Runnable.runnables.delete(NonAutorunTest)
