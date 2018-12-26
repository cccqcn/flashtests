package
{
    import flash.display.Sprite;
    import flash.events.*;
    import flash.utils.*;
    import flash.net.FileReference;
    import com.bit101.components.*;
	
	public class UI extends Sprite 
	{ 
        private var fromp:int;
        private var setflag:int;

        public var grids:Component;
        public var btn0:PushButton;
        public var btn1:PushButton;
        public var frombtn:PushButton;
        public var btngo:PushButton;
        public var loadbtn:PushButton;
        private var savebtn:PushButton;
        public var resetbtn:PushButton;
        private var sizebtn:PushButton;
        public var pathstr:TextArea;
        public var startpos:InputText;
        public var endpos:InputText;
        public var currentpos:InputText;
        public var sizetxt:InputText;
        public var timetxt:Label;
        public var abtn:CheckBox;
        public var modifybtn:CheckBox;
        public var level:HSlider;
        
        public function UI()
        {
            grids = new Component(this, 41, 135);
            btn0 = new PushButton(this, 455, 9, "0");
            btn0.setSize(30, 20);
            btn0.toggle = true;
            btn1 = new PushButton(this, 493, 9, "1");
            btn1.setSize(30, 20);
            btn1.toggle = true;
            loadbtn = new PushButton(this, 41, 36, "Load");
            loadbtn.setSize(50, 20);
            savebtn = new PushButton(this, 102, 36, "Save");
            savebtn.setSize(50, 20);
            resetbtn = new PushButton(this, 350, 9, "Reset");
            resetbtn.setSize(50, 20);
            frombtn = new PushButton(this, 199, 37, "From");
            frombtn.setSize(50, 20);
            frombtn.toggle = true;
            btngo = new PushButton(this, 41, 9, "Go");
            btngo.setSize(50, 20);
            btngo.toggle = true;
            sizebtn = new PushButton(this, 96, 9, "45x20");
            sizebtn.setSize(40, 20);
            pathstr = new TextArea(this, 41, 63, "");
            pathstr.setSize(701, 60);
            startpos = new InputText(this, 345, 36, "");
            startpos.setSize(50, 20);
            endpos = new InputText(this, 455, 36, "");
            endpos.setSize(50, 20);
            currentpos = new InputText(this, 670, 36, "");
            currentpos.setSize(50, 20);
            sizetxt = new InputText(this, 175, 9, "10x8");
            sizetxt.setSize(50, 20);
            abtn = new CheckBox(this, 560, 14, "A*");
            modifybtn = new CheckBox(this, 610, 14, "modify");
            level = new HSlider(this, 295, 14);
            level.setSize(50, 12);
            level.setSliderParams(0, 1, 0.3);

            new Label(this, 141, 11, "SIZE：");
            new Label(this, 235, 11, "DENSITY：");
            new Label(this, 412, 11, "EDIT：");
            new Label(this, 290, 39, "START：");
            new Label(this, 410, 39, "END：");
            new Label(this, 600, 39, "CURRENT：");

            sizetxt.text = Path.instance.bgXgrids + "x" + Path.instance.bgYgrids;
            
            sizebtn.addEventListener(MouseEvent.CLICK, sizebtn_clickHandler);
            savebtn.addEventListener(MouseEvent.CLICK, savebtn_clickHandler);
        }
        
        public function settype(value:int):void
        {
            setflag = value;
            btn1.selected = false;
            btn0.selected = false;
            btngo.selected = false;
            frombtn.selected = false;
            if(value == 3)
            {
                btn1.selected = true;
            }
            if(value == 4)
            {
                btn0.selected = true;
            }
            if(value == 2)
            {
                btngo.selected = true;
            }
            if(value == 5)
            {
                frombtn.selected = true;
            }
        }
        

        protected function sizebtn_clickHandler(event:MouseEvent):void
        {
            sizetxt.text = "45x20";
        }


        protected function savebtn_clickHandler(event:MouseEvent):void
        {
            var str:String = Path.instance.bgXgrids + "|" + Path.instance.bgYgrids + "|";
            str += Path.instance.datas.join("");
            var barr:ByteArray = new ByteArray;
            barr.writeUTFBytes(str);
            var f:FileReference = new FileReference;
            f.save(barr, "pathdata.txt");
        }
    }
}