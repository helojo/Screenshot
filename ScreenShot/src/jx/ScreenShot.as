/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package jx
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;

	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class ScreenShot
	{
		
		public static const CREATION:uint = 0;
		public static const COMPARE:uint = 1;
		
		public static var dictionary:Object;
		public static var save:Save;
		public static var phase:uint = COMPARE;
		
		public function ScreenShot()
		{
			throw new IllegalOperationError("Can't be instantiated.");
		}
		
		public static function compare(name:String, component:DisplayObject):Boolean
		{
			checkPreconditions();
			
			var screen:BitmapData = new BitmapData(component.width, component.height);
				screen.draw(component);
			
			// for manual compare
			save.save(name + "-actual", screen);
			
			if (phase == CREATION) {
				save.save(name, screen);
				return true;
			}
			
			var originalScreen:BitmapData = dictionary[name];
			
			if (!originalScreen) {
				return false;
			}
			
			var diff:Object = originalScreen.compare(screen);
			
			if (diff == 0) {
				// same
				return true;
			} else if (diff == -3 || diff == -4) {
				return false;
			} else if (diff is BitmapData) {
				// for manual compare (diff)
				save.save(name + "-diff", BitmapData(diff));
				return false;
			}
			
			return false;
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