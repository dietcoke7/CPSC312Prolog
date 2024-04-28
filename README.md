# Tic-Tac-Toe and Minimax AI

## Running the project

To run the project:
1. Open the terminal in the directory where the project is stored. Then simply type `swipl` in the terminal.
2. Load g.pl in the terminal by typing `[g].` in the terminal.
3. Type `start.` in the terminal to run the program

## Documentation

- A board has 9 spots.
- A player is either `x` or `o`.
- An empty spot is represented by `#`.
- A game is finished if there is no empty spot or if one player has won.
- A player wins if they have three of their symbols in a row or column or diagonal.

### Board and Move

I have chosen to use lists to represent the board. I had initial used 3 x 3 arrays however, a 9 array was much more easy to implement. This is because of Prolog's extensive pattern matching capabilities.

Each spot on the board is assigned a number from 1 to 9. So a board `[x, o, #, #, o, x, #, #, #]` would look like:

```
x o #
# o x
# # #
```

Each move basically changes the value of the spot to the player's symbol. You can only apply the move if the spot is empty.

### Minimax AI

The minimax algorithm is used to find the move if it is the computer's turn. The algorithm is explained in the [Wikipedia](https://en.wikipedia.org/wiki/Minimax) article. I have also implemented a heuristic that prioritizes moves that will result in a win.

### IO Functions

The rest facts and rules are used to implement the IO functionalities. The program uses the terminal to allow the user to play the games. When `start.` is typed, it clears the terminal and displays a memu. The user can then chose to play against a human or against the AI.

## References
[Minimax](https://en.wikipedia.org/wiki/Minimax) 

[Check out the repo of other project where I implemented a Rubik's Cube in Haskell](https://github.com/dietcoke7/CPSC312Haskell.git)

[Wiki#1](https://wiki.ubc.ca/Course:CPSC312-2024W2/TicTacToeandMinimaxAI)
[Wiki#2](https://wiki.ubc.ca/Course:CPSC312-2024)
