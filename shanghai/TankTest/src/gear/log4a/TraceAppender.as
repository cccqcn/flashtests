package gear.log4a {
	/**
	 * trace日志输入源
	 * 
	 */
	public class TraceAppender extends Appender {
		public function TraceAppender() {
			super();
			_formatter = new SimpleLogFormatter();
		}

		/**
		 * @inheritDoc
		 */
		override public function append(data : LoggingData) : void {
			var message : String = _formatter.format(data, "");
			trace(message);
		}
	}
}