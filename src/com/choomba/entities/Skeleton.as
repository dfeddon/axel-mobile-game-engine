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
			addAnimation("walk", [0], 15);
			addAnimation("walkN", [9], 15);
			addAnimation("walkS", [18], 15);
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}