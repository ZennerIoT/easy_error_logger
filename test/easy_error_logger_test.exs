defmodule EasyErrorLoggerTest do
  use ExUnit.Case
  import Mock
  import ErrorLogger

  def log_mocks do
    [
      __should_log__: fn(_) -> true end,
      __do_log__: fn(_, _, _) -> :ok end
    ]
  end

  test "to log an error" do
    with_mock(Logger, log_mocks()) do
      log_error(:enoent)

      assert_log_message("** (ErlangError) Erlang error: :enoent", :error)
    end
  end

  test "to log a rescued exception with stack trace" do
    with_mock(Logger, log_mocks()) do
      try do
        1 = 2
      rescue
        error -> log_error(error)
      end

      # if this fails, check if the first line of the error message is correct,
      # and that there's a stack trace, then copy-paste the new message
      assert_log_message("** (MatchError) no match of right hand side value: 2\n    test/easy_error_logger_test.exs:24: EasyErrorLoggerTest.\"test to log a rescued exception with stack trace\"/1\n    (ex_unit) lib/ex_unit/runner.ex:355: ExUnit.Runner.exec_test/1\n    (stdlib) timer.erl:166: :timer.tc/1\n    (ex_unit) lib/ex_unit/runner.ex:306: anonymous fn/4 in ExUnit.Runner.spawn_test_monitor/4\n", :error)
    end
  end

  test "different log level" do
    with_mock(Logger, log_mocks()) do
      log_error(:badarg, :warn)

      assert_log_message("** (ArgumentError) argument error", :warn)
    end
  end

  test "log_error_raw" do
    with_mock(Logger, log_mocks()) do
      try do
        throw :abc
      catch
        kind, error -> log_error_raw(nil, kind, error)
      end

      assert_log_message("** (throw) :abc\n    test/easy_error_logger_test.exs:46: EasyErrorLoggerTest.\"test log_error_raw\"/1\n    (ex_unit) lib/ex_unit/runner.ex:355: ExUnit.Runner.exec_test/1\n    (stdlib) timer.erl:166: :timer.tc/1\n    (ex_unit) lib/ex_unit/runner.ex:306: anonymous fn/4 in ExUnit.Runner.spawn_test_monitor/4\n", :error)
    end
  end

  def assert_log_message(msg, level) do
    assert_called(Logger.__should_log__(level))
    assert_called(Logger.__do_log__(true, msg, :_))
  end
end
