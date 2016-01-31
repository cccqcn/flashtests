package 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.net.ServerSocket;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.Socket;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;

	public class Main extends Sprite
	{
		private var addID:TextField;
		private var addPort:TextField;
		private var systemBuff:TextField;
		private var peopNum:TextField;
		private var socketServer:ServerSocket;
		private var chientSocket:Array;
		private var xml:XML;
		public function Main()
		{
			xml = <cross-domain-policy> 
			<allow-access-from domain="*" to-ports="*" /> 
			</cross-domain-policy>;

			chientSocket = new Array  ;
			setUI();
			socketServer = new ServerSocket();
			start_but.addEventListener(MouseEvent.CLICK,socketInit);

			//监听连接上的客户端;
			socketServer.addEventListener(ServerSocketConnectEvent.CONNECT,connet);
		}


		//客户端上线监听
		private function connet(e:ServerSocketConnectEvent):void
		{
			var socket:Socket = e.socket as Socket;
			chientSocket.push({"obj":socket,"uname":""});
			socket.addEventListener(Event.CLOSE,chientClose);
			socket.addEventListener(ProgressEvent.SOCKET_DATA,redClient);
			systemBuff.appendText("客户端上线:"+socket.remoteAddress+":"+socket.remotePort+"\n");
			resetPop();
			socket.writeUTFBytes("|欢迎进入Ks聊天室...\n | |"+xml);
			socket.flush();
		}

		private function redClient(e:ProgressEvent):void
		{

			var socket:Socket = e.target as Socket;
			var scokedata:ByteArray = new ByteArray  ;
			socket.readBytes(scokedata,0,0);
			var Str:String = String(scokedata);
			var StrArr:Array = new Array  ;
			StrArr = Str.split("|",Str.length);
			//trace(StrArr);
			var userList:String="-";
			
			for (var o:uint = 0; o < chientSocket.length; o++)
			{
				if (chientSocket[o].uname != null)
				{
					userList +=  chientSocket[o].uname + "-";
				}
			}
			trace(userList);





			if (StrArr[0] != "")
			{
				for (var i:uint = 0; i < chientSocket.length; i++)
				{
					chientSocket[i].obj.writeUTFBytes(StrArr[0]+"|"+StrArr[1]+"|"+StrArr[2]+"|"+chientSocket.length+"|"+userList);
					chientSocket[i].obj.flush();
				}
			}
			else if (StrArr[0] == "")
			{
				chientSocket[chientSocket.length - 1].uname = StrArr[1];
				for (var j:uint = 0; j<chientSocket.length; j++)
				{
					//trace(chientSocket[j].uname);
				}
			}


		}

		//客户端关闭监听;
		private function chientClose(e:Event):void
		{
			var socket:Socket = e.target as Socket;
			for (var i:uint = 0; i<chientSocket.length; i++)
			{
				if (chientSocket[i].obj == e.target)
				{
					chientSocket.splice(i,1);
					systemBuff.appendText("客户端下线:"+socket.remoteAddress+":"+socket.remotePort+"\n");
					resetPop();
					break;
				}
			}
		}



		//绑定服务器ip,和端口;
		private function socketInit(e:MouseEvent):void
		{
			if (socketServer.bound)
			{
				socketServer.close();
				socketServer = new ServerSocket();
			}
			else
			{
				socketServer.bind(int(addPort.text),addID.text);
				systemBuff.appendText("服务端启动成功------绑定服务端IP和端口:"+socketServer.localAddress+":"+socketServer.localPort+"\n");
				socketServer.listen();
			}
		}

		//刷新当前人数
		private function resetPop():void
		{
			peopNum.text = String(chientSocket.length);
		}










		private function setUI():void
		{
			addID = new TextField();
			addID.textColor = 0xB7B7B7;
			addID.type = TextFieldType.INPUT;
			addID.x = 168;
			addID.y = 20;
			addID.width = 110;
			addID.height = 20;
			addID.text = "127.0.0.1";
			addChild(addID);

			addPort = new TextField();
			addPort.textColor = 0xB7B7B7;
			addPort.type = TextFieldType.INPUT;
			addPort.x = 329;
			addPort.y = 20;
			addPort.width = 70;
			addPort.height = 20;
			addPort.text = "9999";
			addChild(addPort);

			peopNum = new TextField();
			peopNum.textColor = 0xB7B7B7;
			peopNum.x = 395;
			peopNum.y = 82;
			peopNum.width = 32;
			peopNum.height = 18;
			peopNum.autoSize = "center";
			peopNum.text = "0";
			addChild(peopNum);

			systemBuff = new TextField();
			systemBuff.textColor = 0x666666;
			systemBuff.x = 112;
			systemBuff.y = 103;
			systemBuff.width = 327;
			systemBuff.height = 241;
			systemBuff.mouseWheelEnabled = true;
			systemBuff.wordWrap = true;
			addChild(systemBuff);
		}

	}

}