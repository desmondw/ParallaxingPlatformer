package  
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		public var touchingFloor:Boolean = false;
		public function Player(x:uint, y:uint) 
		{
			super(x, y);
			
			loadGraphic(Assets.player);
			
			maxVelocity.x = Game.TILE_SIZE * 5;
			maxVelocity.y = Game.TILE_SIZE * 10;
			drag.x = maxVelocity.x * 2;
			drag.y = maxVelocity.y * 2;
		}
		
		override public function update():void 
		{
			if (isTouching(FlxObject.FLOOR))
				touchingFloor = true;
			else
				touchingFloor = false;
		}
		
		public function moveLeft():void 
		{
			acceleration.x = -maxVelocity.x * 4;
		}
		public function moveRight():void 
		{
			acceleration.x = maxVelocity.x * 4;
		}
		public function jump():void 
		{
			y -= 1; //HACK: players seem to be imbedded in the ground after moving the code to Level.as
			velocity.y = -maxVelocity.y;
		}
		public function fall():void 
		{
			acceleration.y = maxVelocity.y * 2;
		}
	}
}