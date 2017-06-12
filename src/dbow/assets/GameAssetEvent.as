package dbow.assets
{
	import flash.events.Event;
	
	public class GameAssetEvent extends Event
	{
		public static const MD2:String = "md2";
		public static const MAX:String = "max";
		public static const IMAGE:String = "image";
		public static const MP3:String = "mp3";
		public static const MOVIECLIP:String = "movieclip";
		
		private var _gameAsset:Object = null;
		private var _assetAlias:String = null;
		
		public function GameAssetEvent(type:String, asset:Object = null, assetAlias:String = null){
			super(type);
			
			if(asset == null) {
				throw new ArgumentError("GameAssetEvent parameters must not be null");
			} else if(type != MD2 && type != IMAGE && type != MP3 
				&& type != MOVIECLIP && type != MAX) {
				throw new ArgumentError("event type not valid");
			}
			_gameAsset = asset;
			_assetAlias = assetAlias;
		}

		public function get assetAlias():String
		{
			return _assetAlias;
		}

		public function get gameAsset():Object
		{
			return _gameAsset;
		}
	}
}