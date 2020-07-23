//------------------------------------------------------------------------------------------
package assets;

import kx.*;
import kx.xml.*;
import openfl.utils.ByteArray;

//------------------------------------------------------------------------------------------
#if false
<library path="src\\assets\\Cows\\Project\\common\\74701E81-F2AA-4B68-CADD-FE36BE63C42A-Cards.swf" preload="true" generate="true" />
<library path="src\\assets\\Cows\\Project\\common\\C7A55CCB-A0F8-5B96-3784-431789BEC894-Table.swf" preload="true" generate="true" />

#end

//------------------------------------------------------------------------------------------


//------------------------------------------------------------------------------------------
class _EmbeddedAssets {

//------------------------------------------------------------------------------------------
public static inline var m_projectXML:String = "<project><manifest name=\"common.xml\"><manifest><folder name=\"root\" oldPath=\"\"><folder name=\"sprites\" oldPath=\"\"><resource totalWidth=\"16302\" oldPath=\"common\" type=\".pmp\" path=\"common\" embed=\"false\" width=\"286\" src=\"5A8F169E-0AFA-68A7-D61E-26E0A8EC9CE3-Cards.pmp\" pmp_width=\"512\" height=\"406\" name=\"@Cards\" dst=\"5A8F169E-0AFA-68A7-D61E-26E0A8EC9CE3-Cards.pmp\" originY=\"0\" originX=\"0\" regY=\"-203\" regX=\"-143\"/><resource name=\"Cards\" dst=\"74701E81-F2AA-4B68-CADD-FE36BE63C42A-Cards.swf\" oldPath=\"common\" type=\".fla\" path=\"$Embedded\" embed=\"false\" src=\"74701E81-F2AA-4B68-CADD-FE36BE63C42A-Cards.fla\"><classX name=\"Cards\" regY=\"0\" width=\"32\" regX=\"0\" height=\"32\"/></resource><resource totalWidth=\"900\" oldPath=\"common\" type=\".pmp\" path=\"common\" embed=\"false\" width=\"900\" src=\"99F73562-7C05-869C-FB19-8383DF85C480-Table.pmp\" pmp_width=\"1024\" height=\"600\" name=\"@Table\" dst=\"99F73562-7C05-869C-FB19-8383DF85C480-Table.pmp\" originY=\"226\" originX=\"65\" regY=\"0\" regX=\"0\"/><resource name=\"Table\" dst=\"C7A55CCB-A0F8-5B96-3784-431789BEC894-Table.swf\" oldPath=\"common\" type=\".fla\" path=\"$Embedded\" embed=\"false\" src=\"C7A55CCB-A0F8-5B96-3784-431789BEC894-Table.fla\"><classX name=\"Table\" regY=\"0\" width=\"32\" regX=\"0\" height=\"32\"/></resource></folder></folder></manifest></manifest></project>";

//------------------------------------------------------------------------------------------
public static function getProjectXML ():XSimpleXMLNode {
	return new XSimpleXMLNode (m_projectXML);
	}

//------------------------------------------------------------------------------------------
public static function addEmbeddedAssets (__XApp:XApp):Void {
		__XApp.getProjectManager ().addEmbeddedResource (
			"$Embedded\\74701E81-F2AA-4B68-CADD-FE36BE63C42A-Cards.swf" , Cards
		);
		__XApp.getProjectManager ().addEmbeddedResource (
			"$Embedded\\C7A55CCB-A0F8-5B96-3784-431789BEC894-Table.swf" , Table
		);

	}

//------------------------------------------------------------------------------------------
}
