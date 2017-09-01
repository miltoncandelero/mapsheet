package mapsheet.data;

/**
 * Keeps the id of the frame on the tilesheet and how to offset itself after placed. (For internal use. You shouldn't need to instantiate this class).
 * @author Milton Candelero
 */

class Frame
{
	
	public var id:Int;
	public var height:Int;
	public var width:Int;
	public var x:Int;
	public var y:Int;
	
	
	public function new (id: Int, x:Int = 0, y:Int = 0, width:Int = 0, height:Int = 0) {
		
		this.id = id;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}
}