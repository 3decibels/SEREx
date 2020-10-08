defmodule Serex.Lexer do

  @doc """
  Performs lexical analysis on a simple regex and returns a list of tokens.
  """
  def lex(regex) when is_binary(regex), do: regex |> String.graphemes |> Enum.map(&tokenize/1)

  @doc """
  Takes a single character string and returns a tokenized tuple.
  """
  def tokenize("."), do: {:wildcard}
  def tokenize("^"), do: {:bol}
  def tokenize("$"), do: {:eol}
  def tokenize("*"), do: {:zero_or_more}
  def tokenize(char) when is_binary(char), do: {:char, char}

end