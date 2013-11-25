package
{
	import org.flixel.*;
	import flash.ui.Mouse;
	
	public class PlayState extends FlxState
	{
		public var level:Level;
		
		override public function create():void
		{
			level = new Level(Game.SCREEN_WIDTH*3, Game.SCREEN_HEIGHT, Game.TILE_SIZE);
			FlxG.bgColor = 0x00ffffff; //0x22ffffff or 0xffaaaaaa
		}
		
		override public function update():void
		{
			super.update();
			Mouse.show();
			
			level.update();
		}
	}
}