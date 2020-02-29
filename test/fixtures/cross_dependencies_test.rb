require 'test_helper'

class CrossDependenciesTest < NonAutorunTest
  seed 20

  Thread.current[:ramdom_failure] = 5

  def test_change_test
    Thread.current[:ramdom_failure] = 42
    assert_equal 42, Thread.current[:ramdom_failure]
  end

  def test_mutating_object
    Thread.current[:ramdom_failure] += 5
    assert_equal 10, Thread.current[:ramdom_failure]
  end

  def test_nothing_to_do
  end

  def test_empty_test
  end
end
