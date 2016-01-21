package gear.socket {
	public class SocketData {
		private var _name : String;
		private var _host : String;
		private var _port : int;
		private var _falg : int;

		public function SocketData(name : String, host : String, port : int, flag : int = 0) {
			_name = name;
			_host = host;
			_port = port;
			_falg = flag;
		}

		public function get name() : String {
			return _name;
		}

		public function get host() : String {
			return _host;
		}

		public function get port() : int {
			return _port;
		}

		public function get flag() : int {
			return _falg;
		}

		public function equals(data : SocketData) : Boolean {
			return _name == data.name && _host == data.host && _port == data.port;
		}

		public function toString() : String {
			return _name + "scoket://" + _name + ":" + _host;
		}
	}
}
