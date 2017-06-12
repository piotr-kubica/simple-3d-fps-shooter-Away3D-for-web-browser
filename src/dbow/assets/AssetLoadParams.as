package dbow.assets
{
	import flash.net.URLRequest;

	internal class AssetLoadParams
	{
		private var _assetType:String = null;

		public function get assetAlias():String
		{
			return _assetAlias;
		}

		private var _callback:Function = null;
		private var _urlRequest:URLRequest = null;
		private var _assetAlias:String = null;
		
		public function AssetLoadParams(assetType:String, urlRequest:URLRequest, 
										callback:Function, assetAlias:String)
		{
			if(assetType == null || urlRequest == null || callback == null){
				throw new ArgumentError("AssetLoadParams must not be null");
			}
			_assetType = assetType;
			_urlRequest = urlRequest;
			_callback = callback;
			_assetAlias = assetAlias;
		}
		
		public function get assetType():String
		{
			return _assetType;
		}
		
		public function get urlRequest():URLRequest
		{
			return _urlRequest;
		}
		
		public function get callback():Function
		{
			return _callback;
		}
	}
}