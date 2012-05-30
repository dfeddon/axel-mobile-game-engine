package org.axgl.tilemap
{
	import net.pixelpracht.tmx.TmxPropertySet;

	public class BwPropTile extends AxTile
	{
		private var _properties:Vector.<String> = new Vector.<String>();
		
		public function BwPropTile(map:AxTilemap, index:uint, width:uint, height:uint)
		{
			super(map, index, width, height);
		}

		public function get properties():Vector.<String>
		{
			return _properties;
		}

		public function set properties(value:Vector.<String>):void
		{
			_properties = value;
		}

	}
}