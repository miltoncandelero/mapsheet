package mapsheet;

import mapsheet.data.Behavior;
import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.events.Event;

/**
 * ...
 * @author Milton Candelero
 */
class Animation extends Sprite
{

	public var canvas:Tilemap;
	public var tile:Tile;
	public var currentBehavior:Behavior;
	public var currentFrameIndex:Int;
	public var smoothing:Bool;
	public var spritesheet:Mapsheet;
	
	private var behaviorComplete:Bool;
	private var behaviorQueue:Array <Behavior>;
	private var behavior:Behavior;
	private var loopTime:Int;
	private var timeElapsed:Int;
	
	/**
	 * 
	 * @param	sheet Please setup your mapsheet with all the correct frames before instantiating this class.
	 * @param	smoothing
	 */
	public function new (sheet:Mapsheet, smoothing:Bool = false) {
		super ();
		
		this.smoothing = smoothing;
		this.spritesheet = sheet;
		
		behaviorQueue = new Array <Behavior> ();
		canvas = new Tilemap(sheet.tWidth, sheet.tHeight, sheet, smoothing);
		tile = new Tile( -1);
		canvas.addTile(tile);
		addChild (canvas);
	}
	
	/**
	 * When the current animation ends, it will run your behavior.
	 * @param	behavior The behavior to run when the current animation ends.
	 */
	public function queueBehavior (behavior:Dynamic):Void {
		
		var behaviorData = resolveBehavior (behavior);
		
		if (currentBehavior == null) {
			
			updateBehavior (behaviorData);
			
		} else {
			
			behaviorQueue.push (behaviorData);
			
		}
		
	}
	
	
	private function resolveBehavior (behavior:Dynamic):Behavior {
		
		if (Std.is (behavior, Behavior)) {
			
			return cast behavior;
			
		} else if (Std.is (behavior, String)) {
			
			if (spritesheet != null) {
				
				return spritesheet.behaviors.get (cast behavior);
				
			}
			
		}
		
		return null;
		
	}
	
	/**
	 * Shows a behavior
	 * @param	behavior The behavior you want to show
	 * @param	restart If the behavior you want to show is already showing: Should we restart it?
	 */
	public function showBehavior (behavior:Dynamic, restart:Bool = true):Void {
		
		behaviorQueue = new Array <Behavior> ();
		
		updateBehavior (resolveBehavior (behavior), restart);
		
	}
	
	/**
	 * Shows a list of behaviors one after the other.
	 * @param	behaviors
	 */
	public function showBehaviors (behaviors:Array <Dynamic>):Void {
		
		behaviorQueue = new Array <Behavior> ();
		
		for (behavior in behaviors) {
			
			behaviorQueue.push (resolveBehavior (behavior));
			
		}
		
		if (behaviorQueue.length > 0) {
			
			updateBehavior (behaviorQueue.shift ());
			
		}
		
	}
	
	/**
	 * Updates the animation. If you don't call this, your animation stays frozen.
	 * @param	deltaTime The time in miliseconds from the last frame. (It's an INT in miliseconds because that is what Lib.getTimer uses).
	 */
	public function update (deltaTime:Int):Void {
		
		if (!behaviorComplete) {
			
			timeElapsed += deltaTime;
			
			var ratio = timeElapsed / loopTime;
			
			if (ratio >= 1) {
				
				if (currentBehavior.loop) {
					
					ratio -= Math.floor (ratio);
					
				} else {
					
					behaviorComplete = true;
					ratio = 1;
					
				}
				
			}
			
			currentFrameIndex = Math.round (ratio * (currentBehavior.frames.length - 1));
			
			var frame = spritesheet.getFrame (currentBehavior.frames [currentFrameIndex]);
			
			tile.id = frame.id;
			tile.x = frame.x;
			tile.y = frame.y;
			
			if (behaviorComplete) {
				
				if (behaviorQueue.length > 0) {
					
					updateBehavior (behaviorQueue.shift ());
					
				} else if (hasEventListener (Event.COMPLETE)) {
					
					dispatchEvent (new Event (Event.COMPLETE));
					
				}		
				
			}
			
		}
		
	}
	
	
	private function updateBehavior (behavior:Behavior, restart:Bool = true):Void {
		
		if (behavior != null) {
			
			if (restart || behavior != currentBehavior) {
				
				currentBehavior = behavior;
				timeElapsed = 0;
				behaviorComplete = false;
				
				loopTime = Std.int ((behavior.frames.length / behavior.frameRate) * 1000);
				
				if (tile.id == -1) {
					
					update (0);
					
				}
				
			}
			
		} else {
			
			tile.id = -1;
			currentBehavior = null;
			currentFrameIndex = -1;
			behaviorComplete = true;
			
		}
		
	}
	
}