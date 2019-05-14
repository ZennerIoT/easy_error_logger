# EasyErrorLogger

Makes logging of caught, rescued and unmatched errors easier.

In Elixir, the way to get beatiful error messages with a well-formatted stack trace 
isn't as straightforward as in other languages, where a single line is often enough
to format the error message, the stack trace and also print it to the console.

Usually, you'd have to do something like this:

```elixir
try do
  handle_foo!()
catch
  e ->
    formatted = Exception.format(:error, e, __STACKTRACE__)
    Logger.error(["I really tried, but this error occurred:\n", e])
end
```

which is hard to remember. In EasyErrorLogger, it's as simple as this:

```elixir
# top of module
import ErrorLogger

try do
  handle_foo!()
catch 
  e -> log_message_and_error("I really tried, but this error occurred:", e)
end
```

This results in the following log message:

```
[error] I really tried, but this error occurred:
** (TheThrownError) Something went wrong
    (elixir) lib/foo_lib/foo.ex:10 Foo.handle_foo!/0
    (elixir) lib/application.ex:18 MyApplication.start/2
```

In this single line, EasyErrorLogger has figured out that it can get a stacktrace
from `__STACKTRACE__`, which is not possible outside of `catch` or `rescue` clauses.

This means that the same macro can be used for errors that were received from an error 
tuple:

```elixir
case handle_foo() do
  :ok -> :ok
  {:error, error} -> log_message_and_error("This didn't work:", error)
end
```

Note that this way of logging the error message will not include a stack trace. This might
be adressed in a future update.

## Installation

The package can be installed by adding `easy_error_logger` to your list 
of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:easy_error_logger, "~> 1.0"}
  ]
end
```

Documentation can be found at 
[https://hexdocs.pm/easy_error_logger](https://hexdocs.pm/easy_error_logger).

