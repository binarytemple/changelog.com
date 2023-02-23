defmodule SecretOrEnv do
  require Logger

  def get(secret) do
    get(secret, :unset)
  end

  def get(secret, default_value) do
    path = "/run/secrets/#{secret}"

    case File.read(path) do
      {:ok, value} ->
        if Mix.env() == :prod do
          Logger.info("#{secret} read from #{path}")
        end

        String.trim(value)

      _ ->
        if Mix.env() == :prod do
          Logger.info("#{secret} read from environment variable")
        end

        if default_value == :unset do
          System.fetch_env!(secret)
        else
          System.get_env(secret, default_value)
        end
    end
  end
end
