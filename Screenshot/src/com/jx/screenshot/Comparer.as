/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package com.jx.screenshot
{
	import flash.display.BitmapData;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public interface Comparer
	{
		
		function compare(name:String, original:BitmapData, actual:BitmapData):Boolean;
		
	}
	
}