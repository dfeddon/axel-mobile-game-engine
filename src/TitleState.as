package {
	import org.axgl.Ax;
	import org.axgl.AxButton;
	import org.axgl.AxState;
	import org.axgl.render.AxColor;
	import org.axgl.text.AxText;
	
	public class TitleState extends AxState 
	{
		override public function create():void 
		{
			// Don't update or draw this state when it's not the active state
			persistantUpdate = false;
			persistantDraw = false;
			
			// create background
			Ax.background = new AxColor(0, 0, 0);
			
			// add title text
			var txt:AxText = new AxText(width / 2, height / 2, null, "Working Title");
			add(new AxText(10, 10, null, "title!"));
			
			// create start button
			var btn:AxButton = new AxButton(100, 100);
			btn.text("Start");
			btn.onClick(function():void
				{
					Ax.pushState(new GameState);
					//Ax.popState();
				}
			);
			
			// add it
			add(btn);
		}
	}
}