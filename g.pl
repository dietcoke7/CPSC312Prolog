% emptyboard(+Board)
% emptyboard/1 is true if the board is empty
emptyboard([#,#,#,#,#,#,#,#,#]).

% printboard(+Board)
% printboard/1 prints the board
printboard([A,B,C,D,E,F,G,H,I]) :-
    print([A,B,C]), nl,
    write([D,E,F]), nl,
    write([G,H,I]), nl.

% other(+Symbol, -OtherSymbol)
% other/2 takes in a symbol and returns the alternate symbol
other(x, o).
other(o, x).

% move(+Position, +Board, +Symbol, -NewBoard)
% move/4 applies Symbol at Position if Position is empty in Board and returns NewBoard
move(1, [A,B,C,D,E,F,G,H,I], Symbol, [Symbol,B,C,D,E,F,G,H,I]) :- A = # , (Symbol = x ; Symbol = o).
move(2, [A,B,C,D,E,F,G,H,I], Symbol, [A,Symbol,C,D,E,F,G,H,I]) :- B = # , (Symbol = x ; Symbol = o).
move(3, [A,B,C,D,E,F,G,H,I], Symbol, [A,B,Symbol,D,E,F,G,H,I]) :- C = # , (Symbol = x ; Symbol = o).
move(4, [A,B,C,D,E,F,G,H,I], Symbol, [A,B,C,Symbol,E,F,G,H,I]) :- D = # , (Symbol = x ; Symbol = o).
move(5, [A,B,C,D,E,F,G,H,I], Symbol, [A,B,C,D,Symbol,F,G,H,I]) :- E = # , (Symbol = x ; Symbol = o).
move(6, [A,B,C,D,E,F,G,H,I], Symbol, [A,B,C,D,E,Symbol,G,H,I]) :- F = # , (Symbol = x ; Symbol = o).
move(7, [A,B,C,D,E,F,G,H,I], Symbol, [A,B,C,D,E,F,Symbol,H,I]) :- G = # , (Symbol = x ; Symbol = o).
move(8, [A,B,C,D,E,F,G,H,I], Symbol, [A,B,C,D,E,F,G,Symbol,I]) :- H = # , (Symbol = x ; Symbol = o).
move(9, [A,B,C,D,E,F,G,H,I], Symbol, [A,B,C,D,E,F,G,H,Symbol]) :- I = # , (Symbol = x ; Symbol = o).

% win(+Symbol, +Board)
% win/2 is true if Symbol has won the game in Board
% Rows check
win(Symbol, [Symbol,Symbol,Symbol, _,_,_,_,_,_]) :- (Symbol = x ; Symbol = o), !.
win(Symbol, [_,_,_,Symbol,Symbol,Symbol,_,_,_]) :- (Symbol = x ; Symbol = o), !.
win(Symbol, [_,_,_,_,_,_,Symbol,Symbol,Symbol]) :- (Symbol = x ; Symbol = o), !.
% Columns check
win(Symbol, [Symbol,_,_,Symbol,_,_,Symbol,_,_]) :- (Symbol = x ; Symbol = o), !.
win(Symbol, [_,Symbol,_,_,Symbol,_,_,Symbol,_]) :- (Symbol = x ; Symbol = o), !.
win(Symbol, [_,_,Symbol,_,_,Symbol,_,_,Symbol]) :- (Symbol = x ; Symbol = o), !.
% Diagonals check
win(Symbol, [Symbol,_,_,_,Symbol,_,_,_,Symbol]) :- (Symbol = x ; Symbol = o), !.
win(Symbol, [_,_,Symbol,_,Symbol,_,Symbol,_,_]) :- (Symbol = x ; Symbol = o), !.

% full(+Board)
% full/1 is true if Board is full
full(Board) :- \+ member(#, Board), !.

% draw(+Board)
% draw/1 is true if Board is a draw
draw(Board) :- \+ win(x, Board), \+ win(o, Board), full(Board), !.

% available_moves(+Board, +Symbol, -Moves)
% available_moves/3 returns a list of all available moves for Symbol in Board
available_moves(Board, Symbol,Moves) :-
    findall(Pos, move(Pos, Board, Symbol, _), Moves).

% random_move(+Board, +Symbol, -Move)
% random_move/3 returns a random move for Symbol in Board
random_move(Board, Symbol, Move) :-
    available_moves(Board, Symbol, Moves),
    random_member(Move, Moves).

% program entry point
start :-
    shell(clear),
    nl, write('Welcome to Tic-Tac-Toe.'),nl,
    write('  1. Play against another human'), nl,
    write('  2. Play against AI'),nl,
    write('  3. Quit'), nl,
    write('Pick a number i.e option, type \'.\' and hit Enter: '),
    read(Option),
    process_option(Option).

% process_option(+Option)
% process_option/1 controls the flow of the game
process_option(1) :-
    nl, write('You chose to play against another human.'), nl,
    emptyboard(NewBoard),  % Create a new board
    play_human(NewBoard, x).

process_option(2) :-
    nl, write('You chose to play against AI.'), nl,
    write('  1. Easy'), nl,
    write('  2. Medium'), nl,
    write('Pick your difficulty (1-2)'),
    read(Difficulty),
    write('Pick your symbol (x or o). x always goes first'),
    read(Symbol),
    other(Symbol,OtherSymbol),
    write('AI is '), write(OtherSymbol), nl, sleep(1),
    emptyboard(NewBoard),  % Create a new board
    (Symbol = x -> play_ai(NewBoard, Difficulty, x, o) ; play_ai(NewBoard, Difficulty, x, x)).

process_option(3) :-
    nl, write('Quitting the game. Thanks for your time!'), nl.

% play_human(+Board, +CurrentSymbol)
% play_human/2 is the main loop for the human player
play_human(Board, CurrentSymbol) :-
    nl,printboard(Board),

    write('Player '), write(CurrentSymbol), write(' enter your move (1-9)'),
    read(Pos),
    move(Pos, Board, CurrentSymbol, NewBoard),

    (win(CurrentSymbol, NewBoard) ->
        nl, write(CurrentSymbol), write(' wins!'), printboard(NewBoard), nl, sleep(1), start
    ;draw(NewBoard) ->
        nl, write('It\'s a draw!'), nl, printboard(NewBoard), nl, sleep(1), start
    ;other(CurrentSymbol, OtherSymbol),
    write('Next player\'s turn...'), nl,
    play_human(NewBoard, OtherSymbol)
    ).

% play_ai(+Board, +Difficulty, +CurrentSymbol, +AISymbol)
% play_ai/4 is the main loop for the AI player
play_ai(Board, 1, CurrentSymbol, AISymbol) :-
    (   CurrentSymbol = AISymbol ->
        random_move(Board, AISymbol, Pos),
        move(Pos, Board, AISymbol, NewBoard),
        write('AI played '), write(AISymbol), write(' at '), write(Pos), nl,
        (   win(CurrentSymbol, NewBoard) ->
            nl, write('AI wins!'), nl, printboard(NewBoard), nl, sleep(4), start
        ;   draw(NewBoard) ->
            nl, write('It\'s a draw!'), printboard(NewBoard), nl, sleep(4), start
        ;   other(CurrentSymbol, OtherSymbol),
            play_ai(NewBoard, 1, OtherSymbol, AISymbol)
        )
    ;   CurrentSymbol \= AISymbol ->
        nl, printboard(Board),
        write('Enter your move (1-9)'),
        read(Pos),
        move(Pos, Board, CurrentSymbol, NewBoard),
        (   win(CurrentSymbol, NewBoard) ->
            nl, write('You win!'), nl, printboard(NewBoard), nl, sleep(4), start
        ;   draw(NewBoard) ->
            nl, write('It\'s a draw!'), nl, printboard(NewBoard), nl, sleep(4), start
        ;   other(CurrentSymbol, OtherSymbol),
            play_ai(NewBoard, 1, OtherSymbol, AISymbol)
        )
    ).

play_ai(Board, 2, CurrentSymbol, AISymbol) :-
    (   CurrentSymbol = AISymbol ->
        write('AI is thinking...'), nl,
        minimax_move(Board, AISymbol, Pos),
        move(Pos, Board, AISymbol, NewBoard),
        write('AI played '), write(AISymbol), write(' at '), write(Pos), nl,
        (   win(CurrentSymbol, NewBoard) ->
            nl, write('AI wins!'), nl, printboard(NewBoard), nl, sleep(4), start
        ;   draw(NewBoard) ->
            nl, write('It\'s a draw!'), printboard(NewBoard), nl, sleep(4), start
        ;   other(CurrentSymbol, OtherSymbol),
            play_ai(NewBoard, 2, OtherSymbol, AISymbol)
        )
    ;   CurrentSymbol \= AISymbol ->
        nl, printboard(Board),
        write('Enter your move (1-9)'),
        read(Pos),
        move(Pos, Board, CurrentSymbol, NewBoard),
        (   win(CurrentSymbol, NewBoard) ->
            nl, write('You win!'), nl, printboard(NewBoard), nl, sleep(4), start
        ;   draw(NewBoard) ->
            nl, write('It\'s a draw!'), nl, printboard(NewBoard), nl, sleep(4), start
        ;   other(CurrentSymbol, OtherSymbol),
            play_ai(NewBoard, 2, OtherSymbol, AISymbol)
        )
    ).

% minimax_move(+Board, +Symbol, -BestMove)
% minimax_move/3 is the main function to find the best move for the AI player.
% Note that this function doesn't give optimal result :(
minimax_move(Board, Symbol, BestMove) :-
    Depth = 8, % Adjust depth based on performance requirements
    findall((Value,Move), (
        available_moves(Board, Symbol, Moves),
        member(Move, Moves),
        move(Move, Board, Symbol, NewBoard),
        minimax(NewBoard, Depth, false, Symbol, Value)
    ), Values),
    max_member((_,BestMove), Values).

% minimax(+Board, +Depth, +MaxPlayer, +Symbol, -Value)
% minimax/5 is the minimax algorithm.
minimax(Board, 0, _, Symbol, Value) :-
    heuristic(Board, Symbol, Value).

minimax(Board, Depth, MaxPlayer, Symbol, Value) :-
    Depth > 0,
    Depth1 is Depth - 1,
    (MaxPlayer ->
        InitialValue = -9999
    ;
        InitialValue = 9999
    ),
    findall(ChildValue, (
        available_moves(Board, Symbol, Moves),
        member(Move, Moves),
        move(Move, Board, Symbol, NewBoard),
        other(Symbol, OtherSymbol),
        minimax(NewBoard, Depth1, \+MaxPlayer, OtherSymbol, ChildValue)
    ), Values),
    (MaxPlayer ->
        max_list([InitialValue | Values], Value)
    ;
        min_list([InitialValue | Values], Value)
    ).

% heuristic(+Board, +Symbol, -Value)
% heuristic/3 is the heuristic function to evaluate the board state.
heuristic(Board, Symbol, Value) :-
    WinBonus = 100,
    DrawBonus = 50,
    OpponentThreatPenalty = 1000,
    
    (win(Symbol, Board) ->
        Value is WinBonus
    ;
        (draw(Board) ->
            Value is DrawBonus
        ;
            count_winning_lines(Board, Symbol, WinningLines),
            count_winning_lines(Board, other(Symbol), OpponentWinningLines),
            OpponentThreatValue is OpponentThreatPenalty * OpponentWinningLines,
            Value is  WinBonus * WinningLines - OpponentThreatValue
        )
    ).

% count_winning_lines(+Board, +Symbol, -WinningLines)
% count_winning_lines/3 counts the number of winning lines for Symbol in Board
count_winning_lines(Board, Symbol, WinningLines) :-
    findall(Line, (win(Symbol, Line), sublist(Line, Board)), Lines),
    length(Lines, WinningLines).

count_winning_lines(_, _, 0).

% sublist(+L1, +L2)
% sublist/2 is true if L1 is a sublist of L2
sublist(L1, L2) :-
    append(_, L3, L2),
    append(L1, _, L3).