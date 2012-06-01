package com.choomba.states
{
	import com.choomba.components.ChStateMap;
	import com.choomba.entities.Mob;
	import com.choomba.entities.Skeleton;
	import com.choomba.resource.Resource;
	import com.choomba.util.Particle;
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
			
			addSkel();
		}
		
		private function addSkel():void
		{
			var skel:Skeleton = new Skeleton(5, 5, Resource.skeleton);
			mobGroup.add(skel);
		}
		
		override public function update():void
		{
			super.update();
			
			//Ax.overlap(particles, skelGroup, mobHit, particlesCollider);// skelCollider);
		}
		
		override protected function sourceHit(source:AxEntity, target:AxEntity):void
		{
			super.sourceHit(source, target);
			
			// respawn killed mob
			if (source is AxParticleCloud && target is Mob)
				addSkel();
		}
		
	}
}