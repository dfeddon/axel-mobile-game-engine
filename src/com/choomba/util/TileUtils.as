package com.choomba.util
{
	import org.axgl.Ax;
	import org.axgl.AxPoint;

	public class TileUtils
	{
		public function TileUtils()
		{
		}
		
		public static function tileToCoord(x:int, y:int):AxPoint
		{
			var ret:AxPoint;
			
			var _x:int = Math.floor(x) * World.TILE_SIZE;// + (World.TILE_SIZE / 2);
			var _y:int = Math.floor(y) * World.TILE_SIZE;// + (World.TILE_SIZE / 2);
			
			ret = new AxPoint(_x, _y);
			
			return ret;
		}
		
		public static function touchToPoint(x:int, y:int):AxPoint
		{
			var ret:AxPoint;
			
			x = Math.floor(x);
			y = Math.floor(y);
			
			var _x:int = Math.floor((x + Ax.camera.x) / World.TILE_SIZE) * World.TILE_SIZE;// + (World.TILE_SIZE / 2);
			var _y:int = Math.floor((y + Ax.camera.y) / World.TILE_SIZE) * World.TILE_SIZE;// + (World.TILE_SIZE / 2);
			
			ret = new AxPoint(_x, _y);
			
			return ret;
		}
	}
}