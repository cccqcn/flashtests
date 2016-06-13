package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Main extends Sprite 
	{
		
		public var labelarr:Array = new Array("黑方(Black)", "白方(White)");
		public var chessarray:Array = new Array("王", "后", "象", "马", "车", "兵");
		public var colorarr:Array = new Array(0xF0FFFF, 0x999999);
		public var bgarray:Array = new Array(8);
		
		public var boxwidth:int = 30;
		public var minimizeflag:int;
		public var score:Array;
		public var player:int;
		
		public var chessbg:MovieClip;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			createchess();
			// entry point
		}
		
		private function createchess():void {
			chessbg = new MovieClip();
			var bgcnt:int;	// = _root.bgcount();
			//_root.chessbg.movebar.txt.text = _global.labelarr[(_global.player + 1) / 2] + " " + bgcnt[Math.abs(_global.player - 1) / 2] + "\t\t" + _global.labelarr[(_global.text_so.data.playflag + 1) / 2] + "走(Go)";
			/*if (_global.text_so.data.playflag == 10) {
				if (bgcnt[0] > bgcnt[1]) {
					winner = _global.player == 1 ? "You WIN!" : "You LOSE!";
				}
				if (bgcnt[0] < bgcnt[1]) {
					winner = _global.player == -1 ? "You WIN!" : "You LOSE!";
				}
				if (bgcnt[0] == bgcnt[1]) {
					winner = "Draw!";
				}
				_root.chessbg.movebar.txt.text = "黑(B) " + bgcnt[0] + "\t" + "白(W) " + bgcnt[1] + "\t\t" + winner;
			}*/
			chessbg.x = 50;
			chessbg.y = 50;
			var movebar:MovieClip = new MovieClip();
			var txt:TextField = new TextField;
			txt.width = 150;
			txt.height = 20;
			txt.x = 2;
			txt.y = 2;
			txt.autoSize = TextFieldAutoSize.LEFT;
			movebar.addChild(txt);
			movebar.x = -20;
			movebar.y = -20;
			movebar.graphics.lineStyle(1, 0x123483, 1);
			movebar.graphics.beginFill(0xC4FFFF, 100);
			movebar.graphics.moveTo(0, 0);
			movebar.graphics.lineTo(bgarray.length * boxwidth + 20, 0);
			movebar.graphics.lineTo(bgarray.length * boxwidth + 20, 20);
			movebar.graphics.lineTo(0, 20);
			movebar.graphics.lineTo(0, 0);
			movebar.graphics.endFill();
			movebar.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
			movebar.addEventListener(MouseEvent.MOUSE_UP, onRelease);
			chessbg.addChild(movebar);
			
			var boardbg:MovieClip = new MovieClip();
			txt = new TextField;
			txt.width = 100;
			txt.height = 20;
			txt.x = -15;
			txt.y = 5;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.selectable = false;
			txt.textColor = 0x0000FF;
			var tmp:String = "";
			for (var iii:int = 8; iii > 0; iii--) {
				tmp += iii + "\n\n";
			}
			txt.text = tmp;
			boardbg.addChild(txt);
			var txt2:TextField = new TextField;
			txt2.width = 100;
			txt2.height = 20;
			txt2.x = 10;
			txt2.y = bgarray.length * boxwidth;
			txt2.autoSize = TextFieldAutoSize.LEFT;
			txt2.selectable = false;
			txt2.textColor = 0x0000FF;
			txt2.text = "a         b        c        d        e         f        g         h";
			boardbg.addChild(txt2);
			boardbg.graphics.lineStyle(1, 0x123483, 0);
			boardbg.graphics.beginFill(0xF0FFFF, 100);
			boardbg.graphics.moveTo(-20, 0);
			boardbg.graphics.lineTo(bgarray.length * boxwidth, 0);
			boardbg.graphics.lineTo(bgarray.length * boxwidth, bgarray.length * boxwidth + 20);
			boardbg.graphics.lineTo(-20, bgarray.length * boxwidth + 20);
			boardbg.graphics.lineTo(-20, 0);
			boardbg.graphics.endFill();
			chessbg.addChild(boardbg);
			
			var savebtn:MovieClip = new MovieClip();
			savebtn.x = bgarray.length * boxwidth - 50;
			savebtn.y = -20;
			txt = new TextField;
			txt.width = 100;
			txt.height = 20;
			txt.x = 0;
			txt.y = 0;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.textColor = 0x0000FF;
			txt.text = "S";
			savebtn.addChild(txt);
			savebtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			savebtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			savebtn.addEventListener(MouseEvent.CLICK, onSave);
			chessbg.addChild(savebtn);
			
			var loadbtn:MovieClip = new MovieClip();
			loadbtn.x = bgarray.length * boxwidth - 35;
			loadbtn.y = -20;
			txt = new TextField;
			txt.width = 100;
			txt.height = 20;
			txt.x = 0;
			txt.y = 0;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.textColor = 0x0000FF;
			txt.text = "L";
			loadbtn.addChild(txt);
			loadbtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			loadbtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			loadbtn.addEventListener(MouseEvent.CLICK, loadfun);
			chessbg.addChild(loadbtn);
			
			var minimize:MovieClip = new MovieClip();
			minimize.x = bgarray.length * boxwidth - 15;
			minimize.y = -15;
			minimize.graphics.lineStyle(1, 0x123483, 1);
			minimize.graphics.beginFill(0xF0FFF, 100);
			minimize.graphics.moveTo(0, 0);
			minimize.graphics.lineTo(10, 0);
			minimize.graphics.lineTo(5, 7);
			minimize.graphics.lineTo(0, 0);
			minimize.graphics.endFill();
			minimize.addEventListener(MouseEvent.CLICK, minimizefun);
			minimizeflag = 1;
			chessbg.addChild(minimize);
			
			var resetbtn:MovieClip = new MovieClip();
			resetbtn.x = -14;
			resetbtn.y = bgarray.length * boxwidth + 5;
			resetbtn.graphics.lineStyle(1, 0x123483, 1);
			resetbtn.graphics.beginFill(0xFF0FFF, 100);
			resetbtn.graphics.moveTo(5, 10);
			resetbtn.graphics.curveTo(10, 10, 10, 5);
			resetbtn.graphics.curveTo(10, 0, 5, 0);
			resetbtn.graphics.curveTo(0, 0, 0, 5);
			resetbtn.graphics.curveTo(0, 10, 5, 10);
			resetbtn.graphics.endFill();
			resetbtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			resetbtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			resetbtn.addEventListener(MouseEvent.CLICK, initial);
			chessbg.addChild(resetbtn);
			
			initial();
			addChild(chessbg);
		}
		private function initial(e:MouseEvent=null):void {
			score = new Array(0, 0);
			player = 1;
			var mc:MovieClip;
			var colortmp:int;
			TextField(MovieClip(chessbg.getChildAt(0)).getChildAt(0)).text = labelarr[(player + 1) / 2] + "走(Go)";
			for (var bi:int = 0; bi < bgarray.length; bi++) {
				bgarray[bi] = new Array(8);
				for (var bj:int = 0; bj < bgarray[bi].length; bj++) {
					mc = new MovieClip;
					bgarray[bi][bj] = {mc:mc, bg:0, mcdepth:0};
					
					//.createEmptyMovieClip(bi * 8 + bj, bi * 8 + bj + 10088);
					mc.graphics.lineStyle(1, 0x0, 0);
					if (bi % 2 == 0) {
						colortmp = bj % 2;
					} else {
						colortmp = 1 - bj % 2;
					}
					mc.graphics.beginFill(colorarr[colortmp], 100);
					mc.graphics.moveTo(bi * boxwidth, bj * boxwidth);
					mc.graphics.lineTo((bi + 1) * boxwidth, bj * boxwidth);
					mc.graphics.lineTo((bi + 1) * boxwidth, (bj + 1) * boxwidth);
					mc.graphics.lineTo(bi * boxwidth, (bj + 1) * boxwidth);
					mc.graphics.lineTo(bi * boxwidth, bj * boxwidth);
					mc.graphics.endFill();
					
					bgarray[bi][bj].bg = 0;
					bgarray[bi][bj].mcdepth = 0;
					
					var boardbg:MovieClip = MovieClip(chessbg.getChildAt(1));
					boardbg.addChild(mc);
				}
			}
			var chessmans:MovieClip = new MovieClip;
			chessbg.addChild(chessmans);
			//depth = 12345;
			//y1 = 0, y2 = 0, y3 = 0, y4 = 0;
			for (var i:int = -1; i < 2; i += 2) {
				chessman(i * 5, 0, 3.5 * i + 3.5);
				chessman(i * 4, 1, 3.5 * i + 3.5);
				chessman(i * 3, 2, 3.5 * i + 3.5);
				chessman(i * 2, 3, 3.5 * i + 3.5);
				chessman(i * 1, 4, 3.5 * i + 3.5);
				chessman(i * 3, 5, 3.5 * i + 3.5);
				chessman(i * 4, 6, 3.5 * i + 3.5);
				chessman(i * 5, 7, 3.5 * i + 3.5);
				//chessman(i * 6, 2, -2.5 * i + 3.5);
				for (var j:int = 0; j < 8; j++) {
					chessman(i * 6, j, 2.5 * i + 3.5);
				}
			}
			//var date = new Date();
			//_root.recordtxt.text = date.toString().substr(0, 16) + newline;
			//_root.recordtxt.scroll = _root.recordtxt.maxscroll;
		}
		
		private function onPress(e:MouseEvent):void {
			var mc:MovieClip = e.currentTarget as MovieClip ;
			chessbg.startDrag(false);
		};
		
		private function onRelease(e:MouseEvent):void {
			var mc:MovieClip = e.currentTarget as MovieClip;
			chessbg.stopDrag();
		};
		
		private function onRollOver(e:MouseEvent):void {
			var mc:MovieClip = e.currentTarget as MovieClip;
			var rolltxt:TextField = new TextField;
			rolltxt.width = 100;
			rolltxt.height = 20;
			rolltxt.x = mc.x;
			rolltxt.y = -20;
			rolltxt.text = "Save";
			rolltxt.autoSize = TextFieldAutoSize.LEFT;
			rolltxt.background = true;
			rolltxt.textColor = 0xff0000;
			mc.addChild(rolltxt);
		}
		
		private function onRollOut(e:MouseEvent):void {
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.removeChildAt(1);
		}
		
		private function minimizefun(e:MouseEvent):void {
			minimizeflag = int(!minimizeflag);
			var torf:Boolean = minimizeflag == 1 ? true : false;
			var boardbg:MovieClip = chessbg.getChildAt(1) as MovieClip;
			boardbg.visible = torf;
			var resetbtn:MovieClip = chessbg.getChildAt(5) as MovieClip;
			resetbtn.visible = torf;
			var chessmans:MovieClip = chessbg.getChildAt(6) as MovieClip;
			chessmans.visible = torf;
		}
		
		private function onSave(e:MouseEvent):void {
			/*var saveso = new SharedObject();
			saveso = SharedObject.getLocal("chesscookie");
			trace(saveso);
			saveso.clear();
			saveso.data.recordtxt = _root.recordtxt.text;
			saveso.flush();*/
		}
		
		private function loadfun(e:MouseEvent):void {
			/*_root.chessbg.createTextField("readtxt", 33334, this._x + 50, this._y + 21, 80, 20);
			_root.chessbg.readtxt.selectable = false;
			_root.chessbg.readtxt.autoSize = true;
			_root.chessbg.readtxt.background = true;
			_root.chessbg.readtxt.multiline = true;
			_root.chessbg.readtxt.text = "输入棋谱文件名（以问号结尾）" + newline + "直接输入问号为读取Cookie棋谱" + newline + "——————  请选择步进速度" + newline + " ";
			_root.chessbg.createTextField("filetxt", 33335, this._x + 50, this._y, _root.chessbg.readtxt._width, 20);
			_root.chessbg.filetxt.background = true;
			Selection.setFocus(_root.chessbg.filetxt);
			_root.chessbg.filetxt.type = "input";
			_root.chessbg.filetxt.border = true;
			_root.chessbg.filetxt.onChanged = function() {
				if (this.text.charAt(this.text.length - 1) == "?") {
					var txtstr = this.text.substr(0, this.text.length - 1);
					for (var si = 0; si < txtstr.length; si++) {
						if (txtstr.substr(si, 2) == ":\\") {
							txtstr = txtstr.substr(0, si) + "://" + txtstr.substr(si + 2);
						}
						if (txtstr.charAt(si) == "\\") {
							txtstr = txtstr.substr(0, si) + "/" + txtstr.substr(si + 1);
						}
					}
					trace(txtstr);
					_root.chessbg.filetxt.removeTextField();
					_root.chessbg.readtxt.removeTextField();
					if (txtstr != "") {
						lv = new LoadVars();
						lv.load(txtstr);
						lv.onLoad = function() {
							trace(unescape(this));
							_root.loadsteps(unescape(this));
						};
					} else {
						var saveso = new SharedObject();
						saveso = SharedObject.getLocal("chesscookie");
						trace(saveso.data.recordtxt);
						_root.loadsteps(saveso.data.recordtxt);
					}
				}
			}*/
		}
		
		private function chessman(color:int, x:int, y:int):void {
			bgarray[x][y].bg = color;
			//bgarray[x][y].mcdepth = depth;
			var size:Number = 2 / 3;
			
			/*_root.chessbg.chessmans.attachMovie("chessman", depth, depth);
			_root.chessbg.chessmans[depth]._x = (x + .5) * boxwidth;
			_root.chessbg.chessmans[depth]._y = (y + .5) * boxwidth;
			_root.chessbg.chessmans[depth]._xscale = 60;
			_root.chessbg.chessmans[depth]._yscale = 60;
			_root.chessbg.chessmans[depth].useHandCursor = false;
			_root.chessbg.chessmans[depth].color = color;
			_root.chessbg.chessmans[depth].gotoAndStop(Math.abs(color));
			bbb = color < 0 ? '11' : '111';
			newcolor = new Color(_root.chessbg.chessmans[depth]);
			myColorTransform = new Object();
			myColorTransform = {ra:'100', rb:bbb, ga:'100', gb:bbb, ba:'100', bb:bbb, aa:'100', ab:'100'};
			newcolor.setTransform(myColorTransform);
			//_root.chessbg.chessmans[depth].onPress = _root.onpress;
			//_root.chessbg.chessmans[depth].onRelease = _root.onrelease;
			depth++;*/
		}
	}
	
}