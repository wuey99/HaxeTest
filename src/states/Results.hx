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
	
	//------------------------------------------------------------------------------------------
	class Results extends Gamestate {
		
		public var m_sprite:XMovieClip;
		public var x_sprite:XDepthSprite;
		
		public var m_resultsText:XTextLogicObject;
		public var m_playButton:XTextButton;
		public var m_endGameButton:XTextButton;
		
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
			
			m_humanScoreCount = getArg (args, 0);
			m_computerScoreCount = getArg (args, 1);
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
			
			createObjects ();
			
			m_playButton.addMouseUpListener (function ():Void {
				gotoState ("Table");
			});
			
			m_endGameButton.addMouseUpListener (function ():Void {
				gotoState ("Title");
			});
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
		}

		//------------------------------------------------------------------------------------------
		public function createObjects ():Void {
			createTitle ();
			createButtons ();
			createScores ();
			createResults ();
		}
		
		//------------------------------------------------------------------------------------------
		public function createTitle ():Void {
			m_resultsText = cast getXLogicManager ().initXLogicObject (
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
			
			m_resultsText.setupText (
				// width
				700,
				// height
				40,
				// text
				"Results",
				// font name
				 Assets.getFont("fonts/Berlin Sans FB Bold.ttf").fontName,
				// font size
				40,
				// color
				0xe0e0e0,
				// bold
				true
			);
			
			addXLogicObject (m_resultsText);
			
			m_resultsText.autoCalcWidth ();
			m_resultsText.autoCalcHeight ();
			
			m_resultsText.oX = (G.SCREEN_WIDTH - m_resultsText.text.width) / 2;
			m_resultsText.oY = 96;
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
				"ROBOT LEAGUE: " + m_computerScoreCount,
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
			
			m_computerScore.oX = (G.SCREEN_WIDTH - m_computerScore.text.width) / 2;
			m_computerScore.oY = G.SCREEN_HEIGHT / 2 - 50 - 25;
			
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
				"HUMAN LEAGUE: " + m_humanScoreCount,
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
			
			m_humanScore.oX = (G.SCREEN_WIDTH - m_humanScore.text.width) / 2;
			m_humanScore.oY = G.SCREEN_HEIGHT / 2 - 50 + 25;
		}
		
		//------------------------------------------------------------------------------------------
		public function createResults ():Void {
			var __resultMessage:String = "";
			
			if (m_humanScoreCount == m_computerScoreCount) {
				__resultMessage = "IT'S A TIE!";
			}
			
			if (m_humanScoreCount > m_computerScoreCount) {
				__resultMessage = "THE HUMANS WIN!  ROBOTS WILL BE SCRAPPED FOR METAL!";
			}
			
			if (m_humanScoreCount < m_computerScoreCount) {
				__resultMessage = "THE ROBOTS WIN!  HUMANS WILL BE FOREVER SLAVES!";
			}
			
			m_resultsText = cast getXLogicManager ().initXLogicObject (
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
			
			m_resultsText.setupText (
				// width
				700,
				// height
				100,
				// text
				__resultMessage,
				// font name
				 Assets.getFont("fonts/Berlin Sans FB Bold.ttf").fontName,
				// font size
				25,
				// color
				0xe0e0e0,
				// bold
				true
			);
			
			addXLogicObject (m_resultsText);
			
			m_resultsText.autoCalcWidth ();
			m_resultsText.autoCalcHeight ();
			
			m_resultsText.oX = (G.SCREEN_WIDTH - m_resultsText.text.width) / 2;
			m_resultsText.oY = G.SCREEN_HEIGHT / 2 + 64;
		}
		
		//------------------------------------------------------------------------------------------
		public function createButtons ():Void {
			
			//------------------------------------------------------------------------------------------				
			var BOX_WIDTH:Float = 150;
			
			//------------------------------------------------------------------------------------------
			// buttons
			//------------------------------------------------------------------------------------------
			m_playButton = cast xxx.getXLogicManager ().initXLogicObject (
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
						"Play Again",
						Assets.getFont("fonts/Berlin Sans FB Bold.ttf").fontName,
						25,
						175,
						80
					]
				) /* as XTextButton */;
				
			addXLogicObject (m_playButton);
			
			m_playButton.oX = G.SCREEN_WIDTH - BOX_WIDTH + (BOX_WIDTH - m_playButton.text.width) / 2;
			m_playButton.oY = G.SCREEN_HEIGHT - 128;
			
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
						"End",
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
	}
	
//------------------------------------------------------------------------------------------
// }