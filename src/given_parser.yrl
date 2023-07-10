Nonterminals 
and_given_clauses and_given 
and_then_clauses and_then 
and_when_clauses and_when 
given_clauses given_clause 
scenario 
terms term 
then_clauses then_clause 
when_clauses when_clause 
words.
Terminals 
and_ 
atom 
date 
given_ 
hexadecimal 
int 
string 
then_ 
when_ 
word.
Rootsymbol scenario.

% Scenario is a list of clauses
scenario -> given_clauses when_clauses then_clauses : '$1' ++ '$2' ++ '$3'.

% Given
given_clauses -> given_clause : ['$1'].
given_clauses -> given_clause and_given_clauses : ['$1'|'$2'].
given_clause -> given_ terms : {given_, list_to_tuple('$2')}.

% Given And
and_given_clauses -> and_given : ['$1'].
and_given_clauses -> and_given and_given_clauses: ['$1'].
and_given -> and_ terms : {given_, list_to_tuple('$2')}.

% When
when_clauses -> when_clause : ['$1'].
when_clauses -> when_clause and_when_clauses : ['$1'|'$2'].
when_clauses -> '$empty' : [].
when_clause -> when_ terms : {when_, list_to_tuple('$2')}.

% When And
and_when_clauses -> and_when : ['$1'].
and_when_clauses -> and_when and_when_clauses: ['$1'].
and_when -> and_ terms : {when_, list_to_tuple('$2')}.

% Then
then_clauses -> then_clause : ['$1'].
then_clauses -> then_clause and_then_clauses : ['$1'|'$2'].
then_clauses -> '$empty' : [].
then_clause -> then_ terms : {then_, list_to_tuple('$2')}.

% Then And
and_then_clauses -> and_then : ['$1'].
and_then_clauses -> and_then and_then_clauses: ['$1'].
and_then -> and_ terms : {then_, list_to_tuple('$2')}.


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
term -> string      : extract_value('$1').
term -> words       : extract_words_as_atom('$1').


Erlang code.

extract_value({_Token, _Line, Value}) -> Value.

extract_date({_Token, _Line, Value}) -> apply('Elixir.Date', 'from_iso8601!', [Value]).

extract_hexadecimal({_Token, _Line, <<"0x", Value/binary>>}) -> 
    {N, <<>>} = apply('Elixir.Integer', 'parse', [Value, 16]), N.

extract_words_as_atom([{_T, _L, H}| T]) -> 
    Words = lists:foldl(fun ({_, _, Value}, Acc) -> <<Acc/binary, "_", Value/binary>> end, H, T),
    binary_to_atom(string:lowercase(Words)).