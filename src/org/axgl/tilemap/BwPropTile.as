package org.axgl.tilemap
{
	import com.choomba.vo.TilesetVO;
	
	import net.pixelpracht.tmx.TmxPropertySet;

	public class BwPropTile extends AxTile
	{
		private var _properties:TilesetVO;//Vector.<String> = new Vector.<String>();
		private var _tilesetId:uint;
		
		public function BwPropTile(map:AxTilemap, index:uint, width:uint, height:uint)
		{
			super(map, index, width, height);
		}

		public function get properties():TilesetVO//Vector.<String>
		{
			return _properties;
		}

		public function set properties(value:TilesetVO):void
		{
			_properties = value;
		}

		public function get tilesetId():uint
		{
			return _tilesetId;
		}

		public function set tilesetId(value:uint):void
		{
			_tilesetId = value;
		}


	}
}