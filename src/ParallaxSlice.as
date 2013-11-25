package  
{
	import org.flixel.*;
	//import org.flixel.plugin.FlxTilemapAlpha;
	
	//TODO: change to extend FlxTilemap?
	public class ParallaxSlice 
	{
		public static var TILE_EMPTY = 0;
		public static var TILE_WALL = 1;
		public static var TILE_WHITE = 2;
		public static var TILE_PATTERN = 3;
		
		public var width:uint;
		public var height:uint;
		public var widthInTiles:uint;
		public var heightInTiles:uint;
		public var tileSize:uint;
		
		public var map:FlxTilemap = new FlxTilemap();
		public var xOffset:int;
		public var yOffset:int;
		
		public function ParallaxSlice(width:uint, height:uint, tileSize:uint, positionOffsetY:uint) 
		{
			this.width = width;
			this.height = height;
			widthInTiles = width / tileSize;
			heightInTiles = height / tileSize;
			this.tileSize = tileSize;
			xOffset = 0;
			yOffset = positionOffsetY;
			
			generateSlice(xOffset, yOffset);
		}
		
		public function generateSlice(xOffset:int, yOffset:int):void 
		{
			var data:Array = new Array(widthInTiles * heightInTiles);
			
			for (var i:uint; i < data.length; i++)
			{
				data[i] = TILE_WALL;
			}
			
			map.loadMap(FlxTilemap.arrayToCSV(data, widthInTiles), Assets.tiles, tileSize, tileSize);
			map.setTileProperties(0, FlxObject.NONE);
			map.setTileProperties(2, FlxObject.NONE);
			map.setTileProperties(3, FlxObject.NONE);
			map.x = xOffset;
			map.y = yOffset;
		}
		
		public function changeTile(oldTile:uint, newTile:uint):void 
		{
			for (var i:uint; i < map.getData().length; i++)
			{
				if (map.getTileByIndex(i) == oldTile)
					map.setTileByIndex(i, newTile);
			}
			
			map.setDirty();
		}
	}
}