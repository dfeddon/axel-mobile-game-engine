package com.choomba.states
{
	import com.Ammarz.AxTiledMap.TilesetBank;
	import com.choomba.components.ChStateMap;
	import com.choomba.entities.BensPlayer;
	import com.choomba.entities.Skeleton;
	import com.choomba.resource.Resource;
	import com.choomba.tiled.DfTiledMap;
	import com.choomba.util.Particle;
	import com.choomba.util.TileUtils;
	import com.choomba.util.World;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.filters.BlurFilter;
	import flash.utils.Timer;
	
	import org.axgl.Ax;
	import org.axgl.AxEntity;
	import org.axgl.AxGroup;
	import org.axgl.AxPoint;
	import org.axgl.AxRect;
	import org.axgl.AxSprite;
	import org.axgl.AxU;
	import org.axgl.collision.AxCollider;
	import org.axgl.collision.AxCollisionGroup;
	import org.axgl.collision.AxGrid;
	import org.axgl.input.AxKey;
	import org.axgl.input.AxMouse;
	import org.axgl.input.AxMouseButton;
	import org.axgl.particle.AxParticleSystem;
	import org.axgl.util.AxRange;
	
	public class Map2 extends ChStateMap
	{
		// player settings		
		private var _rotateSpeedMax:Number = 20;
		private var _gravity:Number = .68;
		
		// projectile gun settings
		private var _bulletSpeed:Number = 4;		
		private var _maxDistance:Number = 200;
		private var _reloadSpeed:Number = 250; //milliseconds
		private var _barrelLength:Number = 20;
		private var _bulletSpread:Number = 5;
		
		// gun stuff - do not edit
		private var _isLoaded:Boolean = true;		
		private var _isFiring:Boolean = false;
		private var _endX:Number;
		private var _endY:Number;
		private var _startX:Number;
		private var _startY:Number;
		private var _reloadTimer:Timer;
		private var _bullets:Array = [];
		
		// array that holds walls
		private var _solidObjects:Array = [];
		
		// global vars
		private var _player:MovieClip;
		private var _dx:Number;
		private var _dy:Number;
		private var _pcos:Number;
		private var _psin:Number;
		private var _trueRotation:Number;
		
		/** The pre-allocated collision grid */
		private static const COLLISION_GRID:AxCollisionGroup = new AxGrid(400, 600, 10, 15);
		/** The current "level", used to increase difficulty as you progress */
		public var level:Number = 0;
		/** The player you control */
		//public var player:Player;
		
		/** Powerups group */
		public var powerups:AxGroup = new AxGroup;
		/** Player bullets group */
		public var playerBullets:AxGroup = new AxGroup;
		/** Enemy bullets group */
		public var enemyBullets:AxGroup = new AxGroup;
		/** Enemies group */
		public var enemies:AxGroup = new AxGroup;
		/** Helper group for colliding against multiple other groups */
		public var colliders:AxGroup = new AxGroup;
		/** Particles group */
		//public var particles:AxGroup = new AxGroup;
		
		/** The base amount of time it takes for an enemy to spawn, in seconds */
		private static const BASE_SPAWN:Number = 2;
		/** The amount of time the spawn decreases per "level" */
		private static const SPAWN_DECREASE:Number = 0.1;
		/** Timer to help us spawn enemies at a given rate */
		private var spawnTimer:Number = BASE_SPAWN;
		
		/** How long between when we "clean" our enemies group */
		private static const GARBAGE_COLLECT_DELAY:Number = 5;
		private var garbageCollectTimer:Number = GARBAGE_COLLECT_DELAY;
		
		private var _map:DfTiledMap;
		private var _screenHalf:Number;
		public static var player:BensPlayer;
		/**Collision detection group for main map*/
		private static var TILEMAP_COLLIDER:AxCollisionGroup;
		
		private var skelGroup:AxGroup;
		private var skelCollider:AxCollisionGroup;
		public function Map2()
		{
			super();
			
			map = Resource.map1;
			tilesetSrc = Resource.tiles1;
			tilesetName = "tiles1";
			bg = Resource.bg1;
			bgScroll = true;
			
			debug = true;
			
			playerStart = new AxPoint(1, 1);
			
			//var bullet:Bullet = new Bullet(100,100);
			/*BULLET.WIDTH = 200;
			BULLET.HEIGHT = 200;
			ADD(BULLET);*/
			Ax.stage2D.addEventListener(MouseEvent.CLICK, clickHandler);
			
		}
		
		
		private function addSkel():void
		{
			var skel:Skeleton = new Skeleton(5, 5, Resource.skeleton);
			skelGroup.add(skel);
		}
	
		override public function create():void
		{
			
			super.create();
			skelGroup = new AxGroup();
			skelCollider = new AxGrid(World.WIDTH, World.HEIGHT, 25, 25);
			add(skelGroup);
			
			addSkel();
			// Continue to update and draw this state when it's not the active state
			persistantUpdate = true;
			persistantDraw = true;
			
			stationary = true;
			
			particles = new AxGroup;
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
			player = new BensPlayer(pa.x, pa.y);
			World.PLAYER = player;
			this.add(player);
			
			// init particle fx (must be done before adding UI state
			//World.particles = particles;
			this.add(particles);
			//Particle.initialize();
			
			// add UI layer
			ui = new UIState();
			Ax.pushState(ui);
			
			//init collision detection
			TILEMAP_COLLIDER = new AxCollider;
			
			// setup camera
			Ax.camera.follow(player);
			Ax.camera.bounds = new AxRect(0, 0, World.WIDTH, World.HEIGHT);
			
			// listeners
			//Ax.stage2D.addEventListener(TouchEvent.TOUCH_TAP, tapHandler);
			//Ax.stage2D.addEventListener(MouseEvent.CLICK, clickHandler);
			Ax.stage2D.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			//Ax.stage2D.addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
		}
		
		private function mouseDownHandler(e:MouseEvent):void
		{
		}
		
/*		private function touchEndHandler(e:TouchEvent):void
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
				// move player to tile
				player.moveToPoint = touchPoint;
			}
		}
*/		

		
		/*public override function create():void
		{
			super.create();
			/*Registry.game = this;
			var sprite:AxSprite = new AxSprite(10,200,Resource.turret);
			sprite.width = 10;
			sprite.height = 10;
		//	add(sprite);
			
			this.add(enemies);
			Registry.player = player;

			
		}*/
		
		/*private function spawn():void {
			switch (AxU.rand(0, 3)) {
				case 0:
					enemies.add(new Butterfly);
					break;
				case 1:
					enemies.add(new Slicer);
					break;
				case 2:
					enemies.add(new Meteor);
					break;
				case 3:
					enemies.add(new Turret);
					break;
			}
		}*/
		
		private function clickHandler(e:MouseEvent):void
		{
			
		}
		
		public override function update():void
		{
			// Spawn enemies at a semi-random rate, based on BASE_SPAWN, SPAWN_DECREASE, and the current level
			/*spawnTimer -= Ax.dt;
			if (spawnTimer <= 0) {
				spawn();
				spawnTimer = new AxRange(BASE_SPAWN * 0.5, BASE_SPAWN).randomNumber() - level * SPAWN_DECREASE;
			}*/
			
			// Level goes up by 1 every 15 seconds, caps out at 10
			level += Ax.dt / 15;
			if (level > 10) {
				level = 10;
			}
			
			// Overlap the player with enemies, enemy bullets, and powerups
			Ax.overlap(player, colliders, onPlayerHit, COLLISION_GRID);
			// Overlap the player bullets with enemies
			Ax.overlap(playerBullets, enemies, onBulletHitEnemy, COLLISION_GRID);
			
			// Garbage collect every GARBAGE_COLLECT_DELAY. This is just cleaning up the enemies group to keep performance snappy
			garbageCollectTimer -= Ax.dt;
			if (garbageCollectTimer <= 0) {
				garbageCollectTimer = GARBAGE_COLLECT_DELAY;
				garbageCollect();
			}
			
			Ax.collide(player, _map, null, TILEMAP_COLLIDER);
			
			super.update();
		}
		
		/**
		 * Callback function when overlapping the player with enemies, bullets, and powerups.
		 * 
		 * @param player Our player
		 * @param target The object our player collided with
		 */
		private function onPlayerHit(player:BensPlayer, target:AxEntity):void {
			/*if (target is Powerup) {
				// If we collided with a power, collect it
				(target as Powerup).collect();
			} else if (target is Bullet) {
				// If we collided with a bullet, destroy the bullet and show the player-hit particle effect
				AxParticleSystem.emit("player-hit", target.center.x, target.center.y);
				target.destroy();
			}*/
		}
		
		/**
		 * Callback function when overlapping the enemies with player bullets.
		 * 
		 * @param bullet The bullet that hit the enemy.
		 * @param target The enemy the bullet hit.
		 */
		private function onBulletHitEnemy(bullet:AxEntity, target:AxEntity):void {
			/*AxParticleSystem.emit("enemy-hit", bullet.center.x, bullet.center.y);
			(target as Enemy).damage();
			bullet.destroy();*/
		}
		
		
		/**
		 * Clean up the enemy group. This rebuilds the group, throwing away all the non-existent objects (anything that destroy() was
		 * called on). This is an alternative to recycling. Note that recycling is better when it makes sense, because it avoids
		 * having to create new objects, which is an expensive operation, and it avoids having to garbage collect the old objects.
		 */
		private function garbageCollect():void {
			enemies.cleanup();
		}
		
		/**
		 * Fire weapon
		 */
		private function fire():void
		{
			// check if firing
			//if (!_isFiring) return;
			
			// check if reloaded
			//if (!_isLoaded) return;
			
			// create bullet
			createBullet();
			
			// start reload timer
			_reloadTimer = new Timer(_reloadSpeed);
			//_reloadTimer.addEventListener(TimerEvent.TIMER, reloadTimerHandler);
			_reloadTimer.start();
			
			// set reload flag to false
			_isLoaded = false;
		}
		
		/**
		 * Creates a bullet movieclip and sets it's properties
		 */
		private function createBullet():void
		{
			// precalculate the cos & sine
			/*_pcos = Math.cos(_player.rotation * Math.PI / 180);
			_psin = Math.sin(_player.rotation * Math.PI / 180);
			
			// start X & Y
			// calculate the tip of the barrel
			_startX = _player.x - _barrelLength * _pcos;
			_startY = _player.y - _barrelLength * _psin;
			
			// end X & Y
			// calculate where the bullet needs to go
			// aim 50 pixels in front of the gun
			_endX = _player.x - 50 * _pcos + Math.random() * _bulletSpread - _bulletSpread * .5;
			_endY = _player.y - 50 * _psin + Math.random() * _bulletSpread - _bulletSpread * .5;*/
			
			// ATTACH BULLET FROM LIBRARY
			/*var TEMPBULLET:Bullet = new Bullet(_startX,_startY);
			
			// CALCULATE VELOCITY
			TEMPBULLET.vx = (_endX - _startX) / _bulletSpeed;
			TEMPBULLET.vy = (_endY - _startY) / _bulletSpeed;
			
			// SET POSITION
			TEMPBULLET.x = _startX;
			TEMPBULLET.y= _startY;
			
			// SAVE STARTING LOCATION
			TEMPBULLET.startX = _startX;
			TEMPBULLET.startY = _startY;
			
			// SET MAXIMUM ALLOWED TRAVEL DISTANCE
			TEMPBULLET.maxDistance = _maxDistance;
			
			// ADD BULLET TO BULLETS ARRAY
			_bullets.push(TEMPBULLET);*/
			
			// add to display list
			/*var sprite:AxSprite = new AxSprite(10,233,Resource.turret);
			sprite.width = 10;
			sprite.height = 10;
			add(sprite);*/
		}
		
	
	
	
}
}