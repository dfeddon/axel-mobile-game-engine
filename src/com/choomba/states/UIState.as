package com.choomba.states
{
	import com.choomba.resource.Resource;
	
	import flash.profiler.showRedrawRegions;
	
	import org.axgl.Ax;
	import org.axgl.AxButton;
	import org.axgl.AxPoint;
	import org.axgl.AxRect;
	import org.axgl.AxSprite;
	import org.axgl.AxState;
	import org.axgl.render.AxColor;
	import org.axgl.text.AxText;
	
	public class UIState extends AxState
	{
		private static const SLOT_SIZE:int = 100;
		private static const DRAG_W:int = 100;
		private static const DRAG_H:int = 150;
		private static const DRAG_OFFSET:int = 15;
		
		private var _slotActive:Boolean = false;
		private var _slotSelected:String;
		
		private var aslotTL:AxSprite;
		private var aslotTR:AxSprite;
		private var aslotBL:AxSprite;
		private var aslotBR:AxSprite;
		private var arectTL:AxRect;
		
		public function UIState()
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
			active = true;
			
			// create background
			//Ax.background = new AxColor(0, 0, 0);
			
			aslotTL = new AxSprite(-DRAG_OFFSET, -DRAG_OFFSET, Resource.aslot, SLOT_SIZE, SLOT_SIZE);
			//aslotTL.scroll.x = aslotTL.scroll.y = 0;
			aslotTL.stationary = true;
			//aslotTL.active = false;
			//aslotTL.scroll.x = aslotTL.scroll.y = 0;
			add(aslotTL);
			
			aslotTR = new AxSprite(Ax.stage2D.stage.fullScreenWidth - DRAG_W + DRAG_OFFSET, -DRAG_OFFSET, Resource.aslot, SLOT_SIZE, SLOT_SIZE);
			//aslotTR.scroll.x = aslotTR.scroll.y = 0;
			aslotTR.stationary = true;
			//aslotTR.active = false;
			//aslotTR.scroll = new AxPoint(0, 0);
			add(aslotTR);

			aslotBL = new AxSprite(-DRAG_OFFSET, Ax.stage2D.stage.fullScreenHeight - DRAG_H + DRAG_OFFSET, Resource.aslot, SLOT_SIZE, SLOT_SIZE);
			//aslotBL.scroll.x = aslotBL.scroll.y = 0;
			aslotBL.stationary = true;
			//aslotBL.active = false;
			//aslotBL.scroll = new AxPoint(0, 0);
			add(aslotBL);

			aslotBR = new AxSprite(Ax.stage2D.stage.fullScreenWidth - DRAG_W + DRAG_OFFSET, Ax.stage2D.stage.fullScreenHeight - DRAG_H + DRAG_OFFSET, Resource.aslot, SLOT_SIZE, SLOT_SIZE);
			//aslotBR.scroll.x = aslotBR.scroll.y = 0;
			aslotBR.stationary = true;
			//aslotBR.active = false;
			//aslotBR.scroll = new AxPoint(0, 0);
			add(aslotBR);
			
			/*var btn:AxButton = new AxButton(100, 100);
			btn.text("Start");
			//btn.stationary = true;
			btn.scroll.x = btn.scroll.y = 0;
			btn.onClick(function():void
			{
				trace("CLICKED");
				//Ax.popState();
			}, false
			);
			
			// add it
			add(btn);*/

		}
		
		public static function deactivate():void
		{
			trace('deactivating ui');
			//slotActive = false;
		}
		
		override public function update():void
		{
			aslotTL.x = -DRAG_OFFSET + Ax.camera.x;
			aslotTL.y = -DRAG_OFFSET + Ax.camera.y;
			
			aslotTR.x = Ax.stage2D.stage.fullScreenWidth - DRAG_W + DRAG_OFFSET + Ax.camera.x; 
			aslotTR.y = -DRAG_OFFSET + Ax.camera.y;
			
			aslotBL.x = -DRAG_OFFSET + Ax.camera.x;
			aslotBL.y = Ax.stage2D.stage.fullScreenHeight - DRAG_H + DRAG_OFFSET + Ax.camera.y;
			
			aslotBR.x = Ax.stage2D.stage.fullScreenWidth - DRAG_W + DRAG_OFFSET + Ax.camera.x;
			aslotBR.y = Ax.stage2D.stage.fullScreenHeight - DRAG_H + DRAG_OFFSET + Ax.camera.y;
			
			if (slotActive) return;

			if (aslotTL.held())
			{
				trace('!!!!!!!!!slotSelected TL held!');
				slotActive = true;
				slotSelected = "TL";
			}
			else if (aslotTR.held())
			{
				trace('!!!!!!!!!slotSelected TR held!');
				slotActive = true;
				slotSelected = "TR";
			}
			else if (aslotBL.held())
			{
				trace('!!!!!!!!!slotSelected BL held!');
				slotActive = true;
				slotSelected = "BL";
			}
			else if (aslotBR.held())
			{
				trace('!!!!!!!!!slotSelected BR held!');
				slotActive = true;
				slotSelected = "BR";
			}
			
			super.update();
			
		}
		
		////////////////////////////
		
		public function get slotActive():Boolean
		{
			return _slotActive;
		}
		
		public function set slotActive(value:Boolean):void
		{
			_slotActive = value;
			
			this.update();
		}

		public function get slotSelected():String
		{
			return _slotSelected;
		}

		public function set slotSelected(value:String):void
		{
			_slotSelected = value;
		}

		
	}
}