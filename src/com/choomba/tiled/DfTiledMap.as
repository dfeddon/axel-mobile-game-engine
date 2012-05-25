package com.choomba.tiled
{
	import com.Ammarz.AxTiledMap.AxTiledMap;
	import com.Ammarz.AxTiledMap.TilesetBank;
	
	import flash.display.BitmapData;
	import flash.utils.getQualifiedClassName;
	
	import net.pixelpracht.tmx.TmxLayer;
	import net.pixelpracht.tmx.TmxMap;
	
	import org.axgl.tilemap.AxTile;
	import org.axgl.tilemap.AxTilemap;
	
	public class DfTiledMap extends AxTiledMap
	{
		private var bitmapClasses:Array = [B0];
		
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
					lay = new AxTilemap();
					gfx = tilesetBank.getTileSet(tlay.tilesetName);
					lay.build(tlay.toCsv(),bitmapDataToClass(gfx),64,64);
					add(lay);
				}else
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