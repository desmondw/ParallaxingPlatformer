package
{
	import org.flixel.*;
 
	public class MyCamera extends FlxCamera
	{
		public var xOffset:uint = 0;
		public var yOffset:uint = 0;
		
		public function MyCamera(x:int, y:int, width:int, height:int, zoom:Number = 0)
		{
			super(x, y, width, height, zoom);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (target != null)
			{
				focusOn(new FlxPoint(target.x + xOffset, target.y + yOffset));
			}
		}
	}
}