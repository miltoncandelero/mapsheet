package mapsheet.data;

/**
 * A behavior has the list of frames and how said frames are to be shown.
 * @author Milton Candelero
 */
class Behavior
{
	public var frameRate:Int;
	public var frames:Array <Int>;
	public var loop:Bool;
	public var name:String;
	
	private static var uniqueID:Int = 0;
	
	/**
	 * 
	 * @param	name The name of this behavior
	 * @param	frames The array of frame numbers that compose this behavior
	 * @param	loop Should this behavior loop forever? (WARNING: Looping behaviors never trigger the "onComplete" event!)
	 * @param	frameRate How many frames per second should we show?
	 */
	public function new (name:String = "", frames:Array <Int>, loop:Bool = false, frameRate:Int = 30) {
		
		if (name == "") {
			
			name = "behavior" + (uniqueID++);
			
		}
		if (frames == null) {
			
			frames = [];
			
		}
		
		this.name = name;
		this.frames = frames;
		this.loop = loop;
		this.frameRate = frameRate;
	}
}