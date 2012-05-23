package com.Ammarz.AxTiledMap
{
	import flash.display.BitmapData;
	
	import net.pixelpracht.tmx.TmxLayer;
	import net.pixelpracht.tmx.TmxMap;
	
	import org.axgl.AxGroup;
	import org.axgl.tilemap.AxTilemap;
	import org.axgl.util.AxCamera;
	
	
	/**
	 * A Class that handles parsing and managing Tiled Map XML files (TMX)
	 */
	
	public class AxTiledMap extends AxGroup
	{
		protected var _layers:Vector.<AxTilemap>;
		protected var _tmx:TmxMap;
		
		public function AxTiledMap(x:Number=0, y:Number=0)
		{
			super(x, y);
		}
		
		public function parseTMX(xml:XML,tilesetBank:TilesetBank):void
		{
			
			/*_tmx = new TmxMap(xml);
			
			var i:int;
			var l:int;
			var lay:AxTilemap;
			var tlay:TmxLayer;
			var gfx:BitmapData;

			l = _tmx.layerCount;
			for (i = 0; i < l; i++)
			{
				tlay = _tmx.getLayerByIndex(i);
				if (tlay.tilesetName != null)
				{
					lay = new AxTilemap();
					gfx = tilesetBank.getTileSet(tlay.tilesetName);
					lay.build(tlay.toCsv(),gfx,32,32);
					add(lay);
				}else
				{
					trace("Layer: " + tlay.name + " seems to be empty ... or something went wrong!");
				}
				
			}*/
			
		}
	}
}