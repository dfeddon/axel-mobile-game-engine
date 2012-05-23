package com.Ammarz.AxTiledMap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	
	/**
	 * a way to handle multiple tilesets used in one map
	 * AxTiledMap will look for tilesets defined in Tiled right here
	 * Note: multiple tilesets will cause problems right now, don't use it!
	 */
	public class TilesetBank
	{
		private var _tilesets:Vector.<BitmapData>;
		private var _keys:Dictionary;
		
		public function TilesetBank()
		{
			_tilesets = new Vector.<BitmapData>();
			_keys = new Dictionary(true);
		}
		
		/**
		 * adds a tileset to the the bank.
		 * @param name: The name you gave the tileset inside Tiled editor
		 * @param resource: a BitmapData or an embedded Class holding the Tileset
		 */
		public function addTileset(name:String,resource:*):void
		{
			var res:BitmapData;
			
			if (resource is BitmapData)
			{
				res = resource as BitmapData;
				trace("added tileset [" + name + "] (" + res.width.toString() + "," + res.height.toString());
			}else if (resource is Class)
			{
				var bm:Bitmap = new resource();
				res = bm.bitmapData;
				trace("added tileset [" + name + "] (" + res.width.toString() + "," + res.height.toString()+")");
			}else
			{
				throw new Error("Un expected resource type: " + getQualifiedClassName(resource) + " use BitmapData or a Class");
				return;
			}

			_tilesets.push(res);
			_keys[name] = _tilesets.length - 1;
		}
		
		public function getTileSet(name:String):BitmapData
		{
			var ret:BitmapData = null;
			if (name.length > 0 && _tilesets.length > 0 && _keys[name] != null)
			{
				ret = _tilesets[_keys[name]];
			}else
			{
				throw new Error("no tileset with the name: " + name);
			}
			return ret;
		}
		
		public function dispose():void
		{
			for each (var bd:BitmapData in _tilesets)
			{
				bd.dispose();
			}
			_tilesets = null;
			_keys = null;
		}
	}
}