package com.choomba.states
{
	import com.choomba.components.ChStateMap;
	import com.choomba.resource.Resource;
	
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
	}
}