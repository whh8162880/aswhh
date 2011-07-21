package
{
	import com.net.socket.SocketServer;
	import com.utils.InsertFunction;
	
	import flash.display.Sprite;
	
	public class WFrameWork extends Sprite
	{
		public function WFrameWork()
		{
			var socket:SocketServer = new SocketServer();
			socket.connect("127.0.0.1",1986);
		}
	}
}