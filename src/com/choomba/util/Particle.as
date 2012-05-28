package com.choomba.util
{
	import com.choomba.components.ChStateMap;
	import com.choomba.resource.Resource;
	
	import org.axgl.Ax;
	import org.axgl.AxState;
	import org.axgl.particle.AxParticleEffect;
	import org.axgl.particle.AxParticleSystem;
	import org.axgl.render.AxBlendMode;
	import org.axgl.render.AxColor;
	import org.axgl.util.AxRange;
	
	/**
	 * This is just a helper class for initializing the various particle effects, without cluttering up the game state.
	 */
	public class Particle {
		public static function initialize():void {
			/*var diamond:AxParticleEffect = new AxParticleEffect("diamond", Resource.PARTICLE_DIAMOND, 10);
			diamond.xVelocity = new AxRange(-30, 30);
			diamond.yVelocity = new AxRange(-30, 30);
			diamond.xAcceleration = new AxRange(-500, 500);
			diamond.yAcceleration = new AxRange(-500, 500);
			diamond.lifetime = new AxRange(1.5, 3.5);
			diamond.amount = 100;
			diamond.blend = AxBlendMode.PARTICLE;
			diamond.endScale = new AxRange(2, 4);
			diamond.color(new AxColor(0.3, 0.3, 0.3), new AxColor(1, 1, 1), new AxColor(0.3, 0.3, 0.3), new AxColor(1, 1, 1));
			(Ax.state as GameState).particles.add(AxParticleSystem.register(diamond));
			*/
			var powerup:AxParticleEffect = new AxParticleEffect("fireball", Resource.fire, 5);
			powerup.x = new AxRange(0, 25);
			powerup.y = new AxRange(0, 25);
			powerup.xVelocity = new AxRange(-30, 30);
			powerup.yVelocity = new AxRange(-30, 30);
			powerup.lifetime = new AxRange(0.5, 2.5);
			powerup.amount = 50;
			powerup.blend = AxBlendMode.PARTICLE;
			powerup.color(new AxColor(0, 0, 0), new AxColor(1, 1, 1), new AxColor(0, 0, 0), new AxColor(1, 1, 1));
			(Ax.state as ChStateMap).particles.add(AxParticleSystem.register(powerup));
			
			var triangle:AxParticleEffect = new AxParticleEffect("poison", Resource.poison, 40);
			triangle.xVelocity = new AxRange(-30, 30);
			triangle.yVelocity = new AxRange(-30, 30);
			triangle.lifetime = new AxRange(0.5, 2.5);
			triangle.amount = 30;
			triangle.blend = AxBlendMode.PARTICLE;
			triangle.color(new AxColor(0.5, 0.3, 0.3), new AxColor(1, 0.5, 0.5), new AxColor(0.5, 0.3, 0.3), new AxColor(1, 0.5, 0.5));
			(Ax.state as ChStateMap).particles.add(AxParticleSystem.register(triangle));
			
			var playerHit:AxParticleEffect = new AxParticleEffect("flameburst", Resource.fire, 10);
			playerHit.xVelocity = new AxRange(-30, 30);
			playerHit.yVelocity = new AxRange(-30, 30);
			playerHit.lifetime = new AxRange(0.5, 1.5);
			playerHit.endScale = new AxRange(2, 5);
			playerHit.amount = 100;
			playerHit.blend = AxBlendMode.PARTICLE;
			playerHit.color(new AxColor(0.5, 0.3, 0.3), new AxColor(1, 0.5, 0.5), new AxColor(0.5, 0.3, 0.3), new AxColor(1, 0.5, 0.5));
			(Ax.state as ChStateMap).particles.add(AxParticleSystem.register(playerHit));
			
			var circle:AxParticleEffect = new AxParticleEffect("vapor", Resource.blueflame, 5);
			circle.xVelocity = new AxRange(-30, 30);
			circle.yVelocity = new AxRange(-50, -20);
			circle.yAcceleration = new AxRange(-200, -50);
			circle.lifetime = new AxRange(0.5, 1.5);
			circle.amount = 20;
			circle.blend = AxBlendMode.PARTICLE;
			circle.color(new AxColor(0.5, 0.5, 0.3), new AxColor(1, 1, 0.5), new AxColor(0.5, 0.5, 0.3), new AxColor(1, 1, 0.5));
			(Ax.state as ChStateMap).particles.add(AxParticleSystem.register(circle));
		}
	}
}