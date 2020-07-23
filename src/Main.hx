package;

import gx.*;
import assets.*;

import openfl.display.Sprite;
import openfl.Lib;

/**
 * ...
 * @author wuey99
 */
class Main extends Sprite 
{

	public function new() 
	{
		super();
		
		trace(": starting: ");
		
		var __game:Game = new Game ();
		__game.setup (_Assets, null, this);
		addChild (__game);
		
		// Assets:
		// openfl.Assets.getBitmapData("img/assetname.jpg");
	}

}
