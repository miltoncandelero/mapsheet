package mapsheet;

import mapsheet.data.Behavior;
import mapsheet.data.Frame;
import openfl.display.BitmapData;
import openfl.display.Tileset;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * This contains the bitmap and the information on how to slice said bitmap.
 * @author Milton Candelero
 */

class Mapsheet extends Tileset {
	
	public var behaviors:Map <String, Behavior>;
	public var name:String;
	public var totalFrames:Int;
	public var tWidth(default, null):Int;
	public var tHeight(default, null):Int;
	private var frames:Array <Frame>;
	
	public function new (image:BitmapData)
	{
		super(image);
		this.behaviors = new Map <String, Behavior> ();
		this.frames = new Array <Frame> ();
		this.totalFrames = 0;
	}
	
	/**
	 * Makes frames of the same size in a grid pattern. Numeration increases from left to right and top to bottom. 
	 * (WARNING: This will delete any preexisting frames you have manually added!)
	 * @param	columns How many columns does your grid has?
	 * @param	rows How many rows does your grid has?
	 * @param	tileWidth How many pixels wide is each tile?
	 * @param	tileHeight How many pixels high is each tile?
	 */
	public function slice(columns:Int, rows:Int, ?tileWidth:Null<Int>, ?tileHeight:Null<Int>) {
		
		this.frames = new Array <Frame> ();
		this.totalFrames = columns * rows;
		
		
		
		if (tileWidth == null) {
			tileWidth = Std.int(this.bitmapData.width / columns);
		}	
		this.tWidth = tileWidth;
		
		if (tileHeight == null) {
			tileHeight = Std.int(this.bitmapData.height / rows);
		}
		this.tHeight = tileHeight;
		
		for (i in 0...rows) 
		{
			for (j in 0...columns) 
			{
				this.frames.push(new Frame(addRect(new Rectangle(j * tileWidth, i * tileHeight, tileWidth, tileHeight)),0,0,tileWidth,tileHeight));
			}
		}
	}
	
	
	public function addBehavior (behavior:Behavior):Void {
		
		behaviors.set (behavior.name, behavior);
	}	
	
	
	public function getFrame (index:Int):Frame {
		
		var frame = frames[index];
		
		if (frame == null) {
			throw "mapsheet error: '"+index+"' Frame out of range. (You probably have a behavior that references a wrong tile index)";
		}
		
		return frame;
	}
	
	/**
	 * This function allows you to add frames of different sizes and set the drawing offset for each one.
	 * Due to how Tilemap works, nothing outside of tilemap is drawn and while I can extend the Tilemap size to make any positive offset work, I can not make negative offsets work. Sorry
	 * @param	startx Pick a point in your spritesheet as the leftmost point for your frame.
	 * @param	starty Pick a point in your spritesheet as the topmost point for your frame.
	 * @param	width How many pixels wide is this frame?
	 * @param	height How many pixels high is this frame?
	 * @param	offsetx When drawing this frame: Should we move it from the right a bit? (WARNING: This doesn't accept negatives. Try offsetting everything else into the positive.)
	 * @param	offsety When drawing this frame: Should we move it from the top a bit? (WARNING: This doesn't accept negatives. Try offsetting everything else into the positive.)
	 * @return	The frame number for this new frame. You will need it when creating a behavior.
	 */
	public function addFrame(startx:Int, starty:Int, width:Int, height:Int,offsetx:Int,offsety:Int):Int
	{
		if (offsetx<0 || offsety <0) 
		{
			throw "mapsheet error: Frame offsets cant be negative.";
		}
		
		if (this.tWidth <= width + offsetx) this.tWidth = width + offsetx;
		if (this.tHeight <= height + offsety) this.tHeight = height + offsety;
		
		var f:Frame = new Frame(addRect(new Rectangle(startx, starty, width, height)), offsetx, offsety, width, height);
		this.frames.push(f);
		totalFrames++;
		
		return f.id;
	}
}