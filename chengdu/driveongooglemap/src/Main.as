package 
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point; 
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.overlays.Marker;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMoveEvent;
	import com.google.maps.MapType;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Main extends Sprite 
	{
		public var map:Map = new Map();
		private var control:Sprite = new Sprite;
		private var car:Sprite = new Sprite;
		private var keyArray:Array = new Array;
		private var speedacc:vector = new vector(0,0);
		private var carspeed:vector = new vector(0,0);
		private var loader:Loader = new Loader;
		private	var place:Array = new Array("成都", "东京", "巴黎", "里约热内卢", "微软");
		private	var ll:Array = new Array(new LatLng(30.588864, 104.078293), 
										 new LatLng(35.689492, 139.691709), 
										 new LatLng(48.873762, 2.295274), 
										 new LatLng(-22.910403, -43.208638), 
										 new LatLng(47.64416, -122.130091));
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			initControl();
			
			initMap();
			
			loader.load(new URLRequest("car.png"));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function initControl():void
		{
			var txt:TextField = new TextField;
			txt.autoSize = TextFieldAutoSize.LEFT;
			control.addChild(txt);
			
			control.graphics.lineStyle(1, 0xff0000);
			control.graphics.moveTo(0, 49);
			control.graphics.lineTo(550, 49);
			addChild(control);
			
			var mc:MovieClip;
			var i:int = 0;
			for (i = 0; i < place.length; i++)
			{
				mc = new MovieClip;
				txt = new TextField;
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.selectable = false;
				txt.text = place[i];
				mc.addChild(txt);
				mc.buttonMode = true;
				mc.useHandCursor = true;
				mc.mouseChildren = false;
				mc.x = i * 80+140;
				mc.y = 20;
				mc.addEventListener(MouseEvent.CLICK, onBtnClick);
				addChild(mc);
			}
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			var mc:MovieClip = e.target as MovieClip;
			var i:int;
			for (i = 0; i < place.length; i++)
			{
				if (place[i] == TextField(mc.getChildAt(0)).text)
				{
					map.setCenter(ll[i], 17, MapType.NORMAL_MAP_TYPE);
					return;
				}
			}
		}
		
		private function initMap():void
		{
			map.key = "ABQIAAAAnk-fYHa8anQKqHbvuTZV9RQ4XEp8-k9nmRhA4K7L9A4mGMjLDBT_pzFO7Di0UYpvDqy5MEDzbgQZIg";
			map.setSize(new Point(stage.stageWidth, stage.stageHeight-50));
			map.addEventListener(MapEvent.MAP_READY, onMapReady);
			map.addEventListener(MapMoveEvent.MOVE_STEP, onMoveEnd);
			map.y = 50;
			this.addChild(map);			
		}
		
		private function onLoad(e:Event):void
		{
			loader.y = -19;
			loader.x = -21;
			car.addChild(loader);
			car.scaleX = 0.5;
			car.scaleY = 0.5;
			car.x = 280;
			car.y = 300;
			addChild(car);
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			var i:int;
			var flag:Boolean;
			for (i = 0; i < keyArray.length; i++)
			{
				if (keyArray[i] == e.keyCode)
				{
					flag = true;
				}
			}
			if (!flag)
			{
				keyArray.push(e.keyCode);
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			var i:int;
			for (i = 0; i < keyArray.length; i++)
			{
				if (keyArray[i] == e.keyCode)
				{
					keyArray.splice(i, 1);
					break;
				}
			}
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (map.isLoaded())
			{
				var i:int;
				var keyflag:Boolean;
					speedacc.setLength( -0.0000003);
					speedacc.setAngle(carspeed.getAngle());
				for (i = 0; i < keyArray.length; i++)
				{
					if (keyArray[i] == Keyboard.UP)
					{
						keyflag = true;
						speedacc.setLength(0.0000008);
					}
					if (keyArray[i] == Keyboard.DOWN)
					{
						keyflag = true;
						//map.setCenter(new LatLng(latlng.lat()+speedacc*Math.sin(car.rotation*Math.PI/180), latlng.lng()-speedacc*Math.cos(car.rotation*Math.PI/180)));
						if (carspeed.getLength() > 0)
						{
							carspeed.setLength(carspeed.getLength() - 0.000005);
							trace(carspeed.getLength());
						}
						else
						{
							carspeed.setLength(carspeed.getLength() - 0.000001);
						}
					}
					if (keyArray[i] == Keyboard.LEFT)
					{
						//map.setCenter(new LatLng(latlng.lat(), latlng.lng() - speedacc));
						if (carspeed.getLength() != 0)
						{
							speedacc.setAngle(carspeed.getAngle()-90);
						speedacc.setLength(0.000005);
							//car.rotation = carspeed.getAngle();// (0.0002 - carspeed) * 100000 / 2;
						}
					}
					if (keyArray[i] == Keyboard.RIGHT)
					{
						//map.setCenter(new LatLng(latlng.lat(), latlng.lng()+speedacc));
						if (carspeed.getLength() != 0)
						{
							speedacc.setAngle(carspeed.getAngle()+90);
						speedacc.setLength(0.000005);
							//car.rotation = carspeed.getAngle();// (0.0002 - carspeed) * 100000 / 2;
						}
					}
				}
				var bounds:LatLngBounds = map.getLatLngBounds();
				var latlng:LatLng = bounds.getCenter();
					carspeed.plus(speedacc);
				if (carspeed.getLength() > 0.0001)
					carspeed.setLength(0.0001);
				map.setCenter(new LatLng(latlng.lat() - carspeed.y, latlng.lng() + carspeed.x));
				car.rotation = carspeed.getAngle();
				if (!keyflag)
				{
					if (carspeed.getLength() > 0.000001)
						carspeed.setLength(carspeed.getLength() - 0.0000005);
					if (carspeed.getLength() < -0.000001)
						carspeed.setLength(carspeed.getLength() + 0.0000005);
					if (Math.abs(carspeed.getLength()) < 0.000001);
						//carspeed.setLength(0);
				}
			}
		}
		
		private function onMapReady(event:MapEvent):void 
		{
			map.setCenter(new LatLng(30.588864, 104.078293), 17, MapType.NORMAL_MAP_TYPE);
			//map.setCenter(new LatLng(30.588864, 104.078293), 17, MapType.HYBRID_MAP_TYPE);
			// Add 10 markers to the map at random locations
			var bounds:LatLngBounds = map.getLatLngBounds();
			var latlng:LatLng = bounds.getCenter();
			TextField(control.getChildAt(0)).text = latlng.lat() + "\n" + latlng.lng();
			var southWest:LatLng = bounds.getSouthWest();
			var northEast:LatLng = bounds.getNorthEast();
			var lngSpan:Number = northEast.lng() - southWest.lng();
			var latSpan:Number = northEast.lat() - southWest.lat();
			for (var i:int = 0; i < 10; i++) 
			{
				var newLat:Number = southWest.lat() + (latSpan * Math.random());
				var newLng:Number = southWest.lng() + (lngSpan * Math.random());
				latlng = new LatLng(newLat, newLng);
				//map.addOverlay(new Marker(latlng));  
			}
		}
		
		private function onMoveEnd(event:MapMoveEvent):void 
		{
			var bounds:LatLngBounds = map.getLatLngBounds();
			var latlng:LatLng = bounds.getCenter();
			TextField(control.getChildAt(0)).text = latlng.lat() + "\n" + latlng.lng() + "\n" +carspeed;
		}
		
	}
	
}