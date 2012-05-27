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
		[Embed(source="./assets/images/bgMap1.jpg")]
		public static const bg1:Class;
		
		/////////////////////////////////////////
		// UI
		/////////////////////////////////////////
		// ability slots
		[Embed(source="assets/images/uidrag.png")]
		public static const aslot:Class;
		
		/////////////////////////////////////////
		// Particle
		/////////////////////////////////////////
		[Embed(source="assets/images/fire.png")]
		public static const fire:Class;
		[Embed(source="assets/images/blueflame.png")]
		public static const blueflame:Class;
		[Embed(source="assets/images/fireball.png")]
		public static const fireball:Class;
	}
}