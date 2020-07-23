//------------------------------------------------------------------------------------------
package objects;
	
	import assets.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.type.*;
	import kx.signals.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.world.objects.enemy.*;
	
	import gx.mickey.*;
	
	import nx.touch.XTouchTracker;
		
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	import openfl.events.*;
	
	//------------------------------------------------------------------------------------------
	enum CardSuit {
		DIAMONDS;
		HEARTS;
		SPADES;
		CLUBS;
	}

	//------------------------------------------------------------------------------------------
	enum Face {
		FRONT;
		BACK;
	}
	
	//------------------------------------------------------------------------------------------
	class Card extends XLogicObjectCX {
		public var m_frontSprite:XMovieClip;
		public var x_frontSprite:XDepthSprite;

		public var m_backSprite:XMovieClip;
		public var x_backSprite:XDepthSprite;
		
		public var script:XTask;
		public var gravity:XTask;

		public var flipScript:XTask;
		
		public var m_value:Int;
		public var m_suit:CardSuit;
		public var m_face:Face;
		
		private var m_cursor:XPoint;
		private var m_mouse:XPoint;
		
		private var m_pressedSignal:XSignal;
		private var m_releasedSignal:XSignal;
		private var m_pressedListeners:Map<{}, Int>; // <Dynamic, Int>
		private var m_releasedListeners:Map<{}, Int>; // <Dynamic, Int>
		
		private var m_touchBeginListenerID:Int;
		
		private var m_touchTrackers:Map<XTouchTracker, Bool>;
		
		private var m_mouseOver:Bool;
		private var m_mouseDown:Bool;
		private var m_prev:Bool;
		
		private var m_defaultScale:Float;
		
		private var m_enableMouse:Bool;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			m_value = getArg (args, 0);
			m_suit = getArg (args, 1);
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
			
			gravity = addEmptyTask ();
			script = addEmptyTask ();
			flipScript = addEmptyTask ();
			
			gravity.gotoTask (getPhysicsTaskX (0.25));
			
			oScale = m_defaultScale = 0.18;
			
			calculateMovieClipFrame ();
			
			m_pressedListeners = new Map<{}, Int> (); // <Dynamic, Int>
			m_releasedListeners = new Map<{}, Int> (); // <Dynamic, Int>
			
			m_pressedSignal = createXSignal ();
			m_releasedSignal = createXSignal ();
			
			m_touchTrackers = new Map<XTouchTracker, Bool> ();
			
			m_mouseOver = false;
			m_mouseDown = false;
			m_prev = false;
			
			m_enableMouse = false;
			
			addTask ([
				XTask.WAIT, 0x0100,
				
				function ():Void {
					stage.addEventListener (MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
					stage.addEventListener (MouseEvent.CLICK, onMouseClick, false, 0, true);
					stage.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
					stage.addEventListener (MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
					stage.addEventListener (MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
					stage.addEventListener (MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
					
					m_touchBeginListenerID = G.appX.getTouchManager ().addTouchBeginListener (function (e:TouchEvent):Void {
						var __touchTracker:XTouchTracker;
						
						__touchTracker = G.appX.getTouchManager ().getTouchTracker (e, "primary", []);
						
						if (m_touchTrackers.exists (__touchTracker)) {
							return;
						}
						
						prevTouches ();
						m_touchTrackers.set (__touchTracker, false);
						setCursorPosFromTouch (__touchTracker.getCurrentStageX  (), __touchTracker.getCurrentStageY ());
						if (isTouchOver (__touchTracker) && m_prev == false) {
							firePressedSignal ();
						}
						
						__touchTracker.addTouchMoveListener (function (__tracker:XTouchTracker):Void {
							setCursorPosFromTouch (__touchTracker.getCurrentStageX  (), __touchTracker.getCurrentStageY ());
							
							prevTouches ();
							
							if (isTouchOver (__touchTracker)) {
								trace (": TOUCH_MOVE: ");
							}
						});
						
						__touchTracker.addTouchEndListener (function (__tracker:XTouchTracker):Void {
							m_touchTrackers.remove (__touchTracker);
							
							prevTouches ();
							
							isCursorOver ();
							
							trace (": TOUCH_END: ", m_mouseOver);
							
							if (hasTouches () == false) {
								fireReleasedSignal ();
							}
						});
					});
				},
				
				XTask.RETN,
			]);
			
			Idle_Script ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
		
			stage.removeEventListener (MouseEvent.MOUSE_OVER, onMouseOver);
			stage.removeEventListener (MouseEvent.CLICK, onMouseClick);
			stage.removeEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener (MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener (MouseEvent.MOUSE_UP, onMouseUp);
			stage.removeEventListener (MouseEvent.MOUSE_OUT, onMouseOut);
			
			G.appX.getTouchManager ().removeTouchBeginListener (m_touchBeginListenerID);
		}
		
		//------------------------------------------------------------------------------------------
		public function addPressedListener (__listener:Dynamic /* Function */):Void {
			var id:Int = m_pressedSignal.addListener (__listener);
			
			m_pressedListeners.set (__listener, id);
		}
		
		//------------------------------------------------------------------------------------------
		public function removePressedListener (__listener:Dynamic /* Function */):Void {
			var id:Int = m_pressedListeners.get (__listener);
			
			m_pressedSignal.removeListener (id);
		}
		
		//------------------------------------------------------------------------------------------
		public function firePressedSignal ():Void {
			m_pressedSignal.fireSignal (this);
		}
		
		//------------------------------------------------------------------------------------------
		public function addReleasedListener (__listener:Dynamic /* Function */):Void {
			var id:Int = m_releasedSignal.addListener (__listener);
			
			m_releasedListeners.set (__listener, id);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeReleasedListener (__listener:Dynamic /* Function */):Void {
			var id:Int = m_releasedListeners.get (__listener);
			
			m_releasedSignal.removeListener (id);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireReleasedSignal ():Void {
			oScale = m_defaultScale;
			
			m_releasedSignal.fireSignal (this);
		}
		
		//------------------------------------------------------------------------------------------	
		public function setCursorPosFromMouse (e:MouseEvent):Void {
			// var __p:Point = globalToLocal (new XPoint (e.stageX, e.stageY));
			var __p:XPoint = new XPoint (e.stageX, e.stageY);
			
			m_cursor = m_mouse = new XPoint (__p.x, __p.y);	
		}
		
		//------------------------------------------------------------------------------------------	
		public function setCursorPosFromTouch (__x:Float, __y:Float):Void {	
			// var __p:Point = globalToLocal (new XPoint (__x, __y));
			var __p:XPoint = new XPoint (__x, __y);
			
			m_cursor = new XPoint (__p.x, __p.y);	
		}
		
		//------------------------------------------------------------------------------------------
		public function enableMouse (__value:Bool = true):Void {
			m_enableMouse = __value;
		}
		
		//------------------------------------------------------------------------------------------
		public function isCursorOver ():Bool {
			if (!m_enableMouse) {
				return false;
			}
			
			var __rect:XRect = new XRect (oX - 25, oY - 50, 50, 100);
			
			if (
				m_cursor.x >= __rect.left &&
				m_cursor.y >= __rect.top &&
				m_cursor.x <= __rect.right &&
				m_cursor.y <= __rect.bottom
			) {
				m_mouseOver = true;
			} else {
				m_mouseOver = false;
			}
			
			return m_mouseOver;
		}
		
		//------------------------------------------------------------------------------------------
		public function isTouchOver (__touchTracker:XTouchTracker):Bool {
			if (!m_enableMouse) {
				return false;
			}
			
			var __rect:XRect = new XRect (oX - 50, oY - 50, 100, 100);
			
			if (
				m_cursor.x >= __rect.left &&
				m_cursor.y >= __rect.top &&
				m_cursor.x <= __rect.right &&
				m_cursor.y <= __rect.bottom
			) {
				trace (": isTouchOver: ", m_cursor, oX, oY, __rect);
			
				m_touchTrackers.set (__touchTracker, true);
				
				return hasTouches ();
			} else {
				m_touchTrackers.set (__touchTracker, false);
				
				return hasTouches ();
			}
			
			return hasTouches ();
		}

		//------------------------------------------------------------------------------------------
		public function hasTouches ():Bool {
			var __hasTouches = m_mouseDown;
			
			XType.forEach (m_touchTrackers,
				function (__touchTracker:XTouchTracker):Void {
					if (m_touchTrackers.get (__touchTracker)) {
						__hasTouches = true;
					}
				}
			);
			
			if (__hasTouches) {
				oScale = m_defaultScale * 1.25;
			} else {
				oScale = m_defaultScale;
			}
			
			return __hasTouches;
		}
		
		//------------------------------------------------------------------------------------------		
		public function onMouseOver (e:MouseEvent):Void {
			prevTouches ();
			
			setCursorPosFromMouse (e);
			
			isCursorOver ();
			
			hasTouches ();
		}	
		
		//------------------------------------------------------------------------------------------		
		public function onMouseClick (e:MouseEvent):Void {
			trace (": clicked: ");
			
			if (isCursorOver ()) {
				firePressedSignal ();
			}
			
			addTask ([
				XTask.WAIT, 0x0200,
				
				function ():Void {
					fireReleasedSignal ();
				},
				
				XTask.RETN,
			]);
		}	
		
		//------------------------------------------------------------------------------------------		
		public function onMouseDown (e:MouseEvent):Void {
			prevTouches (); 
			
			setCursorPosFromMouse (e);
				
			if (isCursorOver ()) {
				// firePressedSignal ();
				m_mouseDown = true;
			}
			
			if (hasTouches () && m_prev == false) {
				firePressedSignal ();
			}
		}	
		
		//------------------------------------------------------------------------------------------		
		public function onMouseUp (e:MouseEvent):Void {
			prevTouches ();
			
			setCursorPosFromMouse (e);
			
			#if true
			if (isCursorOver ()) {
				// fireReleasedSignal ();
				m_mouseDown = false;
			}
			#end
			
			fireReleasedSignal ();
			
			return;
			
			if (hasTouches () == false && m_prev == true) {
				fireReleasedSignal ();
			}
		}
		
		//------------------------------------------------------------------------------------------		
		public function onMouseMove (e:MouseEvent):Void {
			prevTouches ();
			
			setCursorPosFromMouse (e);
			
			if (isCursorOver ()) {
				
			} else {
				m_mouseOver = false;
				m_mouseDown = false;
			}
			
			hasTouches ();
		}
		
		//------------------------------------------------------------------------------------------		
		public function onMouseOut (e:MouseEvent):Void {
			m_mouseOver = false;
			m_mouseDown = false;
			
			hasTouches ();
		}
	
		//------------------------------------------------------------------------------------------	
		public function prevTouches ():Void {
			m_prev = hasTouches ();
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
			m_frontSprite = createXMovieClip ("Cards:Cards");
			x_frontSprite = addSpriteAt (m_frontSprite, m_frontSprite.dx, m_frontSprite.dy);
			
			m_backSprite = createXMovieClip ("Cards:Cards");
			x_backSprite = addSpriteAt (m_backSprite, m_backSprite.dx, m_backSprite.dy);
			m_backSprite.gotoAndStop (42);
			
			showFace (Face.BACK);
			
			show ();
		}

		//------------------------------------------------------------------------------------------
		public function getActualValue ():Int {
			if (m_value == 1) {
				return 14;
			} else {
				return m_value;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function calculateMovieClipFrame ():Void {
			var __frameIndex:Int;
			
			switch (m_suit) {
				case DIAMONDS:
					__frameIndex = 1;
				
				case HEARTS:
					__frameIndex = 15;
					
				case SPADES:
					__frameIndex = 29;
					
				case CLUBS:
					__frameIndex = 43;
			}
			
			m_frontSprite.gotoAndStop (__frameIndex + m_value - 1);
		}

		//------------------------------------------------------------------------------------------
		public function showFace (__face:Face):Void {
			m_face = __face;
			
			switch (__face) {
				case Face.FRONT:
					x_frontSprite.setDepth (getDepth () + 1);
					x_backSprite.setDepth (getDepth () - 1);
					
				case Face.BACK:
					x_frontSprite.setDepth (getDepth () - 1);
					x_backSprite.setDepth (getDepth () + 1);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function setCollisions ():Void {
//			G.appX.getEnemyCollisionList ().addCollision (getLayer (), this, getPos (), getCX ());
		}
		
		//------------------------------------------------------------------------------------------
		public function getPhysicsTaskX (DECCEL:Float):Array<Dynamic> /* <Dynamic> */ {
			return [
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					updatePhysics,	
					XTask.GOTO, "loop",
				
				XTask.RETN,
			];
		}
		
		//------------------------------------------------------------------------------------------
		public override function updatePhysics ():Void {			
			// super.updatePhysics ();
		}
		
		//------------------------------------------------------------------------------------------
		public function FlipIdle_Script ():Void {
			var __scaleX:Float = 1.0;
			
			flipScript.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					flipScript.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
						
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
		public function Flip_Script ():Void {
			var __scaleX:Float = 1.0;
			
			var __newFace:Face;
			
			if (m_face == Face.FRONT) {
				__newFace = Face.BACK;
			} else {
				__newFace = Face.FRONT;
			}
			
			flipScript.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					flipScript.addTask ([
						XTask.LOOP, 10,
							XTask.WAIT, 0x0100,
						
							function ():Void {
								__scaleX -= 0.10;
								
								m_frontSprite.scaleX2 = __scaleX;
								m_backSprite.scaleX2 = __scaleX;
							},
						XTask.NEXT,
						
						function ():Void {
							showFace (__newFace);
						},
						
						XTask.LOOP, 10,
							XTask.WAIT, 0x0100,
						
							function ():Void {
								__scaleX += 0.10;
								
								m_frontSprite.scaleX2 = __scaleX;
								m_backSprite.scaleX2 = __scaleX;
							},
						XTask.NEXT,
						
						function ():Void {
							FlipIdle_Script ();
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
		public function Idle_Script ():Void {
			oRotation = 0.0;
			
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
		public function Toss_Script (__x:Float, __y:Float, __ticks:Float = 20, __rotation:Float = 22.5):Void {
			oDX = (__x - oX) / __ticks;
			oDY = (__y - oY) / __ticks;
			
			var __ticksX:XNumber = new XNumber (__ticks);
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					script.addTask ([
						XTask.LOOP, __ticksX,
							XTask.WAIT, 0x0100,
							
							function ():Void {
								oX += oDX;
								oY += oDY;
								
								oRotation += __rotation;
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
		public function TossAndNuke_Script (__x:Float, __y:Float, __ticks:Float = 20, __rotation:Float = 22.5):Void {
			oDX = (__x - oX) / __ticks;
			oDY = (__y - oY) / __ticks;
			
			var __ticksX:XNumber = new XNumber (__ticks);
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					script.addTask ([
						XTask.LOOP, __ticksX,
							XTask.WAIT, 0x0100,
							
							function ():Void {
								oX += oDX;
								oY += oDY;
								
								oRotation += __rotation;
							},
						XTask.NEXT,
						
						XTask.WAIT1000, 10 * 1000,
						
						XTask.RETN,
					]);
					
					script.addTask ([
						XTask.LOOP, 20,
							function ():Void {
								oAlpha = Math.max (0.0, oAlpha - 0.05);
							}, XTask.WAIT, 0x0100,
						XTask.NEXT,
						
						function ():Void {
							nukeLater ();
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
		public function FadeAndNuke_Script ():Void {
			var __alpha:Float = 1.0;
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					script.addTask ([
						XTask.LOOP, 20,
							function ():Void {
								__alpha = Math.max (0.0, __alpha - 0.05);
								m_frontSprite.alpha = __alpha;
								m_backSprite.alpha = 0.0;
								
							}, XTask.WAIT, 0x0400,
						XTask.NEXT,
						
						function ():Void {
							nukeLater ();
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
	}
	
//------------------------------------------------------------------------------------------
// }