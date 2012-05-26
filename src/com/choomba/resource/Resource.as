package com.choomba.resource 
{
	public class Resource 
	{
		// player
		[Embed(source = "./assets/images/playerMage.png")] 
		public static const PLAYER:Class;
		
		// map 1
		[Embed(source="./assets/maps/map1.tmx", mimeType="application/octet-stream")]
		public static const map1:Class;
		[Embed(source="./assets/maps/tiles1.png")]
		public static const tiles1:Class;
		
		/////////////////////////////////////////
		// UI
		/////////////////////////////////////////
		// ability slots
		[Embed(source="assets/images/uidrag.png")]
		public static const aslot:Class;
	}
}