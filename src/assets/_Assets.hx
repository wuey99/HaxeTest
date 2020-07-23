//------------------------------------------------------------------------------------------
package assets;
	
	import gx.assets.*;
	
	import kx.*;
	import kx.collections.*;
	import kx.resource.manager.*;
	
	import openfl.display.*;
	import openfl.media.*;
	
//------------------------------------------------------------------------------------------	
	class _Assets extends XAssets {
				
//------------------------------------------------------------------------------------------
		public function new (__XApp:XApp, __parent:Sprite) {
			super (__XApp, __parent);
			
			m_XApp = __XApp;
			
			var __projectManager:XProjectManager = new XProjectManager (m_XApp);
			
			__projectManager.setupFromXML (
				__parent,
				"Assets\\Cows\\Project",
				_EmbeddedAssets.getProjectXML (),
				null,
				null
				);
			
			m_XApp.setProjectManager (__projectManager);
						
			_EmbeddedAssets.addEmbeddedAssets (m_XApp);
		}
		
//------------------------------------------------------------------------------------------
		public override function load ():Bool {	
			return m_XApp.cacheAllClasses (_EmbeddedAssets.getProjectXML ());
		}
			
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }