require 'test/unit'
require 'test/unit/testresult'
require 'colored'

module Test
  module Unit
    class TestResult
      def to_s
        "#{run_count.to_s.yellow} tests, #{assertion_count.to_s.cyan} assertions, #{failure_count.to_s.red} failures, #{error_count.to_s.white_on_red} errors"
      end
    end

    class Error
      alias_method :plain_single_character_display, :single_character_display
      def single_character_display
        plain_single_character_display.white_on_red
      end

      alias_method :plain_message, :message
      def message
        "#{@exception.class.name.blue}: #{@exception.message.magenta}"
      end

      alias_method :plain_short_display, :short_display
      def short_display
        "#{@test_name.green}: #{message.split("\n")[0]}"
      end

      def plain_short_display
        "#{@test_name}: #{plain_message.split("\n")[0]}"
      end

      alias_method :plain_long_display, :long_display
      def long_display
         backtrace = filter_backtrace(@exception.backtrace).join("\n    ")
         "Error:\n#{@test_name.green}:\n#{message}\n    #{backtrace}"
      end

      def plain_long_display
        backtrace = filter_backtrace(@exception.backtrace).join("\n    ")
        "Error:\n#@test_name:\n#{plain_message}\n    #{backtrace}"
      end
    end

    class Failure
      alias_method :plain_single_character_display, :single_character_display
      def single_character_display
        plain_single_character_display.red
      end

      alias_method :plain_short_display, :short_display
      def short_display
        "#{@test_name.green}: #{@message.split("\n")[0].magenta}"
      end

      alias_method :plain_long_display, :long_display
      def long_display
        location_display = if(location.size == 1)
          location[0].sub(/\A(.+:\d+).*/, ' [\\1]')
        else
          "\n    [#{location.join("\n     ")}]"
        end
        "Failure:\n#{@test_name.green}#{location_display}:\n#@message"
      end
    end
  end
end
