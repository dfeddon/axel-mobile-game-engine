package com.choomba.states
{
	import com.choomba.resource.Resource;
	
	import org.axgl.Ax;
	import org.axgl.AxButton;
	import org.axgl.AxSprite;
	import org.axgl.AxState;
	import org.axgl.render.AxColor;
	import org.axgl.text.AxText;
	
	public class UIState extends AxState
	{
		private static const DRAG_W:int = 100;
		private static const DRAG_H:int = 150;
		private static const DRAG_OFFSET:int = 25;
		
		public static var draggerActive:Boolean = false;
		public static var dragger:String;
		
		private var uidragTL:AxSprite;
		private var uidragTR:AxSprite;
		private var uidragBL:AxSprite;
		private var uidragBR:AxSprite;
		
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
			
			// create background
			Ax.background = new AxColor(0, 0, 0);
			
			uidragTL = new AxSprite(-DRAG_OFFSET, -DRAG_OFFSET, Resource.uidrag);
			uidragTL.scroll.x = uidragTL.scroll.y = 0;
			uidragTL.stationary = true;
			add(uidragTL);
			
			uidragTR = new AxSprite(Ax.stage2D.stage.fullScreenWidth - DRAG_W + DRAG_OFFSET, -DRAG_OFFSET, Resource.uidrag);
			uidragTR.scroll.x = uidragTR.scroll.y = 0;
			uidragTL.stationary = true;
			add(uidragTR);

			uidragBL = new AxSprite(-DRAG_OFFSET, Ax.stage2D.stage.fullScreenHeight - DRAG_H + DRAG_OFFSET, Resource.uidrag);
			uidragBL.scroll.x = uidragBL.scroll.y = 0;
			uidragTL.stationary = true;
			add(uidragBL);

			uidragBR = new AxSprite(Ax.stage2D.stage.fullScreenWidth - DRAG_W + DRAG_OFFSET, Ax.stage2D.stage.fullScreenHeight - DRAG_H + DRAG_OFFSET, Resource.uidrag);
			uidragBR.scroll.x = uidragBR.scroll.y = 0;
			uidragTL.stationary = true;
			add(uidragBR);
		}
		
		public static function deactivate():void
		{
			trace('deactivating ui');
			if (draggerActive)
				draggerActive = false;
		}
		
		override public function update():void
		{
			super.update();
			
			//trace(uidragTL.
			if (uidragTL.held())
			{
				trace('!!!!!!!!!dragger TL held!');
				draggerActive = true;
				dragger = "TL";
			}
			else if (uidragTR.held())
			{
				trace('!!!!!!!!!dragger TR held!');
				draggerActive = true;
				dragger = "TR";
			}
			else if (uidragBL.held())
			{
				trace('!!!!!!!!!dragger BL held!');
				draggerActive = true;
				dragger = "BL";
			}
			else if (uidragBR.held())
			{
				trace('!!!!!!!!!dragger BR held!');
				draggerActive = true;
				dragger = "BR";
			}
		}
	}
}