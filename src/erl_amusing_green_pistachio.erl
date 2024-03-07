-module(erl_amusing_green_pistachio).

%% API exports
-export([snack_name/1]).

-include("src/erl_amusing_green_pistachio.hrl").

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

%%====================================================================
%% API functions
%%====================================================================
snack_name(String) ->
    [AdjectiveIndex, ColorIndex, SnackIndex] = hex_digest(String),
    {ok,
        lists:nth(AdjectiveIndex + 1, ?ADJECTIVES) ++ "-" ++
            lists:nth(ColorIndex + 1, ?COLORS) ++ "-" ++
            lists:nth(SnackIndex + 1, ?SNACKS)}.

%%====================================================================
%% Internal functions
%%====================================================================
hex_digest(Input) ->
    Digest = erlang:md5(Input),
    compress(byte_size(Digest) div 3, Digest, []).

compress(Size, Bin, Acc) ->
    case Bin of
        <<Segment:Size/binary, Tail/binary>> when byte_size(Tail) >= Size ->
            Res = lists:foldl(fun(B, A) -> B bxor A end, 0, binary_to_list(Segment)),
            compress(Size, Tail, [Res | Acc]);
        Segment ->
            Res = lists:foldl(fun(B, A) -> B bxor A end, 0, binary_to_list(Segment)),
            lists:reverse([Res | Acc])
    end.
%% ------------------------------------------------------------------
%% EUNIT Tests
%% ------------------------------------------------------------------
-ifdef(TEST).

basic_test() ->
    Known = "112CuoXo7WCcp6GGwDNBo6H5nKXGH45UNJ39iEefdv2mwmnwdFt8",
    ?assertEqual({ok, "feisty-glass-dalmatian"}, snack_name(Known)).

-endif.
