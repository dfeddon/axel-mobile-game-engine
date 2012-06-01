package com.choomba.util
{
	import com.choomba.components.ChStateMap;
	import com.choomba.entities.Player;
	
	import org.axgl.AxGroup;

	/**
	 * A utility class where we specify the size of our world and tiles. By doing this, 
	 * and using these constants in our game, we could change the size of our tiles 
	 * without having to go through and change things throughout our entire game.
	 */
	public class World 
	{
		public static const WIDTH:uint = 1600;
		public static const HEIGHT:uint = 1664;
		public static const TILE_SIZE:uint = 64;
		
		public static var GAMESTATE:ChStateMap;
		public static var PLAYER:Player;
		
		public static var tilesetProperties:Array = new Array();
		//public static var tilemapCollideGroup:AxGroup;
		
		//public static var particles:AxGroup;
	}
}