package com.choomba.vo
{
	public class TilesetVO
	{
		public var id:String;
		public var name:String;
		public var value:String;
		public var layerCollide:Boolean;
		
		public function TilesetVO(_id:String, _name:String, _value:String)
		{
			id = _id;
			name = _name;
			value = _value;
		}
	}
}