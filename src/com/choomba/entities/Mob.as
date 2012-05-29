package com.choomba.entities 
{
	import com.choomba.resource.Resource;
	import com.choomba.util.World;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.axgl.Ax;
	import org.axgl.AxPoint;
	import org.axgl.AxSprite;
	import org.axgl.AxVector;
	import org.axgl.input.AxKey;
	import org.axgl.particle.AxParticleSystem;
	
	/**
	 * Our player entity that we control in the world.
	 */
	public class Mob extends AxSprite
	{
		private var speed:Number;
		
		protected var isMoving:Boolean = false;
		protected var moveTimer:Timer
		
		public var moveToPoint:AxPoint;
		public var hurtTimer:Number = 0;
		
		public function Mob(tilex:uint, tiley:uint, image:Class, w:int = 64, h:int = 64, _speed:Number = 1, reactionTime:int = 1) 
		{
			// convert tile to x/y coordinates
			x = tilex * World.TILE_SIZE;
			y = tiley * World.TILE_SIZE;
			
			speed = _speed;
			
			super(x, y, image, w, h);
			
			addAnimation("standE", [8]);
			addAnimation("standU", [26]);
			addAnimation("standD", [35]);
			addAnimation("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8], 15);
			addAnimation("walkS", [27, 28, 29, 30, 31, 32, 33, 34, 35], 15);
			addAnimation("walkN", [18, 19, 20, 21, 22, 23, 24, 25, 26], 15);
			
			moveToPoint = new AxPoint(World.PLAYER.x, World.PLAYER.y);
			moveTimer = new Timer(reactionTime * 1000, 0);
			moveTimer.addEventListener(TimerEvent.TIMER, moveReady);
			moveTimer.start();
		}
		
		private function moveReady(e:TimerEvent):void
		{
			if (isMoving)
			{
				trace('reacting...', this);
				moveToPoint = new AxPoint(World.PLAYER.x, World.PLAYER.y);
			}
		}
		
		override public function update():void 
		{
			// x and y difference values
			var xd:int = 0;
			var yd:int = 0;
			
			if (moveToPoint) // moving
			{
				if (moveToPoint.x > x) // moving right
				{
					x = x + speed;
					xd = moveToPoint.x - x; // calculate difference between destination x and player x
				}
				else if (moveToPoint.x < x) // moving left
				{
					x = x - speed;
					xd = x - moveToPoint.x; // calculate difference between player x and destination x
				}
				if (moveToPoint.y > y) // moving down
				{
					y = y + speed;
					yd = moveToPoint.y - y; // calculate difference between destination y and player y
				}
				else if (moveToPoint.y < y) // moving up
				{
					y = y - speed;
					yd = y - moveToPoint.y; // calculate difference between player x and destination x
				}
				
				if (moveToPoint.x == x && moveToPoint.y == y) // player stopped
				{
					moveToPoint = new AxPoint(World.PLAYER.x, World.PLAYER.y);
					isMoving = false;
					// clear player's AxPoint
					/*moveToPoint = null;
					
					// set standing animation
					switch(facing)
					{
						case RIGHT:
						case LEFT:
							animate("standE");
							break;
						
						case UP:
							animate("standU");
							break;
						
						case DOWN:
							animate("standD");
							break;
					}*/
				}
				else // adjust walk animation (notably diagnonals) based on x, y differences
				{
					isMoving = true;
					if (xd > yd)
					{
						if (moveToPoint.x > x)
							facing = RIGHT;
						else if (moveToPoint.x < x)
							facing = LEFT;
						animate("walk");
					}
					else
					{
						if (moveToPoint.y < y)
						{
							facing = UP;
							animate("walkN");
						}
						else
						{
							facing = DOWN;
							animate("walkS");
						}
					}
				}
			}
			
			// If we're hurt, change our color to a dark red until hurtTimer has run out
			/*if (hurt) {
			hurtTimer -= Ax.dt;
			setColor(1, 0.3, 0.3, 0.6);
			} else {
			setColor(1, 1, 1, 1);
			}*/
			
			super.update();
		}
		
		override public function destroy():void
		{
			// remove reaction time listener
			moveTimer.removeEventListener(TimerEvent.TIMER, moveReady);
			
			super.destroy();
		}
		
		/**
		 * This is called when we collide with an enemy.
		 */
		/*public function hit(enemy:Entity):void 
		{
		// Set our hurt timer
		hurtTimer = 2;
		
		// Push us sideways based on which side of the enemy we were on
		if (enemy.center.x > center.x) {
		velocity.x = -200;
		} else {
		velocity.x = 200;
		}
		
		// Push us up a bit to make us bounce
		velocity.y = -100;
		
		// Emit the damage particle effect at our current location
		AxParticleSystem.emit("damage", center.x, center.y);
		}*/
		
		/**
		 * Returns whether or not we are hurt, by checking if hurtTimer > 0
		 */
		/*public function get hurt():Boolean 
		{
		return hurtTimer > 0;
		}*/
	}
}
