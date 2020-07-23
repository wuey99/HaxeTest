//------------------------------------------------------------------------------------------
package;
//	import assets.*;
	
	import openfl.display.*;
	import openfl.events.*;
	import openfl.geom.*;
	import openfl.media.*;
	import openfl.system.*;
	import openfl.ui.*;
	import openfl.utils.*;
	
	import gx.*;
	import gx.game.*;
	import gx.levels.*;
	import gx.messages.*;
	import gx.messages.level.*;
	import gx.mickey.*;
	import gx.zone.*;
	
	import kx.*;
	import kx.bitmap.*;
	import kx.collections.*;
	import kx.game.*;
	import kx.geom.*;
	import kx.keyboard.*;
	import kx.resource.*;
	import kx.signals.*;
	import kx.sound.*;
	import kx.task.*;
	import kx.type.*;
	import kx.world.*;
	import kx.world.logic.*;
	import kx.xmap.*;
	import kx.xml.*;
	
	import nx.touch.*;
	import nx.task.*;
	
	import levels.*;
	import zone.*;
	
	import states.*;
	
//------------------------------------------------------------------------------------------
	class Game extends GApp {
		private var m_touchManager:XTouchManager;	
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (
			__assetsClass:Class<Dynamic> /* <Dynamic> */,
			__mickeyXClass:Class<Dynamic> /* <Dynamic> */,
			__parent:Dynamic /* */,
			__timerInterval:Float=16, 
			__layers:Int=4
		):Void {	
			trace (": Game: setup: ");
			
			super.setup (__assetsClass, __mickeyXClass, __parent, __timerInterval, __layers);
			
			G.setup (cast this /* as Game */, m_XApp);
			
			registerState ("Title", Title);
			registerState ("Table", Table);
			registerState ("Results", Results);
			
			addTask ([
				XTask.WAIT1000, 0.50 * 1000,
					
				function ():Void {
					m_touchManager = new XTouchManager ();
					m_touchManager.setup (m_XApp, xxx);
					
					cacheAllMovieClips ();
				},
				
				XTask.WAIT1000, 0.50 * 1000,
				
				function ():Void {
					gotoState ("Title");
				},
				
				XTask.RETN,
			]);	
		}
		
//------------------------------------------------------------------------------------------
		public override function createXWorld (__parent:Dynamic /* */, __XApp:XApp, __layers:Int=8, __timerInterval:Float=32){
			return new XWorld9 (__parent, __XApp, __layers, __timerInterval);	
		}
		
//------------------------------------------------------------------------------------------
		public function getTouchManager ():XTouchManager {
			return m_touchManager;
		}
		
//------------------------------------------------------------------------------------------
		public override function createViewRect ():Void {
			xxx.setViewRect (G.SCREEN_WIDTH, G.SCREEN_HEIGHT);
		}
				
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
// }
