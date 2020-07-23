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
	class Title extends Gamestate {
		
		public var m_sprite:XMovieClip;
		public var x_sprite:XDepthSprite;
		
		public var m_titleText:XTextLogicObject;
		public var m_startButton:XTextButton;
		
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
			
			m_startButton.addMouseUpListener (function ():Void {
				gotoState ("Table");
			});
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
		}

		//------------------------------------------------------------------------------------------
		public function createObjects ():Void {
			m_titleText = cast getXLogicManager ().initXLogicObject (
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
			
			m_titleText.setupText (
				// width
				700,
				// height
				40,
				// text
				"Humans vs. Robots!",
				// font name
				 Assets.getFont("fonts/Berlin Sans FB Bold.ttf").fontName,
				// font size
				40,
				// color
				0xe0e0e0,
				// bold
				true
			);
			
			addXLogicObject (m_titleText);
			
			m_titleText.autoCalcWidth ();
			m_titleText.autoCalcHeight ();
			
			m_titleText.oX = (G.SCREEN_WIDTH - m_titleText.text.width) / 2;
			m_titleText.oY = 96;
			
			//------------------------------------------------------------------------------------------
			m_startButton = cast xxx.getXLogicManager ().initXLogicObject (
				// parent
					self,
				// logicObject
					new XTextButton () /* as XLogicObject */,
				// item, layer, depth
					null, 0, 20000,
				// x, y, z
					G.SCREEN_WIDTH / 2, G.SCREEN_HEIGHT * 0.66, 0,
				// scale, rotation
					1.0, 0,
					[
						"Start",
						Assets.getFont("fonts/Berlin Sans FB Bold.ttf").fontName,
						30,
						175,
						80
					]
				) /* as XTextButton */;
				
			addXLogicObject (m_startButton);
			
			m_startButton.oX = (G.SCREEN_WIDTH - m_startButton.text.width) / 2;
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