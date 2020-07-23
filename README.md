# HaxeTest

This demo uses an external project which can be found at:

https://github.com/wuey99/kx

which I use for the game's engine.

the engine does a lot of the heavy lifting and there is a fairly unorthodox scripting system.  if you have any questions, let me know.

the demo should work with touch screens, but I don't have a phone or tablet handy to test.  let me know if there are problems.

The main entry point of the demo is located at 

Game.hx

There are 3 main game states located at:

states/Title.hx

The title screen.  shows a simple title and a text-based start button

states/Table.hx

The main game state.  It creates the buttons for "replay" and "end game"
deals the cards.  listens for mouse presses from the buttons.  when a mouse press event is received, it handles the card interaction:

		// 1) flip the human card to show back side
		// 2) move that card to the center
		// 3) move the randomly chosen computer card to tne center
		// 4) flip human and computer card to show front side
		// 5) determine who wins
		// 6) discard the cards.  if it's a tie, the cards fade away.  if either the computer or human wins the cards are moved to their corner.
		// 7) increment the score counts.  
		// 8) if there are no more cards, go to the "Results" screen.

states/Results.hx

shows the final scores and tells the player if there is a tie or who wins.

player can press a button to replay or go back to the title screen

objects/Card.hx

represents a game card.  checks for mouse (or touch events) and emits a signal if there is a mouse click.  also handles various animations (flipping the card, move to a location, fade away etc)


