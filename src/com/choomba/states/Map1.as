package com.choomba.states
{
	import com.choomba.components.ChStateMap;
	import com.choomba.resource.Resource;
	
	public class Map1 extends ChStateMap
	{
		public function Map1()
		{
			super();
			
			map = Resource.map1;
			tilesetSrc = Resource.tiles1;
			tilesetName = "tiles1";
			
			debug = true;
			
			playerStart = [1, 1];
		}
	}
}