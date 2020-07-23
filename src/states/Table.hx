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