# Given

Given-When-Then is a style of representing tests of specifying a system's
behaviour using specification by example - [Martin Fowler][gwt].

This is a micro library that is a lite extension to ExUnit and prefers 
pattern matching over regular expressions. There are other BDD libraries
but they do not seem to be maintained. The advantages of Given are:

1. no regular expressions
2. pattern match errors are clear and obvious
3. line numbers in errors are accurate as there are no separate text files


## Installation

```elixir
def deps do
  [
    {:given, "~> 0.22"}
  ]
end
```


[gwt]: https://martinfowler.com/bliki/GivenWhenThen.html