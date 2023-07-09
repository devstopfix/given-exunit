Definitions.

GIVEN      = (Given|GIVEN)
WHEN       = (When|WHEN)
THEN       = (Then|THEN)
AND        = (And|AND)

INT        = -?[0-9]+
ATOM       = :[a-z_]+
WHITESPACE = [\s\t\n\r,\.]

D          = [0-9]
DD         = {D}{D}
DDDD       = {D}{D}{D}{D}
TIME       = {DD}:{DD}:{DD}
DATE       = {DDDD}-{DD}-{DD}

Rules.

{AND}         : {token, {and_, TokenLine}}.
{ATOM}        : {token, {atom, TokenLine, to_atom(TokenChars)}}.
{DATE}        : {token, {date, TokenLine, characters_to_binary(TokenChars)}}.
{GIVEN}       : {token, {given, TokenLine}}.
{INT}         : {token, {int,  TokenLine, list_to_integer(TokenChars)}}.
{THEN}        : {token, {then, TokenLine}}.
{WHEN}        : {token, {when_, TokenLine}}.
{WHITESPACE}+ : skip_token.

Erlang code.

to_atom([$:|Chars]) ->
    list_to_atom(Chars).

characters_to_binary(Chars) ->
    unicode:characters_to_binary(Chars).
