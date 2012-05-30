package com.choomba.entities
{
	import com.choomba.resource.Resource;
	import com.choomba.util.World;
	
	import org.axgl.Ax;
	import org.axgl.AxGroup;
	import org.axgl.AxSprite;
	import org.axgl.AxVector;
	import org.axgl.collision.AxCollisionGroup;
	import org.axgl.collision.AxGrid;
	import org.axgl.input.AxKey;

	public class BensPlayer extends Player
	{
		
		
		public function BensPlayer(x:uint, y:uint)
		{
			super(x, y);
			
			maxVelocity = new AxVector(220, 350);
			drag.x = 400;
			acceleration.y = 650;
			
		}
		
		override public function update():void
		{
			
			/*if (Ax.keys.down(AxKey.RIGHT)) {
				acceleration.x = 850;
				facing = RIGHT;
			} else if (Ax.keys.down(AxKey.LEFT)) {
				acceleration.x = -850;
				facing = LEFT;
			} else {
				acceleration.x = 0;
			}*/
			
			// x and y difference values
			var xd:int = 0;
			var yd:int = 0;
			/*if (Ax.keys.pressed(AxKey.SPACE) && isTouching(DOWN)) {
				velocity.y = -360;
			}*/
			
			/*if (velocity.y < 0) {
				animate("jump");
			} else if (velocity.y > 0) {
				animate("fall");
			} else if (velocity.x != 0) {
				animate("walk");
				animationDelay = 1 / Math.max(6, (Math.abs(velocity.x) / maxVelocity.x) * 16);
			} else {
				animate("stand");
			}*/
			
			
			if (moveToPoint) // moving
			{
				if (moveToPoint.x > x) // moving right
				{
					acceleration.x = 850;
					facing = RIGHT;
					/*x++;
					xd = moveToPoint.x - x;*/ // calculate difference between destination x and player x
				}
				else if (moveToPoint.x < x) // moving left
				{
					acceleration.x = -850;
					facing = LEFT;
/*					x--;
					xd = x - moveToPoint.x;*/ // calculate difference between player x and destination x
				}
				if (moveToPoint.y > y) // moving down
				{
					acceleration.y = 850;
					facing = LEFT;
					/*y++;
					yd = moveToPoint.y - y;*/ // calculate difference between destination y and player y
				}
				else if (moveToPoint.y < y) // moving up
				{
					acceleration.y = -850;
					facing = LEFT;
					/*y--;
					yd = y - moveToPoint.y;*/ // calculate difference between player x and destination x
				}
				
				if (x < moveToPoint.x -2 || x > moveToPoint.x + 2)//(moveToPoint.x == x && moveToPoint.y == y) // player stopped
				{
					if (y < moveToPoint.y -2 || y> moveToPoint.y + 2)//(moveToPoint.x == x && moveToPoint.y == y) // player stopped
					{
					velocity.x = 0;
					velocity.y = 0;
					acceleration.x = 0;
					acceleration.y= 0;
					// clear player's AxPoint
					moveToPoint = null;
					trace('facing'+facing);
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
					}
					}
					
					
				}
				else // adjust walk animation (notably diagnonals) based on x, y differences
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
				super.update();
			}
			
			
		}
	}
		
	
}