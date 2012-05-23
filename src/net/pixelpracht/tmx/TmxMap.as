/*******************************************************************************
 * Copyright (c) 2010 by Thomas Jahn
 * This content is released under the MIT License. (Just like Flixel)
 * For questions mail me at lithander@gmx.de!
 ******************************************************************************/
package net.pixelpracht.tmx 
{
	public class TmxMap
	{
		public var version:String; 
		public var orientation:String;
		public var width:uint;
		public var height:uint; 
		public var tileWidth:uint; 
		public var tileHeight:uint;
		
		public var properties:TmxPropertySet = null;
		public var layers:Object = {};
		public var tileSets:Object = {};
		public var objectGroups:Object = {};
		
		private var _layers:Vector.<TmxLayer>;
		private var _tileSets:Vector.<TmxTileSet>;
		private var _objectGroups:Vector.<TmxObjectGroup>;
		
		
		public function TmxMap(source:XML)
		{
			//map header
			version = source.@version ? source.@version : "unknown"; 
			orientation = source.@orientation ? source.@orientation : "orthogonal";
			width = source.@width;
			height = source.@height;
			tileWidth = source.@tilewidth;
			tileHeight= source.@tileheight;	
			//read properties
			for each(node in source.properties)
				properties = properties ? properties.extend(node) : new TmxPropertySet(node);
			//load tilesets
			var node:XML = null;
			
			_tileSets = new Vector.<TmxTileSet>();
			for each(node in source.tileset)
			{
				tileSets[node.@name] = new TmxTileSet(node, this);
				_tileSets.push( tileSets[node.@name] );
			}
			//load layer
			_layers = new Vector.<TmxLayer>();
			for each(node in source.layer)
			{
				layers[node.@name] = new TmxLayer(node, this);
				_layers.push( layers[node.@name] );
			}
			//load object group
			_objectGroups = new Vector.<TmxObjectGroup>();
			for each(node in source.objectgroup)
			{
				objectGroups[node.@name] = new TmxObjectGroup(node, this);
				_objectGroups.push( objectGroups[node.@name] );
			}
				
		}
		
		public function getTileSet(name:String):TmxTileSet
		{
			if (tileSets.hasOwnProperty(name))
				return tileSets[name] as TmxTileSet;
			else
				return null;
		}
		
		public function getLayer(name:String):TmxLayer
		{
			if (layers.hasOwnProperty(name))
				return layers[name] as TmxLayer;
			else
				return null;
		}
		
		public function getObjectGroup(name:String):TmxObjectGroup
		{
			if (objectGroups.hasOwnProperty(name))
				return objectGroups[name] as TmxObjectGroup;
			else
				return null;
		}
		
		public function get layerCount():uint
		{
			return _layers.length;
		}
		
		public function get objectGroupsCount():uint
		{
			return _objectGroups.length;
		}
		
		public function get tilesetsCount():uint
		{
			return _tileSets.length;
		}
		
		public function getLayerByIndex(ind:uint):TmxLayer
		{
			return _layers[ind];
		}
		
		public function getObjectGroupByIndex(ind:uint):TmxObjectGroup
		{
			return _objectGroups[ind];
		}
		
		public function getTilesetByIndex(ind:uint):TmxTileSet
		{
			return _tileSets[ind];
		}
		
		//works only after TmxTileSet has been initialized with an image...
		public function getGidOwner(gid:int):TmxTileSet
		{
			var last:TmxTileSet = null;
			for each(var tileSet:TmxTileSet in tileSets)
			{
				if(tileSet.hasGid(gid))
					return tileSet;
			}
			return null;
		}
	}
}