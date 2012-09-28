require 'test_helper'
require 'test/unit'

class SQLSlaveCheckerTest < Test::Unit::TestCase
  def setup
    @slave_checker = DataFabric::DynamicSwitching::SQLSlaveChecker.new("test_slave")
    ActiveRecord::Base.establish_connection :test_master
    @slave_checker.slave_connection = ActiveRecord::Base.connection
  end

  def test_seconds_behind_should_return_lots_of_lag_for_an_improper_setup
    assert @slave_checker.seconds_behind > 100, "did not return lag"
  end

  def test_it_should_not_change_the_connection_for_non_replicated_classes
    assert NormalModel.first.name =~ /master/
    @slave_checker.seconds_behind
    assert NormalModel.first.name =~ /master/
  end
end
