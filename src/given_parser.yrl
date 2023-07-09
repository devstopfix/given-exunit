Nonterminals scenario clause prefix terms term words.
Terminals and_ atom date given hexadecimal int then when_ word.
Rootsymbol scenario.

% Scenario is a list of clauses
scenario -> clause : ['$1'].
scenario -> clause scenario : ['$1'|'$2'].

% Clause is a prefix followed by list of terms
clause -> prefix terms : ['$1', '$2'].

% Phrase is a list of words

words -> word : ['$1'].
words -> word words : ['$1'|'$2'].

% Terms

terms -> term : ['$1']. 
terms -> term terms : ['$1'|'$2']. 

term -> atom        : extract_token('$1').
term -> date        : extract_date('$1').
term -> hexadecimal : extract_hexadecimal('$1').
term -> int         : extract_token('$1').
term -> words       : extract_words_as_atom('$1').

prefix -> and_   : extract_prefix('$1').
prefix -> given  : extract_prefix('$1').
prefix -> then   : extract_prefix('$1').
prefix -> when_  : extract_prefix('$1').

Erlang code.

extract_prefix({Token, _Line}) -> Token.

extract_token({_Token, _Line, Value}) -> Value.

extract_date({_Token, _Line, Value}) -> apply('Elixir.Date', 'from_iso8601!', [Value]).

% TODO remove 0x
extract_hexadecimal({_Token, _Line, Value}) -> 
    {n, ""} = apply('Elixir.Integer', 'parse', [Value, 16]), n.

extract_words_as_atom([{_T, _L, H}| T]) -> 
    Words = lists:foldl(fun ({_, _, Value}, Acc) -> <<Acc/binary, "_", Value/binary>> end, H, T),
    binary_to_atom(string:lowercase(Words)).