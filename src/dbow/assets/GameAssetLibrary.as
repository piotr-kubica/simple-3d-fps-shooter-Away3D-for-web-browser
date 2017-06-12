package dbow.assets
{
	public class GameAssetLibrary
	{
		private var _md2Models:Object = null;
		private var _maxModels:Object = null;
		private var _sounds:Object = null;
		private var _images:Object = null;
		private var _clips:Object = null;
		
		public function GameAssetLibrary() {
			_md2Models = new Object();
			_maxModels = new Object();
			_sounds = new Object();
			_images = new Object();
			_clips = new Object();
		}
		
		public function addAsset(e:GameAssetEvent):void {
			if(e.assetAlias == null) {
				throw new Error("Asset alias cannot be null");
			}
			
			var lib:Object = chooseAssetType(e.type);
			
			if(lib[e.assetAlias] != null) {
				throw new Error("Asset " + e.assetAlias + " already exists");
			}
			lib[e.assetAlias] = e.gameAsset;
		}
		
		public function addAsset2(type:String, alias:String, asset:Object):void {
			if(alias == null) {
				throw new Error("Asset alias cannot be null");
			} 
			
			var lib:Object = chooseAssetType(type);
			
			if(lib[alias] != null) {
				throw new Error("Asset " + alias + " already exists");
			}
			lib[alias] = asset;
		}
		
		public function getAsset(type:String, alias:String):Object {
			if(alias == null) {
				throw new Error("Asset alias cannot be null");
			}
			
			var lib:Object = chooseAssetType(type);
			
			if(lib[alias] == null) {
				throw new Error("Asset " + alias + " does not exists");
			}
			return lib[alias];
		}
		
		public function removeAsset(type:String, alias:String):Object {
			if(alias == null) {
				throw new Error("Asset alias cannot be null");
			}
			
			var lib:Object = chooseAssetType(type);
			
			if(lib[alias] == null) {
				throw new Error("Asset " + alias + " does not exists");
			}
			var tmp:Object = lib[alias];
			lib[alias] = null;
			return tmp;
		}
		
		public function toString():String {
			return "MD2_models[" + libraryToString(_md2Models) + "], "
				+ "3DS_models[" + libraryToString(_maxModels) + "], "
				+ "Images[" + libraryToString(_images) + "], "
				+ "Clips[" + libraryToString(_clips) + "], "
				+ "Sounds[" + libraryToString(_sounds) + "]";
		}
		
		private function libraryToString(o:Object):String {
			var str:String = "";
			
			for(var s:String in o) {
				str += s + ",";
				
				if(o[s] == null) {
					str += "NULL";
				}
			}
			return str;
		}
		
		private function chooseAssetType(type:String):Object {
			switch(type) {
				case GameAssetEvent.IMAGE:
					return _images;
					break;
				
				case GameAssetEvent.MD2:
					return _md2Models;
					break;
				
				case GameAssetEvent.MAX:
					return _maxModels;
					break;
				
				case GameAssetEvent.MP3:
					return _sounds;
					break;
				
				case GameAssetEvent.MOVIECLIP:
					return _clips;
					break;
				
				default:
					throw new ArgumentError("Asset of type " + type + " does not exist");
					break;
			}
		}
	}
}