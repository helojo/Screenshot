Screenshot
==========

[![Build Status](https://travis-ci.org/johnikx/Screenshot.svg?branch=master)](https://travis-ci.org/johnikx/Screenshot)

Screenshot is the ActionScript 3 util for integration testing of UI components. It perfectly works with FlexUnit testing flow and Flex Framework UI components.

> Flash has one special ability - output always looks the same.

Fast, lightweight and easy to use
---------------------------------

```as3
[Test(async, ui)]
public function defaultColor():void
{
	var component:Square = new Square();
	Async.proceedOnEvent(this, component, Event.ADDED);
    UIImpersonator.addChild(component);
	
	// this is the line!
	assertTrue(Screenshot.compare("SquareTest.defaultColor", component));
}
```

Setup
-----

At first of all you have to set the `ScreenShot.dictionary` property, which is a simple key value storage. It includes fixtures, expected states of your UI components. You can fill it manually:

```as3
[Embed(source="SquareTest.defaultColor.png")]
private var SquareWithDefaultColor:Class;
...
Screenshot.dictionary = {};
Screenshot.dictionary["SquareTest.defaultColor"] = Bitmap(new SquareWithDefaultColor()).bitmapData;
```

or, which is much better and prefered way, use the `LoadQueue`, which loads fixtures at runtime:

```as3
var queue:LoadQueue = new LoadQueue("../fixtures/");
	queue.addEventListener(Event.COMPLETE, function(event:Event):void
	{
		Screenshot.dictionary = queue.dictionary;
	});
	// list of fixtures, which will be loaded (name is without any extension!)
	queue.load(new <String>["SquareTest.defaultColor"]);
```

Then you have to set the `Screenshot.save` property to new instance of the `Upload` class, which uploads the screenshot of an actual state of your UI component to the server:

```as3
Screenshot.save = new Upload("http://localhost/upload.php");
```

Now if you run your test case, it should fail, but the `SquareTest.defaultColor-actual.png` file should appear in your fixtures directory. If it looks as expected, you can mark it as a valid fixture. Just rename it - remove the `-actual` suffix from its name.

You've covered your ass, now!

> `Screenshot.save` is also used for saving a "diff between an actual and an expected state". It's really useful for debugging.

Known issues
------------

Sometimes you can see "Adobe Flash Player has stopped a potentially unsafe operation." error message when you run your test suite. To solve this, just add the swf file location to the trusted list in Adobe FlashPlayer Settings Manager in order to allow a local swf connect the internet.

Best practices
--------------

### Naming

The best is the following format `<TestClassName>.<TestMethodName>`

### Resizing

If you have to test sizable components (let's say bigger than 100px in any way), you should use `Resizer`, which resizes them to smaller version. It can save a lot of time needed to pixel by pixel comparsion:

```as3
Screenshot.resizer = new Resizer(100);
```

### .gitignore

```
*-actual.png
*-diff.png
```
