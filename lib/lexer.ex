defmodule Serex.Lexer do
  @moduledoc """
  This module provides functions for lexing simple regular expressions.
  """

  @doc """
  Performs lexical analysis on a simple regex and returns a list of tokens.
  """
  def lex(regex) when is_binary(regex), do: regex |> String.graphemes |> Enum.map(&tokenize/1)

  @doc """
  Takes a single character string and returns a tokenized tuple.
  """
  def tokenize("."), do: {:wildcard, nil}
  def tokenize("^"), do: {:bol, nil}
  def tokenize("$"), do: {:eol, nil}
  def tokenize("*"), do: {:star, nil}
  def tokenize(char) when is_binary(char), do: {:char, char}

end