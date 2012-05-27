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
	
	import flash.events.MouseEvent;
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
		
		protected var map:Class;
		protected var tilesetSrc:Class;
		protected var tilesetName:String;
		protected var bg:Class;
		protected var bgScroll:Boolean = true;
		protected var debug:Boolean = true;
		protected var playerStart:AxPoint;
		protected var ui:UIState;
		
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
			
			stationary = true;
			
			//Ax.background = AxColor.fromHex(0x000000);
			var background:AxSprite = new AxSprite(0, 0, bg);
			if (!bgScroll)
				background.scroll.x = background.scroll.y = 0;
			add(background);
			
			_map = new DfTiledMap();
			
			/*
			create a tile bank which should hold all the tilesets used in maps
			though currently using multiple tilesets in a map will cause rendering issues, 
			I'll be looking into them later for now, just use one tileset for all the 
			layers in a map
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
			
			// precalculate the screen half width for later use for touch based control 
			// on mobile devices
			_screenHalf = Ax.stage2D.stageWidth / 2;
			
			//
			// Create our player
			var pa:AxPoint = TileUtils.tileToCoord(playerStart.x, playerStart.y);
			player = new Player(pa.x, pa.y);
			this.add(player);
			
			// init particle fx (must be done before adding UI state
			this.add(particles);
			Particle.initialize();
			
			// add UI layer
			ui = new UIState();
			Ax.pushState(ui);
			
			// setup camera
			Ax.camera.follow(player);
			Ax.camera.bounds = new AxRect(0, 0, World.WIDTH, World.HEIGHT);
			
			// listeners
			//Ax.stage2D.addEventListener(TouchEvent.TOUCH_TAP, tapHandler);
			//Ax.stage2D.addEventListener(MouseEvent.CLICK, clickHandler);
			Ax.stage2D.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			Ax.stage2D.addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
		}
		
		/*private function clickHandler(e:MouseEvent):void
		{
			trace('clicked', e.localX, e.localY);
		}*/
		
		private function mouseDownHandler(e:MouseEvent):void
		{
		}
		
		private function touchEndHandler(e:TouchEvent):void
		{
			trace('touch end', e.stageX, e.stageY, ui.slotActive);
			
			// convert touch coordinates to center point of nearest tile
			var touchPoint:AxPoint = TileUtils.touchToPoint(e.stageX, e.stageY);
			
			Ax.mouse.update(touchPoint.x, touchPoint.y);
			
			if (ui.slotActive) // ability dragged from ability slot
			{
				trace('ability slot ->', ui.slotSelected);
				ui.slotActive = false;
				
				switch(ui.slotSelected)
				{
					case "TL":
						AxParticleSystem.emit("poison", touchPoint.x + Ax.camera.x, touchPoint.y + Ax.camera.y);
						break;
					
					case "BL":
						AxParticleSystem.emit("fireball", touchPoint.x + Ax.camera.x, touchPoint.y + Ax.camera.y);
						break;
					
					case "TR":
						AxParticleSystem.emit("flameburst", touchPoint.x + Ax.camera.x, touchPoint.y + Ax.camera.y);
						break;
					
					case "BR":
						AxParticleSystem.emit("vapor", touchPoint.x + Ax.camera.x, touchPoint.y + Ax.camera.y);
						break;

				}
			}
			else
			{
				// move player to tile
				player.moveToPoint = touchPoint;
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