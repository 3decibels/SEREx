defmodule Serex.Matcher do
  @moduledoc """
  This module provides functions used to match regular expressions against text.
  """

  @doc """
  Searches for a regular expression match in supplied text and returns true if found.
  """
  def match(regex, text) when is_binary(regex) and is_binary(text) do
    tokens = Serex.Lexer.lex(regex)
    chars = String.graphemes(text)
    case List.first(tokens) do
      {:bol, nil} ->
        match_here(Enum.drop(tokens, 1), chars)
      nil ->
        match_here(tokens, [])
      _ ->
        match_incremental(tokens, chars)
    end
  end

  # Search for a regex match incrementally through a supplied list of chars
  defp match_incremental(_tokens, [] = _chars), do: false
  defp match_incremental(tokens, chars) when is_list(tokens) and is_list(chars) and length(chars) > 0 do
    case match_here(tokens, chars) do
      true ->
        true
      _ ->
        match_incremental(tokens, Enum.drop(chars, 1))
    end
  end

  # Search for a regex match at the start of a supplied list of chars
  defp match_here([] = _tokens, _chars), do: true
  defp match_here([{:eol, nil} | []] = _tokens, chars) when is_list(chars), do: length(chars) == 0
  defp match_here(tokens, [] = _chars) when is_list(tokens), do: false
  defp match_here([token_head | token_tail], [char_head | char_tail] = chars) do
    {token_type, token_value} = token_head
    cond do
      List.first(token_tail) == {:star, nil} ->
        match_star(token_head, Enum.drop(token_tail, 1), chars)
      token_type == :wildcard ->
        match_here(token_tail, char_tail)
      token_value == char_head ->
        match_here(token_tail, char_tail)
      true ->
        false
    end
  end

  # Search for zero or more instances of a character at the start of a supplied list of chars
  defp match_star(_token , tokens, [] = _chars) when is_list(tokens), do: match_here(tokens, [])
  defp match_star({:wildcard, nil} = token, tokens, [_char_head | char_tail] = chars) when is_list(tokens) do
    case match_here(tokens, char_tail) do
      true ->
        true
      _ ->
        match_star(token, tokens, char_tail)
    end
  end
  defp match_star({:char, token_value} = token, tokens, [_char_head | char_tail] = chars) when is_list(tokens) do
    next_char = List.first(char_tail)
    cond do
      match_here(tokens, char_tail) == true ->
        true
      next_char == token_value ->
        match_star(token, tokens, char_tail)
      true ->
        false
    end
  end

end