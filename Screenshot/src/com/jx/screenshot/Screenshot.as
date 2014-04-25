/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package com.jx.screenshot
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;

	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class Screenshot
	{
		
		public static const CREATION:uint = 0;
		public static const COMPARISON:uint = 1;
		
		public static var dictionary:Object;
		public static var save:Save;
		public static var comparer:Comparer;
		public static var resizer:Resizer;
		public static var phase:uint = COMPARISON;
		
		public function Screenshot()
		{
			throw new IllegalOperationError("Can't be instantiated.");
		}
		
		public static function compare(name:String, component:DisplayObject):Boolean
		{
			checkPreconditions();
			comparer = comparer || new NativeComparer(save);
			resizer = resizer || new Resizer();
			
			var screenshot:BitmapData = new BitmapData(component.width, component.height);
				screenshot.draw(component);
			var resizedScreenshot:BitmapData = resizer.resize(screenshot);
			
			// for manual comparison
			save.save(name + "-actual", resizedScreenshot);
			
			if (phase == CREATION) {
				save.save(name, resizedScreenshot);
				return true;
			}
			
			var originalScreen:BitmapData = dictionary[name];
			
			return comparer.compare(name, originalScreen, resizedScreenshot);
		}
		
		private static function checkPreconditions():void
		{
			if (!dictionary) {
				throw new IllegalOperationError("You have to set the dictionary first.");
			}
			
			if (!save) {
				throw new IllegalOperationError("You have to set the save first.");
			}
		}
		
	}
}