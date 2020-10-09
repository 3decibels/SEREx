defmodule SerexTest do
  use ExUnit.Case
  doctest Serex.Lexer
  doctest Serex.Matcher

  test "Lexing regex" do
    assert Serex.Lexer.lex("abc") == [char: "a", char: "b", char: "c"]
    assert Serex.Lexer.lex("^a.*c$") == [bol: nil, char: "a", wildcard: nil, star: nil, char: "c", eol: nil]
  end

  test "Regex matching normal characters" do
    assert Serex.Matcher.match("a", "abc") == true
    assert Serex.Matcher.match("bc", "abc") == true
    assert Serex.Matcher.match("abc", "abc") == true
    assert Serex.Matcher.match("d", "abc") == false
  end

  test "Regex matching beginning of line" do
    assert Serex.Matcher.match("^a", "abc") == true
    assert Serex.Matcher.match("^abc", "abc") == true
    assert Serex.Matcher.match("^b", "abc") == false
  end

  test "Regex matching end of line" do
    assert Serex.Matcher.match("c$", "abc") == true
    assert Serex.Matcher.match("abc$", "abc") == true
    assert Serex.Matcher.match("b$", "abc") == false
  end

  test "Regex matching wildcards" do
    assert Serex.Matcher.match(".bc", "abc") == true
    assert Serex.Matcher.match("a.c", "abc") == true
    assert Serex.Matcher.match("b.", "abc") == true
    assert Serex.Matcher.match(".ac", "abc") == false
  end

  test "Regex matching zero or more" do
    assert Serex.Matcher.match("a*bc", "abc") == true
    assert Serex.Matcher.match("a*bc", "aaaaabc") == true
    assert Serex.Matcher.match("a*bc", "bc") == true
    assert Serex.Matcher.match("a*bc", "aaab") == false
    assert Serex.Matcher.match("a*bc", "bbbbbbccc") == true
  end
end
