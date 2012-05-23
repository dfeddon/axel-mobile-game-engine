package com.choomba.tiled
{
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.BitmapAsset;
	
	public class RuntimeBitmapAsset extends BitmapAsset
	{
		
		/**
		 *  Maps class names to BitmapData instances.
		 */
		public static const bitmapDatas:Object = {};
		
		public function RuntimeBitmapAsset()
		{
			var name:String = getQualifiedClassName(this);
			var bitmapData:BitmapData = bitmapDatas[name];
			if (!bitmapData)
				trace("Warning: BitmapData for \"" + name + "\" not found");
			super(bitmapData, PixelSnapping.AUTO, true);
		}
		
	}
}