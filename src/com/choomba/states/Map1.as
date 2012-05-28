package com.choomba.states
{
	import com.choomba.components.ChStateMap;
	import com.choomba.entities.Skeleton;
	import com.choomba.resource.Resource;
	import com.choomba.util.World;
	
	import org.axgl.AxPoint;
	
	public class Map1 extends ChStateMap
	{
		public function Map1()
		{
			super();
			
			map = Resource.map1;
			tilesetSrc = Resource.tiles1;
			tilesetName = "tiles1";
			bg = Resource.bg1;
			bgScroll = true;
			
			debug = true;
			
			playerStart = new AxPoint(1, 1);
		}
		
		override public function create():void
		{
			super.create();
			
			var skel:Skeleton = new Skeleton(5, 5, Resource.PLAYER);
			add(skel);
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}
}