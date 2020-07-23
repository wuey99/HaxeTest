//------------------------------------------------------------------------------------------
package ui;

	import assets.*;
	
	import kx.*;
	import kx.signals.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.XTextSprite;
	
	import openfl.display.*;
	import openfl.events.*;
	import openfl.text.*;
	import openfl.utils.*;

	import openfl.Assets;
	
//------------------------------------------------------------------------------------------
	class XTextButton extends XLogicObject {
		private var m_text:XTextSprite;
		private var m_tf:TextFormat;
		private var m_buttonName:String;	
		private	var m_fontName:String;
		private var m_fontSize:Int;
		private var m_textWidth:Float;
		private var m_textHeight:Float;
		private var m_mouseUpSignal:XSignal;
		private var m_disabledFlag:Bool;
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
			
			m_disabledFlag = false;
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			m_buttonName = getArg (args, 0);
			m_fontName = getArg (args, 1);
			m_fontSize = getArg (args, 2);
			m_textWidth = getArg (args, 3);
			m_textHeight = getArg (args, 4);
			
			m_mouseUpSignal = new XSignal ();
			
			createSprites ();
			
			mouseEnabled = true;
			
			m_text.mouseEnabled = true;
			
			addTask ([
				function ():Void {
					m_text.addEventListener (MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
					m_text.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
					m_text.addEventListener (MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
					m_text.addEventListener (MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
					m_text.addEventListener (MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
				},
				
				XTask.RETN,
			]);
		}
		
//------------------------------------------------------------------------------------------		
		public function onMouseOver (e:MouseEvent):Void {
			if (!m_disabledFlag) {
				m_text.getTextField ().textColor = 0xcc80c0;
			}
		}	

//------------------------------------------------------------------------------------------		
		public function onMouseDown (e:MouseEvent):Void {
			if (!m_disabledFlag) {
				m_text.getTextField ().textColor = 0xcc40f3;
			}
		}	

//------------------------------------------------------------------------------------------		
		public function onMouseUp (e:MouseEvent):Void {
			if (!m_disabledFlag) {
				m_text.getTextField ().textColor = 0x4040e0;

				fireMouseUpSignal ();
			}
		}

//------------------------------------------------------------------------------------------		
		public function onMouseMove (e:MouseEvent):Void {	
		}
									
//------------------------------------------------------------------------------------------		
		public function onMouseOut (e:MouseEvent):Void {
			if (!m_disabledFlag) {
				m_text.getTextField ().textColor = 0x4040e0;
			}	
		}

//------------------------------------------------------------------------------------------
		public function setDisabled (__flag:Bool):Void {
			m_disabledFlag = __flag;
			
			if (m_disabledFlag) {
				m_text.getTextField ().textColor = 0x808080;
	
				mouseEnabled = false;
			
				m_text.mouseEnabled = false;
			}
			else
			{
				m_text.getTextField ().textColor = 0x000000;
			}
		}
			
//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
			createTextSprite ();
			addSpriteAt (m_text, 0, 0);
			
			m_text.scaleX = 1.0;
			m_text.scaleY = 1.0;

			show ();
		}

//------------------------------------------------------------------------------------------
		public function createTextSprite ():Void {
			m_text = createXTextSprite ();
			
			m_text.getTextField ().text = m_buttonName;
			m_text.getTextField ().selectable = false;
			m_text.getTextField ().multiline = false;
			m_text.getTextField ().wordWrap = false;
			m_text.getTextField ().embedFonts = true;
            m_tf = getStandardTextFormat ();
			m_tf.size = m_fontSize;
			m_tf.font = m_fontName;
			m_text.getTextField ().setTextFormat (m_tf);
			m_text.getTextField ().width = m_textWidth;
			m_text.getTextField ().height = m_textHeight;
			m_text.autoCalcWidth ();
			m_text.autoCalcHeight ();
		}

//------------------------------------------------------------------------------------------
		public function setText (__text:String):Void {
			m_text.getTextField ().text = __text;
			m_text.getTextField ().setTextFormat (m_tf);
		}
		
//------------------------------------------------------------------------------------------
		public function addMouseUpListener (__listener:Dynamic /* Function */):Void {
			m_mouseUpSignal.addListener (__listener);
		}

//------------------------------------------------------------------------------------------
		public function fireMouseUpSignal ():Void {
			m_mouseUpSignal.fireSignal ();
		}

//------------------------------------------------------------------------------------------
		public function removeAllListeners ():Void {
			m_mouseUpSignal.removeAllListeners ();
		}

//------------------------------------------------------------------------------------------
		public function getStandardTextFormat ():TextFormat {
			var __font:Font = Assets.getFont("fonts/Berlin Sans FB Bold.ttf");
			
            var __format:TextFormat = new TextFormat();
			__format.font = __font.fontName;
  			          
            __format.color = 0x4040e0;
            __format.letterSpacing = 0.5;
            __format.align = TextFormatAlign.CENTER;
            
            return __format;	
		}
		
//------------------------------------------------------------------------------------------
		public var text (get, set):XTextSprite;
		
		public function get_text ():XTextSprite {
			return m_text;
		}
		
		public function set_text (__val:XTextSprite): XTextSprite {
			return null;			
		}
				
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
// }
