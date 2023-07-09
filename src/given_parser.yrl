Nonterminals scenario given_clause when_clause then_clause terms term words.
Terminals atom date given_ hexadecimal int then_ when_ word.
Rootsymbol scenario.

% Scenario is a list of clauses
scenario -> given_clause when_clause then_clause : ['$1', '$2', '$3'].

given_clause -> given_ terms : {extract_token('$1'), list_to_tuple('$2')}.
when_clause  -> when_ terms : {extract_token('$1'), list_to_tuple('$2')}.
when_clause  -> '$empty' : nil.
then_clause  -> then_ terms : {extract_token('$1'), list_to_tuple('$2')}.
then_clause  -> '$empty' : nil.

% Phrase is a list of words

words -> word : ['$1'].
words -> word words : ['$1'|'$2'].

% Terms

terms -> term : ['$1']. 
terms -> term terms : ['$1'|'$2']. 

term -> atom        : extract_value('$1').
term -> date        : extract_date('$1').
term -> hexadecimal : extract_hexadecimal('$1').
term -> int         : extract_value('$1').
term -> words       : extract_words_as_atom('$1').

% prefix -> and_   : extract_prefix('$1').
% given_ -> given_.
% then_ -> then_.
% when_ -> when_.

Erlang code.

extract_token({Token, _Line}) -> Token.

extract_value({_Token, _Line, Value}) -> Value.

extract_date({_Token, _Line, Value}) -> apply('Elixir.Date', 'from_iso8601!', [Value]).

extract_hexadecimal({_Token, _Line, <<"0x", Value/binary>>}) -> 
    {N, <<>>} = apply('Elixir.Integer', 'parse', [Value, 16]), N.

extract_words_as_atom([{_T, _L, H}| T]) -> 
    Words = lists:foldl(fun ({_, _, Value}, Acc) -> <<Acc/binary, "_", Value/binary>> end, H, T),
    binary_to_atom(string:lowercase(Words)).