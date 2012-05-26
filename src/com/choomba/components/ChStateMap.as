package com.choomba.components
{
	import com.Ammarz.AxTiledMap.TilesetBank;
	import com.choomba.entities.Player;
	import com.choomba.resource.Resource;
	import com.choomba.states.UIState;
	import com.choomba.tiled.DfTiledMap;
	import com.choomba.util.Particle;
	import com.choomba.util.TileUtils;
	import com.choomba.util.World;
	
	import flash.events.TouchEvent;
	
	import org.axgl.Ax;
	import org.axgl.AxEntity;
	import org.axgl.AxGroup;
	import org.axgl.AxPoint;
	import org.axgl.AxRect;
	import org.axgl.AxSprite;
	import org.axgl.AxState;
	import org.axgl.input.AxMouseButton;
	import org.axgl.particle.AxParticleSystem;
	import org.axgl.render.AxColor;
	import org.axgl.tilemap.AxTile;
	
	
	public class ChStateMap extends AxState
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
		//[Embed(source="Samples/Files/map1.tmx", mimeType="application/octet-stream")]
		protected var map:Class;// = Resource.map1;
		protected var tilesetSrc:Class;// = Resource.tilesetSrc;
		protected var tilesetName:String;// = "tilesetSrc";
		protected var bg:Class;
		protected var bgScroll:Boolean = true;
		protected var debug:Boolean = true;
		protected var playerStart:AxPoint;// = new Point(0, 0);//:Array = [0, 0];
		
		private var _map:DfTiledMap;
		
		private var _screenHalf:Number;
		
		public static var player:Player;
		
		public var particles:AxGroup = new AxGroup;
		
		public function ChStateMap()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			// Continue to update and draw this state when it's not the active state
			persistantUpdate = true;
			persistantDraw = true;
			
			var background:AxSprite = new AxSprite(0, 0, bg);
			if (!bgScroll)
				background.scroll.x = background.scroll.y = 0;
			add(background);
			//Ax.background = AxColor.fromHex(0x000000);
			
			_map = new DfTiledMap();
			
			/*
			create a tile bank which should hold all the tilesets used in maps
			though currently using multiple tilesets in a map will cause rendering issues, I'll be looking into them later
			for now, just use one tileset for all the layers in a map
			*/
			
			var bank:TilesetBank = new TilesetBank();
			bank.addTileset(tilesetName, tilesetSrc);
			
			//init the xml
			var xml:XML = new XML( new map() );
			
			//self explained!
			_map.parseTMX(xml, bank);
			
			add(_map);
			
			//show Ax debug ui
			if (debug)
			{
				Ax.debuggerEnabled = true;
				Ax.debugger.active = true;
				Ax.debugger.heartbeat();
			}
			
			// precalculate the screen half width for later use for touch based control on mobile devices
			_screenHalf = Ax.stage2D.stageWidth / 2;
			
			//
			// Create our player
			var pa:AxPoint = TileUtils.tileToCoord(playerStart.x, playerStart.y);
			player = new Player(pa.x, pa.y);
			this.add(player);
			
			// particles
			this.add(particles);
			Particle.initialize();
			
			// add UI layer
			Ax.pushState(new UIState);
			
			// setup camera
			Ax.camera.follow(player);
			Ax.camera.bounds = new AxRect(0, 0, World.WIDTH, World.HEIGHT);
			
			// listeners
			//Ax.stage2D.addEventListener(TouchEvent.TOUCH_TAP, tapHandler);
			//Ax.stage2D.addEventListener(MouseEvent.CLICK, clickHandler);
			Ax.stage2D.addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
		}
		
		/*private function clickHandler(e:MouseEvent):void
		{
			trace('clicked', e.localX, e.localY);
		}*/
		
		private function touchEndHandler(e:TouchEvent):void
		{
			trace('touch end');
			
			Ax.mouse.update(e.stageX, e.stageY);
			
			if (UIState.slotActive) // ability dragged from ability slot
			{
				trace('ability slot ->', UIState.slotSelected);
				UIState.deactivate();
				
				switch(UIState.slotSelected)
				{
					case "TL":
						AxParticleSystem.emit("enemy-hit", e.stageX - 50, e.stageY - 50);
						break;
					
					case "BL":
						AxParticleSystem.emit("powerup", e.stageX - 50, e.stageY - 50);
						break;
					
					case "TR":
						AxParticleSystem.emit("player-hit", e.stageX - 50, e.stageY - 50);
						break;
					
					case "BR":
						AxParticleSystem.emit("circle", e.stageX - 50, e.stageY - 50);
						break;

				}
			}
			else
			{
				// move player to coordinates
				player.moveToPoint = TileUtils.touchToPoint(e.stageX, e.stageY);
			}
		}
		
		private function tapHandler(e:TouchEvent):void
		{
			trace('tapped');
		}
		
		
		override public function update():void
		{
			super.update();
			
			//Ax.collide(player, DfTiledMap.wallLayer, testing, DfTiledMap.wallcollider);
		}
		
		/*private function testing(entity1:AxEntity, entity2:AxEntity):void
		{
			trace('collide');
		}*/
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}