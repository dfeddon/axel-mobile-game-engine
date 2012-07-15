package com.choomba.components
{
	import com.choomba.util.TileUtils;
	
	import net.pixelpracht.tmx.TmxPropertySet;
	
	import org.axgl.Ax;
	import org.axgl.AxU;
	import org.axgl.tilemap.AxTile;
	import org.axgl.tilemap.AxTilemap;
	import org.axgl.tilemap.BwPropTile;
	import org.axgl.util.AxCache;
	
	public class ChTilemap extends AxTilemap
	{
		public var prop:Array;//TmxPropertySet;
		public function ChTilemap(x:Number=0, y:Number=0)
		{
			super(x, y);
		}
		
		override public function build(mapString:String, graphic:Class, tileWidth:uint, tileHeight:uint, solidIndex:uint=1):AxTilemap
		{
			this.texture = AxCache.texture(graphic);
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			this.solidIndex = solidIndex;
			
			//this.properties = properties;
			
			this.tileCols = Math.floor(texture.rawWidth / tileWidth);
			this.tileRows = Math.floor(texture.rawHeight / tileHeight);
			this.tiles = new Vector.<AxTile>;
			this.data = new Vector.<uint>;
			
			indexData = new Vector.<uint>;
			vertexData = new Vector.<Number>;
			
			var rowArray:Array = mapString.split("\n");
			var index:uint = 0;
			var uvWidth:Number = 1 / (texture.width / tileWidth);
			var uvHeight:Number = 1 / (texture.height / tileWidth);
			rows = rowArray.length;
			for (var y:uint = 0; y < rows; y++) 
			{
				var row:Array = rowArray[y].split(",");
				cols = Math.max(cols, row.length);
				for (var x:uint = 0; x < cols; x++) 
				{
					var tid:uint = row[x];
					if (tid == 0) 
					{
						data.push(0);
						continue;
					}
					
					data.push(tid);
					tid -= 1;
					
					var tx:uint = x * tileWidth;
					var ty:uint = y * tileHeight;
					var u:Number = (tid % tileCols) * uvWidth;
					var v:Number = Math.floor(tid / tileCols) * uvHeight;
					
					indexData.push(index, index + 1, index + 2, index + 1, index + 2, index + 3);
					vertexData.push(
						tx + AxU.EPSILON, 	ty + AxU.EPSILON,	u,				v,
						tx + tileWidth,		ty + AxU.EPSILON,	u + uvWidth,	v,
						tx + AxU.EPSILON,	ty + tileHeight,	u,				v + uvHeight,
						tx + tileWidth,		ty + tileHeight,	u + uvWidth,	v + uvHeight
					);
					index += 4;
				}
			}
			
			var vertexLength:uint = vertexData.length / shader.rowSize;
			indexBuffer = Ax.context.createIndexBuffer(indexData.length);
			indexBuffer.uploadFromVector(indexData, 0, indexData.length);
			vertexBuffer = Ax.context.createVertexBuffer(vertexLength, shader.rowSize);
			vertexBuffer.uploadFromVector(vertexData, 0, vertexLength);
			triangles = indexData.length / 3;
			
			width = cols * tileWidth;
			height = rows * tileHeight;
			
			tiles.push(null);
			for (index = 1; index <= tileCols * tileRows; index++) 
			{ 
				// get tileset "image" id
				var tileTilesetId:uint = data[index - 1];
				
				var tile:BwPropTile = new BwPropTile(this, index, tileWidth, tileHeight);
				tile.collision = index >= solidIndex ? ANY : NONE;
				// get tileset properties associated with this tile
				tile.properties = TileUtils.getTilesetVOById(tileTilesetId);
				tile.tilesetId = tileTilesetId;
				//if (tile.properties) trace(tile.properties.name, tile.properties.value);
				tiles.push(tile);
			}
			
			return this;
		}
		
		public function isCollide():Boolean
		{
			var bool:Boolean = false;
			
			for (var i:int = 0; i < prop.length; i++)
			{
				if (prop[i].key == 'collide' && prop[i].value == 'true')
				{
					bool = true;
					break;
				}
			}
			
			return bool;
		}
	}
}