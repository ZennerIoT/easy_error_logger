defmodule ErrorLogger do
  require Logger

  @type message :: binary | [message]
  @type kind :: :error | :exit
  @type error :: any

  @doc """
  Formats and logs the given error using `Exception.format/3` and `Logger.error/1`.

  Depending on from where this macro is called, it will also include
  the stacktrace that was recorded with the error in the log message.

  `message` is an optional binary that will be printed before the formatted error message.

  `kind` (default `:error`) can be set to `:exit` if the error is a caught exit.

  `error` can be anything, special formatting will be done for certain Erlang error atoms or tuples,
          as well as Elixir exceptions.
  """
  defmacro log_error(message \\ nil, kind \\ :error, error) do
    quote do
      unquote(error)
      |> Platform.ErrorLogging.format_error(unquote(kind))
      |> Platform.ErrorLogging.log_formatted(unquote(message))
    end
  end

  @doc """
  Formats the given error using `Exception.format/3`.

  Adds the current stack trace, if available.
  """
  defmacro format_error(error, kind) do
    if in_catch?(__CALLER__) do
      quote do
        Exception.format(unquote(kind), unquote(error), __STACKTRACE__)
      end
    else
      quote do
        Exception.format(unquote(kind), unquote(error))
      end
    end
  end

  @doc """
  Logs a formatted error with an optional preceding message.
  """
  @spec log_formatted(binary, message) :: :ok
  def log_formatted(formatted, message) do
    [message, formatted]
    |> Enum.reject(&is_nil/1)
    |> Enum.join("\n")
    |> Logger.error()
  end

  @doc """
  Returns if the environment is within a catch or rescue clause.

  Use it like this in a macro:

      defmacro maybe_get_stacktrace() do
        if in_catch?(__CALLER__) do
          quote do __STACKTRACE__ end
        else
          quote do [] end
        end
      end
  """
  @spec in_catch?(Macro.Env.t) :: boolean
  def in_catch?(env) do
    env
    |> Map.get(:contextual_vars, [])
    |> Enum.member?(:__STACKTRACE__)
  end
end
