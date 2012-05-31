/*******************************************************************************
 * Copyright (c) 2010 by Thomas Jahn
 * This content is released under the MIT License. (Just like Flixel)
 * For questions mail me at lithander@gmx.de!
 ******************************************************************************/
package net.pixelpracht.tmx 
{
	public dynamic class TmxPropertySet
	{
		public var properties:Array = new Array();
		
		public function TmxPropertySet(source:XML)
		{
			extend(source);
		}
		
		public function extend(source:XML):TmxPropertySet
		{
			var obj:Object;
			for each (var prop:XML in source.property)
			{
				var key:String = prop.@name;
				var value:String = prop.@value;
				this[key] = value;
				obj = new Object();
				obj.key = key;
				obj.value = value;
				properties.push(obj);
			}
			return this;
		}
	}
}