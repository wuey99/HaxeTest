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
		public function createResults ():Void {	
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