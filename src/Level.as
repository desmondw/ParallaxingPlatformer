package  
{
	import org.flixel.*;
	
	public class Level
	{
		public var width:uint;
		public var height:uint;
		public var widthInTiles:uint;
		public var heightInTiles:uint;
		public var tileSize:uint;
		
		public var group:FlxGroup = new FlxGroup(); //all in-game objects
		public var grpBackCamera:FlxGroup = new FlxGroup();
		public var grpFrontCamera:FlxGroup = new FlxGroup();
		
		private var slices:Array = new Array(3);
		public static var slicePositionOffsetY:uint = 100000;
		public var currentSlice = 1;
		public var currentSlice2 = 2;
		public var dynamicSlices = false;
		
		public var player:Player;
		public var player2:Player;
		
		private var camBack:Array = new Array(1);
		private var camMiddle:MyCamera;
		private var camFront:MyCamera;
		
		private var camFrontSprite:FlxSprite;
		private var camBackSprite:Array = new Array(1);
		
		public function Level(width:uint, height:uint, tileSize:uint) 
		{
			this.width = width;
			this.height = height;
			widthInTiles = width / tileSize;
			heightInTiles = height / tileSize;
			this.tileSize = tileSize;
			
			FlxG.state.add(grpBackCamera);
			FlxG.state.add(group);
			FlxG.state.add(grpFrontCamera);
			
			generateLevel();
			generatePlayer();
			setupCameras();
		}
		
		public function update():void
		{
			updatePlayer();
			testCollisions();
			
			if (!dynamicSlices)
			{
				var offsetCoefficient:int;
				
				if (currentSlice == 0)
					offsetCoefficient = 1;
				else if (currentSlice == 1)
					offsetCoefficient = 0;
				else 
					offsetCoefficient = -1;
				
				camBack[0].yOffset = slicePositionOffsetY * (offsetCoefficient + 1) - tileSize / 2;
				camMiddle.yOffset = slicePositionOffsetY * offsetCoefficient;
				camFront.yOffset = slicePositionOffsetY *  (offsetCoefficient - 1) + tileSize / 4;
					
				camBackSprite[0].x = player.x - camBackSprite[0].width / 4;
				camBackSprite[0].y = player.y - camBackSprite[0].height / 4 + slicePositionOffsetY * offsetCoefficient;
				
				camFrontSprite.x = player.x - camFrontSprite.width;
				camFrontSprite.y = player.y - camFrontSprite.height + slicePositionOffsetY * offsetCoefficient;
			}
			else
			{
				camBackSprite[0].x = player.x - camBackSprite[0].width / 4;
				camBackSprite[0].y = player.y - camBackSprite[0].height / 4;
				
				camFrontSprite.x = player.x - camFrontSprite.width;
				camFrontSprite.y = player.y - camFrontSprite.height;
			}
		}
		
		private function updatePlayer():void 
		{
			//player movement
			player.acceleration.x = 0;
			if (FlxG.keys.A)
				player.moveLeft();
			if (FlxG.keys.D)
				player.moveRight();
			if (FlxG.keys.W && player.touchingFloor)
				player.jump();
			else if (FlxG.keys.SPACE)
				player.jump();
			else 
				player.fall();
				
			if (FlxG.keys.justPressed("UP") && currentSlice < slices.length - 1) //if not on bottom most slice
			{
				currentSlice++;
				player.y += Level.slicePositionOffsetY;
				
				if (dynamicSlices)
				{
					slices[currentSlice - 1].changeTile(ParallaxSlice.TILE_EMPTY, ParallaxSlice.TILE_WHITE);
					if (currentSlice != slices.length - 1) //if current layer is NOT the very bottom
						slices[currentSlice].changeTile(ParallaxSlice.TILE_PATTERN, ParallaxSlice.TILE_EMPTY);
					
					//if just moved down from very top, add the top overlay sprite
					if (currentSlice == 1)
						grpFrontCamera.add(camFrontSprite);
				}
			}
			if (FlxG.keys.justPressed("DOWN") && currentSlice > 0) //if not on top most slice
			{
				currentSlice--;
				player.y -= Level.slicePositionOffsetY + 1;
				
				if (dynamicSlices)
				{
					slices[currentSlice].changeTile(ParallaxSlice.TILE_WHITE, ParallaxSlice.TILE_EMPTY);
					slices[currentSlice + 1].changeTile(ParallaxSlice.TILE_EMPTY, ParallaxSlice.TILE_PATTERN);
					
					//if just moved to very top, remove the top overlay sprite
					if (currentSlice == 0)
						grpFrontCamera.remove(camFrontSprite);
				}
			}
			
			
			
			player2.visible = false;
			
			//player2 movement
			player2.acceleration.x = 0;
			if (FlxG.keys.LEFT)
				player2.moveLeft();
			if (FlxG.keys.RIGHT)
				player2.moveRight();
			if (FlxG.keys.UP && player2.touchingFloor)
				player2.jump();
			else 
				player2.fall();
				
			if (FlxG.keys.justPressed("NUMPADFOUR") && currentSlice2 < slices.length - 1) //if not on bottom most slice
			{
				currentSlice2++;
				player2.y += Level.slicePositionOffsetY;
			}
			if (FlxG.keys.justPressed("NUMPADONE") && currentSlice2 > 0) //if not on top most slice
			{
				currentSlice2--;
				player2.y -= Level.slicePositionOffsetY + 1;
			}
		}
		
		private function generateLevel():void 
		{
			for (var i:int = slices.length - 1; i >= 0; i--)
			{
				slices[i] = new ParallaxSlice(width * 10, height * 5, tileSize, slicePositionOffsetY * i);
				
				if (i == 0)
				{
					//fill with front layer's "empty space" (white tile)
					for (var j:int = 40; j < 60; j++)
					{
						for (var k:int = 27; k < 47; k++)
						{
							slices[i].map.setTile(j, k, ParallaxSlice.TILE_WHITE);
						}
					}
					
					//platforms
					slices[i].map.setTile(45, 45, ParallaxSlice.TILE_WALL);
					slices[i].map.setTile(46, 45, ParallaxSlice.TILE_WALL);
					slices[i].map.setTile(47, 45, ParallaxSlice.TILE_WALL);
				}
				else if (i == slices.length - 1) //temp front (bottom)
				{
					//fill with background pattern
					for (var j:int = 40; j < 60; j++)
					{
						for (var k:int = 27; k < 47; k++)
						{
							slices[i].map.setTile(j, k, ParallaxSlice.TILE_PATTERN);
						}
					}
					
					//platforms
					slices[i].map.setTile(53, 41, ParallaxSlice.TILE_WALL);
					slices[i].map.setTile(54, 41, ParallaxSlice.TILE_WALL);
					slices[i].map.setTile(55, 41, ParallaxSlice.TILE_WALL);
				}
				else
				{
					//fill with empty space
					for (var j:int = 40; j < 60; j++)
					{
						for (var k:int = 27; k < 47; k++)
						{
							slices[i].map.setTile(j, k, ParallaxSlice.TILE_EMPTY);
						}
					}
					
					//platforms
					slices[i].map.setTile(49, 43, ParallaxSlice.TILE_WALL);
					slices[i].map.setTile(50, 43, ParallaxSlice.TILE_WALL);
					slices[i].map.setTile(51, 43, ParallaxSlice.TILE_WALL);
				}
				
				group.add(slices[i].map);
			}
			
			FlxG.worldBounds.width = width + Game.TILE_SIZE;
			FlxG.worldBounds.height = (height + Game.TILE_SIZE + slicePositionOffsetY) * slices.length;
		}
		
		private function generatePlayer():void 
		{
			player = new Player(tileSize * 50, tileSize * 37 + slicePositionOffsetY);
			currentSlice = 1;
			group.add(player);
			
			player2 = new Player(tileSize * 50, tileSize * 37 + slicePositionOffsetY * 2);
			currentSlice2 = 2;
			group.add(player2);
		}
		
		private function setupCameras():void 
		{
			//top camera
			camFront = new MyCamera(0, 0, Game.SCREEN_WIDTH / 2, Game.SCREEN_HEIGHT / 2);
			camFront.follow(player);
			camFront.xOffset = tileSize / 4;
			camFront.yOffset = slicePositionOffsetY * -1 + tileSize / 4;
			
			camFrontSprite = camFront.screen;
			camFrontSprite.x = player.x - camFrontSprite.width;
			camFrontSprite.y = player.y - camFrontSprite.height;
			camFrontSprite.scale = new FlxPoint(2, 2);
			camFrontSprite.alpha = .5;
			grpFrontCamera.add(camFrontSprite);
			
			//middle camera
			camMiddle = new MyCamera(0, 0, Game.SCREEN_WIDTH, Game.SCREEN_HEIGHT);
			camMiddle.follow(player);
			camMiddle.yOffset = slicePositionOffsetY * 0;
			
			//bottom camera
			camBack[0] = new MyCamera(0, 0, Game.SCREEN_WIDTH * 2, Game.SCREEN_HEIGHT * 2);
			camBack[0].follow(player);
			camBack[0].xOffset = -tileSize / 2;
			camBack[0].yOffset = slicePositionOffsetY * 1 - tileSize / 2;
			
			camBackSprite[0] = camBack[0].screen;
			camBackSprite[0].x = player.x - camBackSprite[0].width / 4;
			camBackSprite[0].y = player.y - camBackSprite[0].height / 4;
			camBackSprite[0].scale = new FlxPoint(.5, .5);
			camBackSprite[0].color = 0xe6e6e6;
			
			for (var i:int = 0; i < camBackSprite.length; i++)
				grpBackCamera.add(camBackSprite[i]);
			
			
			FlxG.addCamera(camFront); //hidden behind middle cam
			for (var i:int = 0; i < camBack.length; i++)
				FlxG.addCamera(camBack[i]); //hidden behind middle cam 
			FlxG.addCamera(camMiddle);
		}
		
		private function testCollisions():void 
		{
			//collide player with all splices
			for (var i:int; i < slices.length; i++)
			{
				FlxG.collide(player, slices[i].map);
				FlxG.collide(player2, slices[i].map);
			}
		}
	}
}