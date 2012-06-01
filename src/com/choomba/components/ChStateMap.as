package com.choomba.components
{
	import com.Ammarz.AxTiledMap.TilesetBank;
	import com.choomba.entities.Mob;
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
	import org.axgl.collision.AxCollider;
	import org.axgl.collision.AxCollisionGroup;
	import org.axgl.collision.AxGrid;
	import org.axgl.input.AxMouseButton;
	import org.axgl.particle.AxParticleCloud;
	import org.axgl.particle.AxParticleSystem;
	import org.axgl.render.AxColor;
	import org.axgl.tilemap.AxTile;
	import org.axgl.tilemap.AxTilemap;
	import org.axgl.tilemap.BwPropTile;
	
	
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
		protected var mobGroup:AxGroup;
		public var tilemapCollideGroup:AxGroup;
		public var TILEMAP_COLLIDER:AxCollisionGroup;
		//protected var mobCollider:AxGrid;

		//protected var sources:AxGroup;
		
		private var _map:DfTiledMap;
		//private var tilemapCollider:AxCollisionGroup;
		private var _screenHalf:Number;
		private var entities:AxGroup;
		
		public static var player:Player;
		
		public var sources:AxGroup;
		public var particles:AxGroup;
		public var particlesCollider:AxCollisionGroup;
		public static const OBJECT_COLLISION:AxCollisionGroup = new AxGrid(World.WIDTH, World.HEIGHT);
		
		public function ChStateMap()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			World.GAMESTATE = this;
			
			// Continue to update and draw this state when it's not the active state
			persistantUpdate = true;
			persistantDraw = true;
			
			stationary = true;
			
			sources = new AxGroup;
			particlesCollider = new AxGrid(World.WIDTH, World.HEIGHT, 1, 1);
			
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
			
			// group collidable tilemaps
			for (var ctm:int = 0; ctm < _map.layers.length; ctm++)
			{
				var tm:ChTilemap = _map.layers[ctm] as ChTilemap;
				if (tm.isCollide())
				{
					if (!tilemapCollideGroup)
						tilemapCollideGroup = new AxGroup(0, 0, World.WIDTH, World.HEIGHT);
					
					tilemapCollideGroup.add(tm);
				}
			}
			//World.tilemapCollideGroup = tilemapCollideGroup;
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
			World.PLAYER = player;
			this.add(player);
			
			sources.add(player);
			// init particle fx (must be done before adding UI state
			//World.sources = sources;
			this.add(sources);
			particles = new AxGroup();
			Particle.initialize();
			
			sources.add(particles);
			
			// add UI layer
			ui = new UIState();
			Ax.pushState(ui);
			
			// setup camera
			Ax.camera.follow(player);
			Ax.camera.bounds = new AxRect(0, 0, World.WIDTH, World.HEIGHT);
			
			//init collision detection
			TILEMAP_COLLIDER = new AxCollider;
			// tilemap
			//tilemapCollider = new AxCollider();
			/*for (var laynum:int = 0; laynum < _map.layers.length; laynum++)
			{
				var tiles:Vector.<AxTile> = AxTilemap(_map.layers[laynum]).getTiles([1]);
				//Ax.collide(player, _map.layers[2], playerCollide, tilemapCollider);
			}*/
			
			mobGroup = new AxGroup();
			//mobCollider = new AxGrid(World.WIDTH, World.HEIGHT, 25, 25);
			add(mobGroup);

			entities = new AxGroup;
			entities.add(mobGroup);
			// listeners
			//Ax.stage2D.addEventListener(TouchEvent.TOUCH_TAP, tapHandler);
			Ax.stage2D.addEventListener(MouseEvent.CLICK, clickHandler);
			//Ax.stage2D.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			Ax.stage2D.addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
		}
		
		protected function addMob(mob:Mob):void
		{
			trace('adding mob');
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			var point:AxPoint = new AxPoint(Math.floor(e.stageX + Ax.camera.x), Math.floor(e.stageY + Ax.camera.y));
			trace('clicked', point.x, point.y);
			
			playerMove(point);
		}
		
		private function mouseDownHandler(e:MouseEvent):void
		{
			/*var point:AxPoint = new AxPoint(e.stageX, e.stageY);
			
			playerMove(point);*/
		}
		
		protected function touchEndHandler(e:TouchEvent):void
		{
			var point:AxPoint = new AxPoint(Math.floor(e.stageX + Ax.camera.x), Math.floor(e.stageY + Ax.camera.y));
			
			playerMove(point);
		}
		
		protected function playerMove(pt:AxPoint):void
		{
			//trace('touch end', pt.x, pt.y, ui.slotActive);
			
			// get tile
			var tilePoint:AxPoint = TileUtils.pointToTile(new AxPoint(pt.x, pt.y));
			var tile:BwPropTile = TileUtils.pointToTileIndex(new AxPoint(pt.x, pt.y), tilemapCollideGroup);
			
			// convert touch coordinates to center point of nearest tile
			var touchPoint:AxPoint = TileUtils.touchToPoint(pt.x, pt.y);
			
			Ax.mouse.update(touchPoint.x, touchPoint.y);
			
			if (ui.slotActive) // ability dragged from ability slot
			{
				trace('ability slot ->', ui.slotSelected);
				ui.slotActive = false;
				
				switch(ui.slotSelected)
				{
					case "TL":
						AxParticleSystem.emit("poison", touchPoint.x, touchPoint.y);
						break;
					
					case "BL":
						AxParticleSystem.emit("fireball", touchPoint.x, touchPoint.y);
						break;
					
					case "TR":
						AxParticleSystem.emit("flameburst", touchPoint.x, touchPoint.y);
						break;
					
					case "BR":
						AxParticleSystem.emit("vapor", touchPoint.x, touchPoint.y);
						break;

				}
			}
			else
			{
				// move player to tile (if tile is not collidable)
				if (tile && tile.properties.layerCollide)
				{
					trace('** untouchable');
				}
				else player.moveToPoint = touchPoint;
			}
		}
		
		private function tapHandler(e:TouchEvent):void
		{
			trace('tapped');
		}
		
		protected function sourceHit(source:AxEntity, target:AxEntity):void
		{
			trace('hit', source.width, source.height);
			
			if (source is Player && target is Mob)
			{
				AxParticleSystem.emit("vapor", player.x, player.y);
				
				// remove mob
				//source.destroy();
				
				return;
			}
			if (target is Mob)
			{
				// kill effect
				AxParticleSystem.emit("vapor", target.x, target.y);
				
				// remove mob
				target.destroy();
				
				// clear mob from group
				mobGroup.cleanup();
				
				// clear sources from group
				sources.cleanup();
			}
		}
		
		override public function update():void
		{
			// sources/entity collision
			Ax.overlap(sources, entities, sourceHit, particlesCollider);// skelCollider);

			//Ax.collide(player, tilemapCollideGroup, null, TILEMAP_COLLIDER);
			//Ax.collide(entities, _map.layers[2]);//, playerCollide, tilemapCollider);
			//Ax.overlap(player, entities, playerCollide, OBJECT_COLLISION);
			
			super.update();
		}
		
		protected function tileCollider(source:AxEntity, target:AxEntity):void
		{
			trace('here');
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