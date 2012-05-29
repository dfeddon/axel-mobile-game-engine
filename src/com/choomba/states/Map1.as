package com.choomba.states
{
	import com.choomba.components.ChStateMap;
	import com.choomba.entities.Mob;
	import com.choomba.entities.Skeleton;
	import com.choomba.resource.Resource;
	import com.choomba.util.World;
	
	import org.axgl.Ax;
	import org.axgl.AxEntity;
	import org.axgl.AxGroup;
	import org.axgl.AxPoint;
	import org.axgl.collision.AxGrid;
	import org.axgl.particle.AxParticleCloud;
	import org.axgl.particle.AxParticleSystem;
	
	public class Map1 extends ChStateMap
	{
		private var skelGroup:AxGroup;
		private var skelCollider:AxGrid;
		
		public function Map1()
		{
			super();
			
			map = Resource.map1;
			tilesetSrc = Resource.tiles1;
			tilesetName = "tiles1";
			bg = Resource.bg1;
			bgScroll = true;
			
			debug = true;
			
			playerStart = new AxPoint(1, 1);
		}
		
		override public function create():void
		{
			super.create();
			
			skelGroup = new AxGroup();
			skelCollider = new AxGrid(World.WIDTH, World.HEIGHT, 25, 25);
			add(skelGroup);
			
			addSkel();
		}
		
		private function addSkel():void
		{
			var skel:Skeleton = new Skeleton(5, 5, Resource.skeleton);
			skelGroup.add(skel);
		}
		
		override public function update():void
		{
			super.update();
			
			Ax.overlap(particles, skelGroup, mobHit, particlesCollider);// skelCollider);
		}
		
		private function mobHit(abil:AxEntity, skl:AxEntity):void
		{
			trace('hit', abil.width, abil.height);
			
			// kill effect
			AxParticleSystem.emit("vapor", skl.x, skl.y);
			
			// remove mob
			skl.destroy();
			
			// clear mob from group
			skelGroup.cleanup();
			
			// clear particles from group
			particles.cleanup();
			
			// respawn
			addSkel();
		}
		
	}
}