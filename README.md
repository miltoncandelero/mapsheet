# Mapsheet

Essentially Mapsheet is an library that turns an spritesheet (or an image atlas) into an animation.

_(Mapsheet is my implementation of the [Spritesheet](https://github.com/skylarkstudio/spritesheet) but taking advantage of OpenFL's Tilemap class.)_

## Demo

I owe you a demo. <3

## Installation

To install a release build:
	
	haxelib install mapsheet

To include Tilemap in an OpenFL project, add `<haxelib name="mapsheet" />` to your project.xml.

## Usage

First make sure you have all your imports in place:
```haxe
import mapsheet.Animation;
import mapsheet.Mapsheet;
import mapsheet.data.Behavior;
```

Load your spritesheet:
```haxe
var mapsheet = new Mapsheet(Assets.getBitmapData("img/your_spritesheet.png"));
```

Quickly slice your spritesheet for equally sized ready to use frames:
```haxe
// rows, columns
mapsheet.slice(7, 8);
```

Or you can add the frames manually, make frames different size, offset them!
```haxe
// origX, origY, width, height, offsetX, offsetY
mapsheet.addFrame(0, 0, 100, 100, 50, 50);
mapsheet.addFrame(100, 0, 200, 300, 0, 0);
mapsheet.addFrame(300, 0, 50, 50, 100, 100);
```

Write the behavior
```haxe
//name, frames, looping?, frameRate
mapsheet.addBehavior( new Behavior("idle", [3, 4, 5], false, 15) );
```

Create your animation
```haxe
var animated:Animation = new Animation(mapsheet);
addChild( animated );
```

Tell your animation what behavior to play
```haxe
animated.showBehavior("stand");
```

Finally, remember to update the animation and tell it how many time has passed since your last updated it.
```haxe
private function onEnterFrame(e:Event):Void
{
 var time = Lib.getTimer();
 var delta = time - lastTime;
 animated.update(delta);
 lastTime = time;
}
```
