package
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.events.*;
    import flash.net.FileReference;
	import ghostcat.algorithm.traversal.AStar;
	import ghostcat.algorithm.traversal.Traversal;
    import com.bit101.components.*;

    public class Main extends Sprite
    {
        
        private var test:TestPath;
        private var ui:UI;
        
        private var f:FileReference;

        public function Main()
        {
            Style.embedFonts = false;
            Style.fontSize = 12;
            Style.LABEL_TEXT = 0x2b3d43;
            Style.BUTTON_FACE = 0xc7d0d5;
            init();
        }

        public function init():void {
            test = new TestPath;
            ui = new UI;
            addChild(ui);
            ui.grids.addChild(test);
            test.ui = ui;
            
            f = new FileReference;
            f.addEventListener(Event.COMPLETE, onLoad);
            f.addEventListener(Event.SELECT, onSelect);

            ui.resetbtn.addEventListener(MouseEvent.CLICK, resetbtn_clickHandler);
            ui.loadbtn.addEventListener(MouseEvent.CLICK, loadbtn_clickHandler);
            ui.btngo.addEventListener(MouseEvent.CLICK, findpath);
            ui.btn0.addEventListener(MouseEvent.CLICK, btn0_clickHandler);
            ui.btn1.addEventListener(MouseEvent.CLICK, btn1_clickHandler);
            ui.frombtn.addEventListener(MouseEvent.CLICK, frombtn_clickHandler);
            this.addEventListener(MouseEvent.MOUSE_UP, application1_mouseUpHandler);
        }


        protected function application1_mouseUpHandler(event:MouseEvent):void
        {
            if(test)
            {
                test.mouseflag = false;
            }
        }

        protected function findpath(event:MouseEvent):void
        {
			ui.pathstr.text = "click on the map to find path";
            settype(2);
            return;
        }

        protected function btn0_clickHandler(event:MouseEvent):void
        {
			ui.pathstr.text = "drag on the map to clear obstacles";
            settype(4);
        }

        protected function btn1_clickHandler(event:MouseEvent):void
        {
			ui.pathstr.text = "drag on the map to draw obstacles";
            settype(3);
        }

        protected function frombtn_clickHandler(event:MouseEvent):void
        {
			ui.pathstr.text = "click on the map to set start point";
            settype(5);
        }

        private function settype(t:int):void
        {
            test.setflag = t;
            ui.settype(t);
        }
        
        protected function resetbtn_clickHandler(event:MouseEvent):void
        {
            var wh:Array = ui.sizetxt.text.split("x");
            test.MAP_WIDTH = wh[0];
            test.MAP_HEIGHT = wh[1];
            Path.instance.bgXgrids = test.MAP_WIDTH;
            Path.instance.bgYgrids = test.MAP_HEIGHT;
            
			ui.pathstr.text = ui.level.value + "";
            test.reset(Number(ui.level.value));
            return;
        }

        protected function loadbtn_clickHandler(event:MouseEvent):void
        {
            f.browse();
        }

        private function onSelect(e:Event):void
        {
            f.load();
        }
        
        private function onLoad(e:Event):void
        {
            var str:String = f.data.readUTFBytes(f.data.length);
            var arr:Array = str.split("|");
            Path.instance.bgXgrids = arr[0];
            Path.instance.bgYgrids = arr[1];
            var datas:Array = String(arr[2]).split("");
            Path.instance.init(datas);
            test.MAP_WIDTH = arr[0];
            test.MAP_HEIGHT = arr[1];
            test.reset(0, datas);
        }
    }
}