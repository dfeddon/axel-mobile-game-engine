package com.choomba.tiled
{
	import com.Ammarz.AxTiledMap.AxTiledMap;
	import com.Ammarz.AxTiledMap.TilesetBank;
	import com.choomba.components.ChStateMap;
	import com.choomba.util.World;
	
	import flash.display.BitmapData;
	import flash.utils.getQualifiedClassName;
	
	import net.pixelpracht.tmx.TmxLayer;
	import net.pixelpracht.tmx.TmxMap;
	
	import org.axgl.Ax;
	import org.axgl.collision.AxCollisionGroup;
	import org.axgl.collision.AxGrid;
	import org.axgl.tilemap.AxTile;
	import org.axgl.tilemap.AxTilemap;
	
	public class DfTiledMap extends AxTiledMap
	{
		private var bitmapClasses:Array = [B0];
		
		//public static var wallLayer:TmxLayer;
		//public static var wallcollider:AxCollisionGroup;
		
		public function DfTiledMap(x:Number=0, y:Number=0)
		{
			super(x, y);
		}
		
		override public function parseTMX(xml:XML, tilesetBank:TilesetBank):void
		{
			
			_tmx = new TmxMap(xml);
			
			var i:int;
			var l:int;
			var lay:AxTilemap;
			var tlay:TmxLayer;
			var gfx:BitmapData;
			/*var cls:Class;
			var tmpcls:RuntimeBitmapAsset;*/
			
			l = _tmx.layerCount;
			for (i = 0; i < l; i++)
			{
				tlay = _tmx.getLayerByIndex(i);
				if (tlay.tilesetName != null)
				{
					trace('adding layer', tlay.name);
					if (tlay.name == 'walls')
					{
						//Ax.collide(ChStateMap.player, tlay);
						//wallLayer = tlay;
						//wallcollider = new AxGrid(World.WIDTH, World.HEIGHT);
					}
					lay = new AxTilemap();
					gfx = tilesetBank.getTileSet(tlay.tilesetName);
					/**push properties into layer**/
					var tempVector:Vector.<String> = new Vector.<String>();
					for each(var item:Object in tlay.properties)
					{
						tempVector.push(item);
					}
					lay.build(tlay.toCsv(),bitmapDataToClass(gfx),64,64,1,tempVector);
					add(lay);
				}
				else
				{
					trace("Layer: " + tlay.name + " seems to be empty ... or something went wrong!");
				}
				
			}
			var test:AxTile = lay.getTile(54);
			trace('testing');
		}
		
		private function bitmapDataToClass(bitmapData:BitmapData):Class
		{
			var bitmapClass:Class = bitmapClasses[0];
			//index = (index + 1) % bitmapClasses.length;
			RuntimeBitmapAsset.bitmapDatas[getQualifiedClassName(new bitmapClass())] = bitmapData;
			return bitmapClass;
		}
	}
}