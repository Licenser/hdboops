-module(hdboops).

-export([write_100_1MB/0]).


write_1GB() ->
    write(1024, 1024*1024).

write(Times, Size) ->
    {ok, DB} = hanoidb:open("oops.hanoidb", [{page_size, 1024}]),
    io:format("Binary memory usage: ~p MB~n", [c:memory(binary)/1024/1024]),
    io:format("Writing ~p bytes ~p times.~n", [Size, Times]),
    {Time, _} = timer:tc(
                  fun() ->
                          write(DB, Times, Size)
                  end),
    io:format("done in ~ps.~nBinary memory usage: ~p MB~n", [Time, c:memory(binary)/1024/1024]),
    [garbage_collect(P) || P <- processes()],
    io:format("GC.~nBinary memory usage: ~p MB~n", [c:memory(binary)/1024/1024]),
    hanoidb:destroy(DB),
    io:format("Destroy.~nBinary memory usage: ~p MB~n", [c:memory(binary)/1024/1024]),
    hanoidb:close(DB),
    io:format("Close.~nBinary memory usage: ~p MB~n", [c:memory(binary)/1024/1024]).

write(_DB, 1, _Size) ->
    ok;

write(DB, N, Size) ->
    B = << <<X:8>> || X <- lists:seq(1, Size) >>,
    hanoidb:put(DB, term_to_binary(N), B),
    write(DB, N-1, Size).
