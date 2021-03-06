/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package com.jx.screenshot
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class LoadQueue extends EventDispatcher
	{
		
		private var fixturesLocation:String;
		private var queue:Vector.<String>;
		private var _dictionary:Object;
		private var extension:String;
		private var loader:Loader;
		private var index:uint;
		
		public function LoadQueue(fixturesLocation:String, extension:String = "png")
		{
			this.fixturesLocation = fixturesLocation;
			this.extension = extension;
		}
		
		public function get dictionary():Object
		{
			if (!_dictionary) {
				throw new IllegalOperationError("You have to call load method first.");
			}
			
			return _dictionary;
		}
		
		public function load(screenshots:Vector.<String>):void
		{
			if (!screenshots) {
				throw new ArgumentError("Screenshots argument can't be null.");
			}
			
			queue = queue || new Vector.<String>();
			merge(screenshots);
			_dictionary = {};
			
			if (queue.length == 0) {
				done();
			} else if (!loader) {
				start();
			}
		}
		
		private function merge(screenshots:Vector.<String>):void
		{
			var screenshotsLength:uint = screenshots.length;
			
			for (var i:uint = 0; i < screenshotsLength; i++) {
				if (queue.indexOf(screenshots[i]) == -1) {
					queue.push(screenshots[i]);
				}
			}
		}
		
		private function start():void
		{
			index = 0;
			createLoader();
			loadBitmap();
		}
		
		private function createLoader():void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
		}
		
		private function destroyLoader():void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loader_completeHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			loader = null;
		}
		
		private function loader_completeHandler(event:Event):void
		{
			saveAndLoadNext(Bitmap(loader.content).bitmapData);
		}
		
		private function loader_errorHandler(event:Event):void
		{
			saveAndLoadNext(null);
		}
		
		private function loadBitmap():void
		{
			var file:String = fixturesLocation + queue[index] + "." + extension;
			loader.load(new URLRequest(file));
		}
		
		private function unloadBitmap():void
		{
			loader.unload();
		}
		
		private function saveAndLoadNext(data:BitmapData):void
		{
			var name:String = queue[index];
			_dictionary[name] = data;
			unloadBitmap();
			loadNext();
		}
		
		private function loadNext():void
		{
			index++;
			
			if (index < queue.length) {
				loadBitmap();
			} else {
				destroyLoader();
				done();
			}
		}
		
		private function done():void
		{
			queue = null;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}