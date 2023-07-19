Definitions.

GIVEN      = (Given|GIVEN)
WHEN       = (When|WHEN)
THEN       = (Then|THEN)
AND        = (And|AND)

ATOM        = :[a-zA-Z_]+
HEXADECIMAL = 0x[0-9a-fA-F]+
FLOAT       = -?[0-9]+[\.][0-9]+
INT         = -?[0-9]+
POS         = [0-9]+
STRING      = "([^"]*)"
%"
WHITESPACE  = [\s\t\n\r,\.]
WORD        = [a-zA-Z]+

D          = [0-9]
DD         = {D}{D}2
DDDD       = {D}{D}{D}{D}
TIME       = {DD}:{DD}:{DD}
DATE       = {DDDD}-{DD}-{DD}

Rules.

{AND}             : {token, {and_, TokenLine}}.
{ATOM}            : {token, {atom, TokenLine, to_atom(TokenChars)}}.
{DATE}            : {token, {date, TokenLine, characters_to_binary(TokenChars)}}.
{TIME}            : {token, {time, TokenLine, characters_to_binary(TokenChars)}}.
{GIVEN}           : {token, {given_, TokenLine}}.
{HEXADECIMAL}     : {token, {hexadecimal, TokenLine, characters_to_binary(TokenChars)}}.
{THEN}            : {token, {then_, TokenLine}}.
{WHEN}            : {token, {when_, TokenLine}}.
{WORD}            : {token, {word, TokenLine, characters_to_binary(TokenChars)}}.
{STRING}          : {token, {string, TokenLine, quoted_characters_to_binary(TokenChars)}}.
{FLOAT}           : {token, {float, TokenLine, list_to_float(TokenChars)}}.
{POS}-{POS}       : {token, {range, TokenLine, to_range(TokenChars)}}.
{INT}             : {token, {int,  TokenLine, list_to_integer(TokenChars)}}.
{WHITESPACE}+     : skip_token.

Erlang code.

to_atom([$:|Chars]) ->
    list_to_atom(Chars).

characters_to_binary(Chars) ->
    unicode:characters_to_binary(Chars).

to_range(Chars) ->
    [A, B] = string:tokens(Chars, "-"),
    apply('Elixir.Range', 'new', [list_to_integer(A), list_to_integer(B)]).

quoted_characters_to_binary(Chars) ->
    unicode:characters_to_binary(string:strip(Chars, both, $")).