package com.choomba.resource 
{
	public class Resource 
	{
		[Embed(source = "./assets/images/playerMage.png")] 
		public static const PLAYER:Class;
		[Embed(source="Samples/Files/map1.tmx", mimeType="application/octet-stream")]
		public static const map1:Class;
		[Embed(source="Samples/Files/tiles1.png")]
		public static const tiles1:Class;
	}
}