//------------------------------------------------------------------------------------------
package states;
		
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.type.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xml.*;
	import kx.text.*;
	
	import gx.game.*;
	
	import openfl.filters.*;
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	import openfl.events.*;
	import openfl.ui.*;
	import openfl.Assets;
	
	import ui.XTextButton;
	import objects.*;
	import objects.Card.CardSuit;
	
	//------------------------------------------------------------------------------------------
	class Table extends Gamestate {
		
		public var m_sprite:XMovieClip;
		public var x_sprite:XDepthSprite;
		
		public var m_replayButton:XTextButton;
		public var m_endGameButton:XTextButton;
		
		public var COMPUTER_Y:Float = 50;
		public var HUMAN_Y:Float = G.SCREEN_HEIGHT - 100;
		
		public var m_computerCards:Array<Card>;
		public var m_humanCards:Array<Card>;
		
		public var m_computerScore:XTextLogicObject;
		public var m_humanScore:XTextLogicObject;
		
		public var m_humanScoreCount:Int;
		public var m_computerScoreCount:Int;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic>):Void {
			super.setup (__xxx, args);
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
			
			createObjects ();
			
			m_computerCards = [];
			m_humanCards = [];
			
			m_computerScoreCount = 0;
			m_humanScoreCount = 0;
			
			Deal_Script ();
			
			m_replayButton.addMouseUpListener (function ():Void {
				gotoState ("Table");
			});
			
			m_endGameButton.addMouseUpListener (function ():Void {
				gotoState ("Results");
			});
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
		}

		//------------------------------------------------------------------------------------------
		public function createObjects ():Void {
			createButtons ();
			createScores ();
		}
		
		//------------------------------------------------------------------------------------------
		public function createButtons ():Void {
			var BOX_WIDTH:Float = 150;
			
			//------------------------------------------------------------------------------------------
			m_replayButton = cast xxx.getXLogicManager ().initXLogicObject (
				// parent
					self,
				// logicObject
					new XTextButton () /* as XLogicObject */,
				// item, layer, depth
					null, 0, 20000,
				// x, y, z
					0, 0, 0,
				// scale, rotation
					1.0, 0,
					[
						"Replay",
						Assets.getFont("fonts/Berlin Sans FB Bold.ttf").fontName,
						25,
						175,
						80
					]
				) /* as XTextButton */;
				
			addXLogicObject (m_replayButton);
			
			m_replayButton.oX = G.SCREEN_WIDTH - BOX_WIDTH + (BOX_WIDTH - m_replayButton.text.width) / 2;
			m_replayButton.oY = G.SCREEN_HEIGHT - 128;
			
			//------------------------------------------------------------------------------------------
			m_endGameButton = cast xxx.getXLogicManager ().initXLogicObject (
				// parent
					self,
				// logicObject
					new XTextButton () /* as XLogicObject */,
				// item, layer, depth
					null, 0, 20000,
				// x, y, z
					0, 0, 0,
				// scale, rotation
					1.0, 0,
					[
						"End Game",
						Assets.getFont("fonts/Berlin Sans FB Bold.ttf").fontName,
						25,
						175,
						80
					]
				) /* as XTextButton */;
				
			addXLogicObject (m_endGameButton);
			
			m_endGameButton.oX = G.SCREEN_WIDTH - BOX_WIDTH + (BOX_WIDTH - m_endGameButton.text.width) / 2;
			m_endGameButton.oY = G.SCREEN_HEIGHT - 80;
		}

		//------------------------------------------------------------------------------------------
		public function createScores ():Void {
			m_computerScore = cast getXLogicManager ().initXLogicObject (
				// parent
				self,
				// logicObject
				cast new XTextLogicObject (),
				// item, layer, depth
				null, getLayer (), getDepth () + 1,
				// x, y, z
				0, 0, 0,
				// scale, rotation
				1.0, 0
			);
			
			m_computerScore.setupText (
				// width
				300,
				// height
				40,
				// text
				"ROBOT LEAGUE: 0",
				// font name
				 Assets.getFont("fonts/Berlin Sans FB Bold.ttf").fontName,
				// font size
				20,
				// color
				0xe0e0e0,
				// bold
				true
			);
			
			addXLogicObject (m_computerScore);
			
			m_computerScore.autoCalcWidth ();
			m_computerScore.autoCalcHeight ();
			
			m_computerScore.oX = 16;
			m_computerScore.oY = 96;
			
			m_humanScore = cast getXLogicManager ().initXLogicObject (
				// parent
				self,
				// logicObject
				cast new XTextLogicObject (),
				// item, layer, depth
				null, getLayer (), getDepth () + 1,
				// x, y, z
				0, 0, 0,
				// scale, rotation
				1.0, 0
			);
			
			m_humanScore.setupText (
				// width
				300,
				// height
				40,
				// text
				"HUMAN LEAGUE: 0",
				// font name
				 Assets.getFont("fonts/Berlin Sans FB Bold.ttf").fontName,
				// font size
				20,
				// color
				0xe0e0e0,
				// bold
				true
			);
			
			addXLogicObject (m_humanScore);
			
			m_humanScore.autoCalcWidth ();
			m_humanScore.autoCalcHeight ();
			
			m_humanScore.oX = 16;
			m_humanScore.oY = G.SCREEN_HEIGHT - 176;
		}

		//------------------------------------------------------------------------------------------
		public function incrementHumanScore ():Void {
			m_humanScoreCount++;
			
			m_humanScore.text.text = "HUMAN LEAGUE: " + m_humanScoreCount;
			
			m_humanScore.autoCalcWidth ();
			m_humanScore.autoCalcHeight ();
		}
		
		//------------------------------------------------------------------------------------------
		public function incrementComputerScore ():Void {
			m_computerScoreCount++;
			
			m_computerScore.text.text = "ROBOT LEAGUE: " + m_computerScoreCount;
			
			m_computerScore.autoCalcWidth ();
			m_computerScore.autoCalcHeight ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
			m_sprite = createXMovieClip ("Table:Table");
			x_sprite = addSpriteAt (m_sprite, m_sprite.dx, m_sprite.dy);
			
			show ();
		}

		//------------------------------------------------------------------------------------------
		public function getRandomRedSuit ():CardSuit {
			if (Math.random () > 0.50) {
				return CardSuit.DIAMONDS;
			} else {
				return CardSuit.HEARTS;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function getRandomBlackSuit ():CardSuit {
			if (Math.random () > 0.50) {
				return CardSuit.SPADES;
			} else {
				return CardSuit.CLUBS;
			}			
		}
		
		//------------------------------------------------------------------------------------------
		public function Idle_Script ():Void {
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
						
							function ():Void {
							},
						
						XTask.GOTO, "loop",
						
						XTask.RETN,
					]);
					
				},
				
				//------------------------------------------------------------------------------------------
				// animation
				//------------------------------------------------------------------------------------------	
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		// script to deal the human and computer cards
		// wait for mouse press for each human card
		//------------------------------------------------------------------------------------------
		public function Deal_Script ():Void {

			var __cardIndex:Int = 1;
			var __x:Float = 24;
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					script.addTask ([
						XTask.LOOP, 13,
							function ():Void {
								m_computerCards.push (createCard (__cardIndex, getRandomBlackSuit (), __x, COMPUTER_Y));
							},
						
							XTask.WAIT, 0x0800,
							
							function ():Void {
								m_humanCards.push (createCard (__cardIndex, getRandomRedSuit (), __x, HUMAN_Y));
							},
							
							XTask.WAIT, 0x0800,
							
							function ():Void {
								__cardIndex++;
								
								__x += 56;
							},
							
						XTask.NEXT,
						
						XTask.WAIT, 0.50 * 1000,
						
						function ():Void {
							__cardIndex = 0;
						},
						
						XTask.LOOP, 13,
							XTask.WAIT, 0x1000,
							
							function ():Void {
								m_humanCards[__cardIndex].Flip_Script ();
								
								__cardIndex++;
							},
							
						XTask.NEXT,

						function ():Void {
							for (i in 0...m_humanCards.length) {
								m_humanCards[i].enableMouse ();
								
								m_humanCards[i].addPressedListener (function ():Void {
									doCardInteraction (i);
								});
							}
						},
						
						function ():Void {
							Idle_Script ();
						},
						
						XTask.RETN,
					]);
					
				},
				
				//------------------------------------------------------------------------------------------
				// animation
				//------------------------------------------------------------------------------------------	
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		// scripted event for handling card interaction
		//
		// 1) flip the human card to show back side
		// 2) move that card to the center
		// 3) move the randomly chosen computer card to tne center
		// 4) flip human and computer card to show front side
		// 5) determine who wins
		//------------------------------------------------------------------------------------------
		public function doCardInteraction (__cardIndex:Int):Void {
			var __humanCard:Card = m_humanCards[__cardIndex];
			var __computerCard:Card = findRandomComputerCard ();
			
			for (i in 0...m_humanCards.length) {
				m_humanCards[i].enableMouse (false);
			}
			
			addTask ([
				function ():Void {
					__humanCard.Flip_Script ();
				},
				
				XTask.WAIT, 0x2000,
				
				function ():Void {
					__humanCard.Toss_Script (G.SCREEN_WIDTH * 0.40, G.SCREEN_HEIGHT / 2 - 25 + 50, 20, 0.0);
				},
				
				XTask.WAIT, 0x2000,
				
				function ():Void {
					__computerCard.Toss_Script (G.SCREEN_WIDTH * 0.40, G.SCREEN_HEIGHT / 2 - 25 - 50, 20, 0.0);
				},
				
				XTask.WAIT, 0x2000,
				
				function ():Void {
					__humanCard.Flip_Script ();
					__computerCard.Flip_Script ();
				},
				
				XTask.WAIT1000, 1 * 1000,
				
				function ():Void {
					if (__humanCard.getActualValue () == __computerCard.getActualValue ()) {
						__humanCard.FadeAndNuke_Script ();
						__computerCard.FadeAndNuke_Script ();
					}
					
					if (__humanCard.getActualValue () < __computerCard.getActualValue ()) {
						__humanCard.TossAndNuke_Script (0, 0, 20);
						__computerCard.TossAndNuke_Script (0, 0, 20);
					
						incrementComputerScore ();
					}
					
					if (__humanCard.getActualValue () > __computerCard.getActualValue ()) {
						__humanCard.TossAndNuke_Script (0, G.SCREEN_HEIGHT, 20);
						__computerCard.TossAndNuke_Script (0, G.SCREEN_HEIGHT, 20);
						
						incrementHumanScore ();
					}
				},
				
				XTask.WAIT, 0.50 * 1000,
				
				function ():Void {
					for (i in 0...m_humanCards.length) {
						m_humanCards[i].enableMouse (true);
					}
				},
				
				XTask.FLAGS, function (__task:XTask):Void {
					__task.ifTrue (computerHasCards ());
				}, XTask.BEQ, "cont",
				
				XTask.WAIT1000, 2 * 1000,
				
				function ():Void {
					gotoState ("Results", [m_humanScoreCount, m_computerScoreCount]);
				},
				
				XTask.LABEL, "cont",
					XTask.RETN,
			]);
		}

		//------------------------------------------------------------------------------------------
		public function computerHasCards ():Bool {
			var __hasCards:Bool = false;
			
			for (i in 0...m_computerCards.length) {
				if (m_computerCards[i] != null) {
					__hasCards = true;
				}
			}
			
			return __hasCards;
		}
		
		//------------------------------------------------------------------------------------------
		public function findRandomComputerCard ():Card {
			var __card:Card = null;
			var __hasCards:Bool = computerHasCards ();
				
			if (__hasCards) {
				var __index:Int = 0;
			
				while (__card == null) {
					__index = Std.random (m_computerCards.length);
					
					__card = m_computerCards[__index];
				}
				
				m_computerCards[__index] = null;
			}
			
			return __card;
		}
		
		//------------------------------------------------------------------------------------------
		public function createCard (__value:Int, __suit:CardSuit, __x:Float, __y:Float):Card {
			var __logicObject:Card = cast xxx.getXLogicManager ().initXLogicObjectFromPool (
				// parent
				self,
				// class
				Card,
				// item, layer, depth
				null, getLayer (), getDepth () + 1,
				// x, y, z
				-100, G.SCREEN_HEIGHT / 2, 0,
				// scale, rotation
				1.0, 0,
				[
					__value, __suit
				]
			);
			
			addXLogicObject (__logicObject);
			
			__logicObject.Toss_Script (__x, __y, 40);
			
			return __logicObject;
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }