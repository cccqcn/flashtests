package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import flashx.textLayout.formats.TextAlign;
	
	import ghostcat.algorithm.traversal.AStar;
	import ghostcat.algorithm.traversal.MapModel;
	
	import sample.Map.CModule;
	import sample.Map.createMap;
	import sample.Map.find;
	import sample.Map.getLen;
	import sample.Map.getMap;
	import sample.Map.getRoad;
	import sample.Map.getRoadX;
	import sample.Map.getRoadY;
	import sample.Map.gotoMap;
	import sample.Map.setMap;
	import sample.Map.testXYZ;
	
	//[SWF(height="600")]
	[SWF(width="800", height="600", frameRate = 60, backgroundColor = 0xFFFFFF)]
	public class TestAstar extends Sprite
	{
		private var ss:int = 9;
		private var ww:int = 5;
		private var mode:int = -1;
		private var map:Array;
		private var map2:Array;
		private var mapbak:Array;
		private var astar:AStar;
		private var start:Point;
		private var mouseDown:Boolean;
		private var tf:TextField = new TextField;
		
		public function TestAstar()
		{
			tf.y = 545;
			tf.multiline = true;
			tf.width = stage.stageWidth;
			tf.height = stage.stageHeight;
			addChild(tf);
			var tf1:TextField = new TextField;
			tf1.y = 545;
			tf1.defaultTextFormat = new TextFormat(null, null, null, null, null, null, null, null, 
				TextAlign.RIGHT);
			tf1.multiline = true;
			tf1.width = stage.stageWidth - 80;
			tf1.height = stage.stageHeight;
			tf1.text = "编辑模式——0:障碍，1:门，2-4:房间\nENTER:寻路，S:保存，L:打开";
			addChild(tf1);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void
		{
			CModule.startAsync(this);
			createMap(0,0);
			var i:int;
			var j:int;
			var v:int;
			var r:Number;
			map = new Array;
			map2 = new Array;
			mapbak = new Array;
			for(i=0;i<80;i++)
			{
				map[i] = new Array;
				for(j=0;j<60;j++)
				{
					if(map2[j] == null)
					{
						map2[j] = new Array;
					}
					if(mapbak[j] == null)
					{
						mapbak[j] = new Array;
					}
					r = Math.random();
					if(r > 0.9)
					{
						v = 0;
					}
					else if(r > 0.8)
					{
						v = 1;
					}
					else 
					{
						v = Math.random() * 2 + 2;
					}
					v = 3;
					map[i][j] = v;
					map2[j][i] = v;
					mapbak[j][i] = v;
					setMap(i, j, v);
				}
			}
			astar = new AStar(new MapModel(map2), 20000);
			redraw();
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKey);
		}
		private function onKey(e:KeyboardEvent):void
		{
			var i:int;
			var j:int;
			start = null;
			for(i=0;i<80;i++)
			{
				for(j=0;j<60;j++)
				{
					map[i][j] = mapbak[j][i];
				}
			}
			redraw();
			if(e.keyCode == Keyboard.ENTER)
			{
				mode = -1;
			}
			if(e.keyCode == Keyboard.NUMBER_0)
			{
				mode = 0;
			}
			if(e.keyCode == Keyboard.NUMBER_1)
			{
				mode = 1;
			}
			if(e.keyCode == Keyboard.NUMBER_2)
			{
				mode = 2;
			}
			if(e.keyCode == Keyboard.NUMBER_3)
			{
				mode = 3;
			}
			if(e.keyCode == Keyboard.NUMBER_4)
			{
				mode = 4;
			}
			if(e.keyCode == Keyboard.NUMBER_5)
			{
				mode = 5;
			}
			if(e.keyCode == Keyboard.S)
			{
				var barr:ByteArray = new ByteArray;
				barr.writeObject(map2);
				var f:FileReference = new FileReference;
				f.save(barr);
			}
			if(e.keyCode == Keyboard.L)
			{
				if(fload == null)
				{
					fload = new FileReference;
				}
				fload.browse();
				fload.addEventListener(Event.SELECT, onselect);
				fload.addEventListener(Event.CANCEL, oncancle);
			}
		}
		private var fload:FileReference;
		private function oncancle(e:Event):void
		{
//			var fload:FileReference = e.currentTarget as FileReference;
			fload.removeEventListener(Event.CANCEL, oncancle);
		}
		private function onselect(e:Event):void
		{
//			var fload:FileReference = e.currentTarget as FileReference;
			fload.removeEventListener(Event.SELECT, onselect);
			fload.addEventListener(Event.COMPLETE, onload);
			fload.load();
		}
		private function onload(e:Event):void
		{
//			var fload:FileReference = e.currentTarget as FileReference;
			fload.removeEventListener(Event.COMPLETE, onload);
			var m:Array = fload.data.readObject();
			var i:int;
			var j:int;
			for(i=0;i<80;i++)
			{
				for(j=0;j<60;j++)
				{
					map[i][j] = m[j][i];
					map2[j][i] = m[j][i];
					mapbak[j][i] = m[j][i];
					setMap(i, j, m[j][i]);
				}
			}
			start = null;
			redraw();
		}
		private function onDown(e:MouseEvent):void
		{
			mouseDown = true;
		}
		private function onMove(e:MouseEvent):void
		{
			if(mouseDown == true && mode != -1)
			{
				var i:int = e.stageX / ss;
				var j:int = e.stageY / ss;
				if(i < 0 || i >= 80 || j < 0 || j >= 60)
				{
					return;
				}
				map[i][j] = mode;
				map2[j][i] = mode;
				mapbak[j][i] = mode;
				setMap(i, j, mode);
				redraw();
			}
		}
		private function onUp(e:MouseEvent):void
		{
			mouseDown = false;
		}
		private function onClick(e:MouseEvent):void
		{
			var i:int = e.stageX / ss;
			var j:int = e.stageY / ss;
			if(i < 0 || i >= 80 || j < 0 || j >= 60)
			{
				return;
			}
			if(mode == -1)
			{
				if(map[i][j] != 0)
				{
					if(start != null)
					{
						trace(start.x, start.y, i, j, map2[start.y][start.x], map2[j][i]);
						
						var t1:int = getTimer();
						find(start.x, start.y, i, j);
						var t2:int = getTimer();
						tf.text = "\t\t\t节点数\t\t耗时";
						var len:int = getLen();
						tf.appendText("\nC++(Green): \t" + len + "\t\t" + (t2 - t1).toString());
						
						var t3:int = getTimer();
						var arr:Array =	astar.find(start, new Point(i, j));
						var arrlen:int = arr?arr.length:-1;
						var t4:int = getTimer();
						tf.appendText("\nAS3(Blue):\t\t" + arrlen + "\t\t" + (t4 - t3).toString());
						for(i=0;i<arrlen;i++)
						{
							map[arr[i].x][arr[i].y] = -2;
						}
						start = null;
					}
					else 
					{
						start = new Point(i, j);
						var v:int;
						for(i=0;i<80;i++)
						{
							for(j=0;j<60;j++)
							{
								map[i][j] = mapbak[j][i];
							}
						}
						map[start.x][start.y] = -10;
					}
				}
				if(len == -8)
				{
				}
				if(len >= 0)
				{
					var xx:int;
					var yy:int;
					for(i=0;i<len;i++)
					{
						xx = getRoadX(i);
						yy = getRoadY(i);
						map[xx][yy] = map[xx][yy] == -2 ? -3 : -1;
					}
				}
			}
			else
			{
				map[i][j] = mode;
				map2[j][i] = mode;
				mapbak[j][i] = mode;
			}
			redraw();
		}
		private function redraw():void
		{
			graphics.clear();
			var i:int;
			var j:int;
			var v:int;
			var color:uint;
			for(i=0;i<80;i++)
			{
				for(j=0;j<60;j++)
				{
					v = map[i][j];
					if(v == -10)
					{
						color = 0x000000;
					}
					else if(v == -3)
					{
						color = 0x00E5FF;
					}
					else if(v == -2)
					{
						color = 0x0000FF;
					}
					else if(v == -1)
					{
						color = 0x00FF00;
					}
					else if(v == 0)
					{
						color = 0x000000;
					}
					else if(v == 1)
					{
						color = 0xFFA3BE;
					}
					else if(v == 2)
					{
						color = 0xFC63FF;
					}
					else if(v == 3)
					{
						color = 0xBFA5FF;
					}
					else if(v == 4)
					{
						color = 0xA3FFD2;
					}
					else if(v == 5)
					{
						color = 0xACFF89;
					}
					graphics.lineStyle(1, color);
					graphics.beginFill(color);
					graphics.drawRect(i * ss, j * ss, v == 1 ? ww/2 : ww, v == 1 ? ww/2 : ww);
					graphics.endFill();
				}
			}
		}
	}
}