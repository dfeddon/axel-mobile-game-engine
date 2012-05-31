package com.choomba.tiled
{
	import com.Ammarz.AxTiledMap.AxTiledMap;
	import com.Ammarz.AxTiledMap.TilesetBank;
	import com.choomba.components.ChStateMap;
	import com.choomba.components.ChTilemap;
	import com.choomba.util.World;
	import com.choomba.vo.TilesetVO;
	
	import flash.display.BitmapData;
	import flash.utils.getQualifiedClassName;
	
	import net.pixelpracht.tmx.TmxLayer;
	import net.pixelpracht.tmx.TmxMap;
	import net.pixelpracht.tmx.TmxObject;
	
	import org.axgl.Ax;
	import org.axgl.collision.AxCollisionGroup;
	import org.axgl.collision.AxGrid;
	import org.axgl.tilemap.AxTile;
	import org.axgl.tilemap.AxTilemap;
	import org.axgl.tilemap.BwPropTile;
	
	public class DfTiledMap extends AxTiledMap
	{
		private var bitmapClasses:Array = [B0];
		
		//public static var wallLayer:TmxLayer;
		//public static var wallcollider:AxCollisionGroup;
		
		public var layers:Array = new Array();
		
		public function DfTiledMap(x:Number=0, y:Number=0)
		{
			super(x, y);
		}
		
		override public function parseTMX(xml:XML, tilesetBank:TilesetBank):void
		{
			// store tileset properties
			var list:XMLList = new XMLList(xml..tile);
			for (var i2:int = 0; i2 < list.length(); i2++)
			{
				// tiled id uses '0' based indices, whilst Axel utilizes a '1' based indices
				// thus, add 1 to 'id'
				var id:XML = new XML(list[i2]);
				var idint:int = int(id.@id) + 1;
				var idstr:String = idint.toString();
				var prop:XML = new XML(id..property);
				World.tilesetProperties.push(new TilesetVO(idstr, prop.@name, prop.@value));
				//trace('+',id.@id, prop.@name, prop.@value);
			}
			
			var p:Array = World.tilesetProperties;

			_tmx = new TmxMap(xml);
			
			var i:int;
			var l:int;
			var lay:ChTilemap;//AxTilemap;
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
					lay = new ChTilemap();// AxTilemap();
					gfx = tilesetBank.getTileSet(tlay.tilesetName);
					/**push properties into layer**/
					//var tempVector:Vector.<String> = new Vector.<String>();
					
					// add layer properties
					lay.prop = tlay.properties.properties;
					
					// build tilemap
					lay.build(tlay.toCsv(), bitmapDataToClass(gfx), 64, 64, 1);//,tempVector);
					
					// add tilemap to stage
					add(lay);
				}
				else
				{
					trace("Layer: " + tlay.name + " seems to be empty ... or something went wrong!");
				}
				
				layers.push(lay);
				
			}
			/*var test:AxTile = lay.getTile(54);
			trace('testing');*/
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