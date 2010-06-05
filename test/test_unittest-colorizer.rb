require 'helper'

class TestUnittestColorizer < Test::Unit::TestCase
  context "Test::Unit::TestResult" do
    should "color test output" do
      Test::Unit::TestResult.any_instance.expects(:run_count).returns 5
      Test::Unit::TestResult.any_instance.expects(:assertion_count).returns 21
      Test::Unit::TestResult.any_instance.expects(:failure_count).returns 3
      Test::Unit::TestResult.any_instance.expects(:error_count).returns 2

      result = Test::Unit::TestResult.new
      assert_equal "\e[33m5\e[0m tests, \e[36m21\e[0m assertions, \e[31m3\e[0m failures, \e[37m\e[41m2\e[0m errors", result.to_s
    end
  end

  context "Test::Unit::Error" do
    setup do
      @exception = Exception.new "I'm not excepted"
      @error = Test::Unit::Error.new "This is my test name", @exception
    end

    should "color :single_character_display" do
      assert_equal "\e[37m\e[41mE\e[0m", @error.single_character_display
    end

    should "have :plain_single_character_display" do
      assert_equal "E", @error.plain_single_character_display
    end

    should "color :message" do
      assert_equal "\e[34mException\e[0m: \e[35mI'm not excepted\e[0m", @error.message
    end

    should "have :plain_message" do
      assert_equal "Exception: I'm not excepted", @error.plain_message
    end

    should "color :short_display" do
      assert_equal "\e[32mThis is my test name\e[0m: \e[34mException\e[0m: \e[35mI'm not excepted\e[0m", @error.short_display
    end

    should "provide :plain_short_display" do
      assert_equal "This is my test name: Exception: I'm not excepted", @error.plain_short_display
    end

    should "color :long_display" do
      Test::Unit::Error.any_instance.expects(:filter_backtrace).returns ["\e[37m\e[40mI would be a backtrace...",""," if I had been called\e[0m"]
      assert_equal "Error:\n\e[32mThis is my test name\e[0m:\n\e[34mException\e[0m: \e[35mI'm not excepted\e[0m\n    \e[37m\e[40mI would be a backtrace...\n    \n     if I had been called\e[0m", @error.long_display
    end

    should "have :plain_long_display" do
      Test::Unit::Error.any_instance.expects(:filter_backtrace).returns ["I would be a backtrace...",""," if I had been called"]
      assert_equal "Error:\nThis is my test name:\nException: I'm not excepted\n    I would be a backtrace...\n    \n     if I had been called", @error.plain_long_display
    end
  end

  context "Test::Unit::Failure" do
    setup do
      @failure = Test::Unit::Failure.new "I'm such a failure", ["I happened right here:59 some stuff"], "Do you want me to apologize?\nI'm really not that kind of failure\n"
    end

    should "color single_character_display" do
      assert_equal "\e[31mF\e[0m", @failure.single_character_display
    end

    should "have :plain_single_character_display" do
      assert_equal "F", @failure.plain_single_character_display
    end

    should "color :short_display" do
      assert_equal "\e[32mI'm such a failure\e[0m: \e[35mDo you want me to apologize?\e[0m", @failure.short_display
    end

    should "have :plain_short_display" do
      assert_equal "I'm such a failure: Do you want me to apologize?", @failure.plain_short_display
    end

    context "color :long_display with no real location data" do
      setup do
        @failure = Test::Unit::Failure.new "I'm such a failure", ["I happened right here"], "Do you want me to apologize?\nI'm really not that kind of failure\n"
      end

      should "be colored" do
        assert_equal "Failure:\n\e[32mI'm such a failure\e[0mI happened right here:\nDo you want me to apologize?\nI'm really not that kind of failure\n", @failure.long_display
      end

      should "have plain uncolored method" do
        assert_equal "Failure:\nI'm such a failureI happened right here:\nDo you want me to apologize?\nI'm really not that kind of failure\n", @failure.plain_long_display
      end
    end

    context "color :long_display with some location data" do
      setup do
        @failure = Test::Unit::Failure.new "I'm such a failure", ["I happened right here:59 some stuff"], "Do you want me to apologize?\nI'm really not that kind of failure\n"
      end

      should "be colored" do
        assert_equal "Failure:\n\e[32mI'm such a failure\e[0m [I happened right here:59]:\nDo you want me to apologize?\nI'm really not that kind of failure\n", @failure.long_display
      end

      should "have plain uncolored method" do
        assert_equal "Failure:\nI'm such a failure [I happened right here:59]:\nDo you want me to apologize?\nI'm really not that kind of failure\n", @failure.plain_long_display
      end
    end

    context "color :long_display with lots of location data" do
      setup do
        @failure = Test::Unit::Failure.new "I'm such a failure", ["I happened right here:59","Some more stuff:60"], "Do you want me to apologize?\nI'm really not that kind of failure\n"
      end

      should "be colored" do
        assert_equal "Failure:\n\e[32mI'm such a failure\e[0m\n    [I happened right here:59\n     Some more stuff:60]:\nDo you want me to apologize?\nI'm really not that kind of failure\n", @failure.long_display
      end

      should "have plain uncolored method" do
        assert_equal "Failure:\nI'm such a failure\n    [I happened right here:59\n     Some more stuff:60]:\nDo you want me to apologize?\nI'm really not that kind of failure\n", @failure.plain_long_display
      end
    end

  end
end
