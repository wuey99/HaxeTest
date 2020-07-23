//------------------------------------------------------------------------------------------
package objects;
	
	import assets.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.world.objects.enemy.*;
	
	import gx.mickey.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
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
			
			oScale = 0.18;
			
			calculateMovieClipFrame ();
			
			Idle_Script ();
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
		public function Toss_Script (__x:Float, __y:Float, __ticks:Float = 20):Void {
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
								
								oRotation += 22.5;
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
	}
	
//------------------------------------------------------------------------------------------
// }