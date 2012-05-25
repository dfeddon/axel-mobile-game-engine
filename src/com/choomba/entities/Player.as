package com.choomba.entities 
{
	import com.choomba.resource.Resource;
	
	import org.axgl.Ax;
	import org.axgl.AxPoint;
	import org.axgl.AxSprite;
	import org.axgl.AxVector;
	import org.axgl.input.AxKey;
	import org.axgl.particle.AxParticleSystem;
	
	/**
	 * Our player entity that we control in the world.
	 */
	public class Player extends AxSprite 
	{
		public var moveToPoint:AxPoint;
		/**
		 * A timer keeping track of whether (and how long) the player is hurt.
		 */
		public var hurtTimer:Number = 0;
		
		/**
		 * Creates a new player.
		 */
		public function Player(x:uint, y:uint) 
		{
			super(x, y, Resource.PLAYER, 64, 64);
			
			addAnimation("standE", [8]);
			addAnimation("standU", [26]);
			addAnimation("standD", [35]);
			addAnimation("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8], 15);
			addAnimation("walkS", [27, 28, 29, 30, 31, 32, 33, 34, 35], 15);
			addAnimation("walkN", [18, 19, 20, 21, 22, 23, 24, 25, 26], 15);
			
			// Adjust bounding box
			//bounds(16, 30, 4, 2);
			// Add friction
			/*drag = new AxVector(400, 300);
			// Add the maximum velocity of our player
			maxVelocity = new AxVector(150, 600);
			// Add gravity
			acceleration.y = 600;*/
		}
		
		override public function update():void 
		{
			// x and y difference values
			var xd:int = 0;
			var yd:int = 0;
			// facing string
			var f:String;
			
			if (moveToPoint) // moving
			{
				if (moveToPoint.x > x) // moving right
				{
					x++;
					xd = moveToPoint.x - x; // calculate difference between destination x and player x
					f = "r";
				}
				else if (moveToPoint.x < x) // moving left
				{
					x--;
					xd = x - moveToPoint.x; // calculate difference between player x and destination x
					f = "l";
				}
				if (moveToPoint.y > y) // moving down
				{
					y++;
					yd = moveToPoint.y - y; // calculate difference between destination y and player y
					f = "d";
				}
				else if (moveToPoint.y < y) // moving up
				{
					y--;
					yd = y - moveToPoint.y; // calculate difference between player x and destination x
					f = "u";
				}
				if (moveToPoint.x == x && moveToPoint.y == y) // player stopped
				{
					// clear player's AxPoint
					moveToPoint = null;
					
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
					}
				}
				else // adjust animation (notably diagnonals) based on x, y differences
				{
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
						if (f == "u")
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
			if (hurt) {
				hurtTimer -= Ax.dt;
				setColor(1, 0.3, 0.3, 0.6);
			} else {
				setColor(1, 1, 1, 1);
			}
			
			super.update();
		}
		
		/**
		 * This is called when we collide with an enemy.
		 */
		public function hit(enemy:Entity):void 
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
		}
		
		/**
		 * Returns whether or not we are hurt, by checking if hurtTimer > 0
		 */
		public function get hurt():Boolean 
		{
			return hurtTimer > 0;
		}
	}
}
