package dbow.assets
{
	import away3d.animators.VertexAnimator;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.assets.AssetType;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.Parsers;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	public class GameAssetLoader extends EventDispatcher
	{
		private static const ALL_LOADED:String = "all_loaded";
		
		// AssetModelId resolves asset naming conflicts
		private static var AssetModelId:uint = 0;
		
		private var _soundLoader:Sound = null;
		private var _clipLoader:Loader = null;
		private var _md2loader:Loader3D = null;
		private var _maxloader:Loader3D = null;
		private var _imageLoader:Loader = null;
		
		private var _soundLoadQueue:Vector.<AssetLoadParams> = null;
		private var _clipLoadQueue:Vector.<AssetLoadParams> = null;
		private var _md2LoadQueue:Vector.<AssetLoadParams> = null;
		private var _maxLoadQueue:Vector.<AssetLoadParams> = null;
		private var _imageLoadQueue:Vector.<AssetLoadParams> = null;
		
		private var _models:Object = null;
		private var _loadedName:String = null;
		private var _allLoadedCallback:Function = null;
		
		private var _resCnt:int = 0;
		private var _resLoaded:int = 0;
		
		public function GameAssetLoader(target:IEventDispatcher=null) {
			super(target);
			_soundLoader = new Sound();
			_clipLoader = new Loader();
			_md2loader = new Loader3D(true, null);
			_maxloader = new Loader3D(true, null);
			_imageLoader = new Loader();
			
			_soundLoadQueue = new Vector.<AssetLoadParams>();
			_clipLoadQueue = new Vector.<AssetLoadParams>();
			_md2LoadQueue = new Vector.<AssetLoadParams>();
			_maxLoadQueue = new Vector.<AssetLoadParams>();
			_imageLoadQueue = new Vector.<AssetLoadParams>();
			
			_models = new Object();
		}
		
		public function addToLoad(type:String, url:String, callback:Function, assetAlias:String = null):void {
			var u:URLRequest = new URLRequest(url);
			
			if(type == GameAssetEvent.IMAGE) {
				_imageLoadQueue.push(new AssetLoadParams(type, u, callback, assetAlias));
				_resCnt++;
			} else if(type == GameAssetEvent.MD2) {
				_md2LoadQueue.push(new AssetLoadParams(type, u, callback, assetAlias));
				_resCnt++;
			} else if(type == GameAssetEvent.MOVIECLIP) {
				_clipLoadQueue.push(new AssetLoadParams(type, u, callback, assetAlias));
				_resCnt++;
			} else if(type == GameAssetEvent.MP3) {
				_soundLoadQueue.push(new AssetLoadParams(type, u, callback, assetAlias));
				_resCnt++;
			} else if(type == GameAssetEvent.MAX) {
				_maxLoadQueue.push(new AssetLoadParams(type, u, callback, assetAlias));
				_resCnt++;
			} else {
				throw new Error("Unsupported asset type");
			}
		}
		
		public function resourceToLoadCnt():int {
			return _resCnt;
		}
		
		public function resoucesLoaded():int {
			return _resCnt - (_imageLoadQueue.length + _md2LoadQueue.length 
							+ _clipLoadQueue.length + _soundLoadQueue.length 
							+ _maxLoadQueue.length);
		}
		
		public function load(completeLoadAllCallback:Function):void {
			Parsers.enableAllBundled();
			_allLoadedCallback = completeLoadAllCallback;
			
			if(_allLoadedCallback != null) {
				this.addEventListener(ALL_LOADED, _allLoadedCallback);				
			}
						
			if(_md2LoadQueue.length > 0) {
				_md2loader.addEventListener(AssetEvent.ASSET_COMPLETE, md2AssetLoaded);
				_md2loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, md2loaded);
				_md2loader.load(_md2LoadQueue[_md2LoadQueue.length - 1].urlRequest);				
			}
			
			if(_maxLoadQueue.length > 0) {
				_maxloader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, maxAssetLoaded);
				_maxloader.load(_maxLoadQueue[_maxLoadQueue.length - 1].urlRequest);
			}
			
			if(_soundLoadQueue.length > 0) {
				_soundLoader.addEventListener(Event.COMPLETE, soundLoaded);
				_soundLoader.load(_soundLoadQueue[_soundLoadQueue.length - 1].urlRequest);
			}
			
			if(_clipLoadQueue.length > 0) {
				// Event dispatched if external SWF loaded 
//				_clipLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, clipLoaded);
				
				// Event dispatched if external SWF and its sub MovieClips loaded
				_clipLoader.addEventListener("internal_loaded", clipLoaded);
				
				// load next from queue
				_clipLoader.load(_clipLoadQueue[_clipLoadQueue.length - 1].urlRequest);
			}
			
			if(_imageLoadQueue.length > 0) {
				_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
				_imageLoader.load(_imageLoadQueue[_imageLoadQueue.length - 1].urlRequest);
			}
		}
		
		private function clipLoaded(e:Event):void {
			dispatchGameEvent(_clipLoadQueue.pop(), e.target.content);
			_resLoaded++;
			
			if(_clipLoadQueue.length > 0) {
				_clipLoader.load(_clipLoadQueue[_clipLoadQueue.length - 1].urlRequest);
			} else if(_md2LoadQueue.length == 0 && _soundLoadQueue.length == 0 
					&& _imageLoadQueue.length == 0 && _maxLoadQueue.length == 0) {
				dispatchAllLoaded();
			}
		}
		
		private function maxAssetLoaded(e:LoaderEvent):void {
			dispatchGameEvent(_maxLoadQueue.pop(), e.target);
			_resLoaded++;
			
			if(_maxLoadQueue.length > 0) {
				_maxloader = new Loader3D(true, null);
				_maxloader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, maxAssetLoaded);
				_maxloader.load(_maxLoadQueue[_maxLoadQueue.length - 1].urlRequest);
			} else if(_md2LoadQueue.length == 0 && _soundLoadQueue.length == 0 
					&& _imageLoadQueue.length == 0 && _clipLoadQueue.length == 0) {
				dispatchAllLoaded();
			}
		}
		
		private function md2AssetLoaded(e:AssetEvent):void {
			if(_loadedName == null) {
				_loadedName = assignUniqueName();
				_models[_loadedName] = new MD2Asset();
				trace("Loading: " + _loadedName);
			}
			
//			trace("ASSET: " + e.asset.name + "  :: " + _loadedName);
			if (e.asset.assetType == AssetType.MESH 
				&& (_models[_loadedName] as MD2Asset).mesh == null) {
				
				(_models[_loadedName] as MD2Asset).mesh = Mesh(e.asset);

			} else if(e.asset.assetType == AssetType.ANIMATOR
				&& (_models[_loadedName] as MD2Asset).animator == null) {
				
				(_models[_loadedName] as MD2Asset).animator = VertexAnimator(e.asset);

			} else {
//				trace("Extra model asset of type " + e.asset.assetType + " loaded");
			}
		}
		
		private function md2loaded(le:LoaderEvent):void {
			dispatchGameEvent(_md2LoadQueue.pop(), _models[_loadedName]);
			_loadedName = null;
			_resLoaded++;
			
			if(_md2LoadQueue.length > 0) {
				_md2loader.load(_md2LoadQueue[_md2LoadQueue.length - 1].urlRequest);
			} else if(_soundLoadQueue.length == 0 && _clipLoadQueue.length == 0 
					&& _imageLoadQueue.length == 0 && _maxLoadQueue.length == 0) {
				dispatchAllLoaded();
			}
		}
		
		private function assignUniqueName():String {
			return "model" + AssetModelId++;
		}
		
		private function soundLoaded(e:Event):void {
			dispatchGameEvent(_soundLoadQueue.pop(), e.target);
			_resLoaded++;
			
			if(_soundLoadQueue.length > 0) {
				loadNextSound();
			} else if(_md2LoadQueue.length == 0 && _clipLoadQueue.length == 0 
					&& _imageLoadQueue.length == 0 && _maxLoadQueue.length == 0) {
				dispatchAllLoaded();
			}
		}
		
		private function imageLoaded(e:Event):void {
			dispatchGameEvent(_imageLoadQueue.pop(), Bitmap(e.target.content).bitmapData);
			_resLoaded++;
			
			if(_imageLoadQueue.length > 0){
				_imageLoader.load(_imageLoadQueue[_imageLoadQueue.length - 1].urlRequest);
			} else if(_md2LoadQueue.length == 0 && _soundLoadQueue.length == 0 
					&& _clipLoadQueue.length == 0 && _maxLoadQueue.length == 0) {
				dispatchAllLoaded();
			}
		}
		
		private function dispatchGameEvent(alp:AssetLoadParams, asset:Object): void {
			this.addEventListener(alp.assetType, alp.callback);
			this.dispatchEvent(new GameAssetEvent(alp.assetType, asset, alp.assetAlias));
			this.removeEventListener(alp.assetType, alp.callback);				
		}
		
		private function dispatchAllLoaded():void {
			if(this.hasEventListener(ALL_LOADED)) {
				this.dispatchEvent(new Event(ALL_LOADED));
				_resCnt = 0;
				this.removeEventListener(ALL_LOADED, _allLoadedCallback);	
			}
		}
		
		private function loadNextSound():void {
			_soundLoader.removeEventListener(Event.COMPLETE, soundLoaded);
			_soundLoader = new Sound();
			_soundLoader.addEventListener(Event.COMPLETE, soundLoaded);
			_soundLoader.load(_soundLoadQueue[_soundLoadQueue.length - 1].urlRequest);
		}
	}
}