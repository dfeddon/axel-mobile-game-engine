package com.choomba.entities
{
	public class Skeleton extends Mob
	{
		public function Skeleton(tilex:uint, tiley:uint, image:Class, w:int=64, h:int=64)
		{
			super(tilex, tiley, image, w, h, .5, 3);
			
			addAnimation("standE", [8]);
			addAnimation("standU", [26]);
			addAnimation("standD", [35]);
			addAnimation("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8], 15);
			addAnimation("walkS", [27, 28, 29, 30, 31, 32, 33, 34, 35], 15);
			addAnimation("walkN", [18, 19, 20, 21, 22, 23, 24, 25, 26], 15);
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}