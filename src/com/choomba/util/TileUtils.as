package com.choomba.util
{
	import com.choomba.components.ChTilemap;
	import com.choomba.vo.TilesetVO;
	
	import org.axgl.Ax;
	import org.axgl.AxGroup;
	import org.axgl.AxPoint;
	import org.axgl.tilemap.AxTile;
	import org.axgl.tilemap.AxTilemap;
	import org.axgl.tilemap.BwPropTile;

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
			
			var _x:int = Math.floor((x) / World.TILE_SIZE) * World.TILE_SIZE;// + (World.TILE_SIZE / 2);
			var _y:int = Math.floor((y) / World.TILE_SIZE) * World.TILE_SIZE;// + (World.TILE_SIZE / 2);
			
			ret = new AxPoint(_x, _y);
			
			return ret;
		}
		
		public static function pointToTile(pt:AxPoint):AxPoint
		{
			return new AxPoint(Math.floor(pt.x / World.TILE_SIZE), Math.floor(pt.y / World.TILE_SIZE));
		}
		
		public static function pointToTileIndex(pt:AxPoint, tilegroup:AxGroup):BwPropTile
		{
			var tilePt:AxPoint = pointToTile(pt);
			var tile:BwPropTile;
			var tl:BwPropTile;
			var lay:ChTilemap;
			var id:int;
			for (var i:int = 0; i < tilegroup.members.length; i++)
			{
				lay = tilegroup.members[i] as ChTilemap;
				id = tilePt.y * 25 + tilePt.x + 1;
				//trace('.id', id, tilePt.y * 25, tilePt.x+1);
				
				tl = ChTilemap(lay).getTile(id) as BwPropTile;
				
				if (!tl)
				{
					trace('**no tile on layer', lay);
					return null;
				}
				else if (tl.properties && int(tl.properties.id) > 0)
				{
					tile = tl;
					
					// is tile's tilemap collidable
					if (lay.isCollide())
						tile.properties.layerCollide = true;
					break;
				}
			}
			
			return tile;
		}
		
		public static function getTilesetVOById(id:uint):TilesetVO
		{
			var vo:TilesetVO;
			
			var sets:Array = World.tilesetProperties;
			
			for (var i:int = 0; i < sets.length; i++)
			{
				//vo = sets[i] as TilesetVO;
				
				if (sets[i].id == id.toString())
				{
					vo = sets[i] as TilesetVO;
					break;
				}
			}
			
			return vo;
		}
	}
}