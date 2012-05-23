package Samples
{
	import com.Ammarz.AxTiledMap.TilesetBank;
	import com.choomba.entities.Player;
	import com.choomba.resource.Resource;
	import com.choomba.tiled.DfTiledMap;
	
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Keyboard;
	
	import org.axgl.Ax;
	import org.axgl.AxState;
	import org.axgl.input.AxMouseButton;
	import org.axgl.render.AxColor;
	import org.axgl.tilemap.AxTile;

	
	public final class BasicTiledMap extends AxState
	{
		/*
			[Read this if you use AIR 3.2]
			If you test a Stage3D mobile AIR app on the PC with AIR 3.2, the screen will probably be shifted outside the view
			A way around this is to go to app.xml and set the fullscreen tag to false
			but make sure you set it back to true when testing on iOS because it heavily hits the performance.
			This is not an issue when using AIR 3.3
		*/
		
		
		//embed sample related media ...
		
		//the xml file containing map data
		[Embed(source="Samples/Files/map1.tmx", mimeType="application/octet-stream")]
		private var mapXML:Class;
		
		//tileset
		[Embed(source="Samples/Files/tiles1.png")]
		private var tiles1:Class;
		
		private var _map:DfTiledMap;
		
		private var _screenHalf:Number;
		
		public var player:Player;
		
		public function BasicTiledMap()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			Ax.background = AxColor.fromHex(0x000000);
			
			_map = new DfTiledMap();
			
			/*
			create a tile bank which should hold all the tilesets used in maps
			though currently using multiple tilesets in a map will cause rendering issues, I'll be looking into them later
			for now, just use one tileset for all the layers in a map
			*/
			
			var map:Class = Resource.map1;
			var tiles:Class = Resource.tiles1;
			var tileset:String = "tiles1";
			
			var bank:TilesetBank = new TilesetBank();
			bank.addTileset(tileset, tiles);
			
			//init the xml
			var xml:XML = new XML( new map() );
			
			//self explained!
			_map.parseTMX(xml,bank);
			
			add(_map);
			
			//show Ax debug ui
			Ax.debuggerEnabled = true;
			Ax.debugger.active = true;
			Ax.debugger.heartbeat();
			
			// precalculate the screen half width for later use for touch based control on mobile devices
			_screenHalf = Ax.stage2D.stageWidth / 2;
			
			//
			// Create our player
			player = new Player(10, 10);
			this.add(player);
			
			Ax.stage2D.addEventListener(TouchEvent.TOUCH_TAP, tapHandler);
			Ax.stage2D.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			trace('clicked');
		}
		
		private function tapHandler(e:TouchEvent):void
		{
			trace('tapped');
		}
		
		
		override public function update():void
		{
			super.update();
			
			//control camera with keyboard
			if (Ax.keys.down(Keyboard.RIGHT))
			{
				Ax.camera.x+= 10;
			}
			else if (Ax.keys.down(Keyboard.LEFT))
			{
				Ax.camera.x -= 10;
			}
			else if (Ax.keys.down(Keyboard.DOWN))
			{
				Ax.camera.y += 10;
			}
			else if (Ax.keys.down(Keyboard.UP))
			{
				Ax.camera.y -= 10;
			}
			
			//control camera with mouse-touch
			if (Ax.mouse.down(AxMouseButton.LEFT))
			{
				if (Ax.mouse.screen.x > _screenHalf)
				{
					Ax.camera.x+= 10;
				}else
				{
					Ax.camera.x -= 10;
				}
			}
		}
		
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}