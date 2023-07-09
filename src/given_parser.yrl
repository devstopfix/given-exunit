Nonterminals sentence clause prefix terms term.
Terminals and_ date given int then when_.
Rootsymbol sentence.

sentence -> clause : ['$1'].
sentence -> clause sentence : ['$1'|'$2'].

clause -> prefix terms : ['$1', '$2'].

terms -> term : ['$1']. 
terms -> term terms : ['$1'|'$2']. 

term -> date     : extract_date('$1').
term -> int      : extract_token('$1').

prefix -> and_   : extract_prefix('$1').
prefix -> given  : extract_prefix('$1').
prefix -> then   : extract_prefix('$1').
prefix -> when_  : extract_prefix('$1').

Erlang code.

extract_prefix({Token, _Line}) -> Token.

extract_token({_Token, _Line, Value}) -> Value.

extract_date({_Token, _Line, Value}) -> apply('Elixir.Date', 'from_iso8601!', [Value]).
