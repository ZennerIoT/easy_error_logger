defmodule EasyErrorLogger.MixProject do
  use Mix.Project

  def project do
    [
      app: :easy_error_logger,
      version: "1.0.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      source_url: "https://github.com/ZennerIoT/easy_error_logger/tree/master/"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  def package() do
    [
      name: "easy_error_logger",
      licenses: ["MIT"],
      description: "Makes logging of caught, rescued and unmatched errors easier.",
      maintainers: ["Moritz Schmale <ms@zenner-iot.com>"],
      links: %{
        GitHub: "https://github.com/ZennerIoT/easy_error_logger"
      }
    ]
  end
end
