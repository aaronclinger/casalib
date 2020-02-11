/*
	CASA Lib for ActionScript 2.0
	Copyright (c) 2008, Aaron Clinger & Contributors of CASA Lib
	All rights reserved.
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
	
	- Redistributions of source code must retain the above copyright notice,
	  this list of conditions and the following disclaimer.
	
	- Redistributions in binary form must reproduce the above copyright notice,
	  this list of conditions and the following disclaimer in the documentation
	  and/or other materials provided with the distribution.
	
	- Neither the name of the CASA Lib nor the names of its contributors
	  may be used to endorse or promote products derived from this software
	  without specific prior written permission.
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.
*/

import org.casalib.core.CoreObject;
import org.casalib.time.Stopwatch;
import org.casalib.util.LoadUtil;
import org.casalib.util.ArrayUtil;
import org.casalib.util.ConversionUtil;
import org.casalib.load.base.BytesLoadInterface;
import org.casalib.load.base.BytesLoad;
import org.casalib.load.base.Load;

/**
	Calculates load speeds for individual watched files and remembers the values for comparison with other loads.

	@author Aaron Clinger
	@version 02/13/07
	@since Flash Player 7
	@example
		<code>
			this.createEmptyMovieClip("loadZone_mc", this.getNextHighestDepth());
			
			var mediaLoad:MediaLoad = new MediaLoad(this.loadZone_mc, "test.jpg");
			var bandwidth:BandwidthObserver = BandwidthObserver.observe(this.mediaLoad);
			
			function onImageLoadProgress(sender:MediaLoad, bytesLoaded:Number, bytesTotal:Number):Void {
				trace("File is loading at " + this.bandwidth.getKBps() + " kBps.");
			}
			
			this.mediaLoad.addEventObserver(this, MediaLoad.EVENT_LOAD_PROGRESS, "onImageLoadProgress");
			this.mediaLoad.start();
		</code>
	@usageNote This class only calculates kiloBYTES per seconds, not the bandwidth speed norm kilobits per second. Bits are not very useful in flash; flash only knows object's size in bytes so kBps is a much more useful number. If you need to find kbps or bits use {@link ConversionUtil} to convert the values.
*/

class org.casalib.load.BandwidthObserver extends CoreObject {
	private var $loadItem:Object;
	private var $stopwatch:Stopwatch;
	private var $kBps:Number;
	
	private static var $observedLoads: /*BandwidthObserver*/ Array;
	private static var $hasInit:Boolean;
	
	
	/**
		Defines load to observe and calculate the speed of transfer in kBps.
		
		@param loadItem: File to observe the request and download speed. Can be any class that inherits from {@link BytesLoadInterface} and dispatches events <code>"onLoadStart"</code>, <code>"onLoadProgress"</code> and <code>"onLoadError"</code>.
		@return Returns {@link BandwidthObserver} instance.
		@usageNote Loading file should be larger than 30kB and the load should last longer than two seconds to provide a valid value.
	*/
	public static function observe(loadItem:BytesLoadInterface):BandwidthObserver {
		if (!BandwidthObserver.$hasInit) {
			BandwidthObserver.$observedLoads = new Array();
			BandwidthObserver.$hasInit       = true;
		} else {
			var len:Number = BandwidthObserver.$observedLoads.length;
			while (len--)
				if (BandwidthObserver.$observedLoads[len].getLoadItem() == loadItem)
					return BandwidthObserver.$observedLoads[len];
		}
		
		var observer:BandwidthObserver = new BandwidthObserver(loadItem);
		BandwidthObserver.$observedLoads.push(observer);
		
		return observer;
	}
	
	/**
		@return Returns the average kBps of all observed loads.
	*/
	public static function getAverageKBps():Number {
		return ArrayUtil.average(BandwidthObserver.$getAllKBpsValues());
	}
	
	/**
		@return Returns the lowest/slowest kBps of all observed loads.
	*/
	public static function getLowestKBps():Number {
		return ArrayUtil.getLowestValue(BandwidthObserver.$getAllKBpsValues());
	}
	
	/**
		@return Returns the highest/fastest kBps of all observed loads.
	*/
	public static function getHighestKBps():Number {
		return ArrayUtil.getHighestValue(BandwidthObserver.$getAllKBpsValues());
	}
	
	private static function $getAllKBpsValues(): /*Number*/ Array {
		var len:Number = BandwidthObserver.$observedLoads.length;
		var kBps: /*Number*/ Array = new Array();
		var val:Number;
		
		while (len--) {
			val = BandwidthObserver.$observedLoads[len].getKBps();
			if (val != undefined)
				kBps.push(val);
		}
		
		return kBps;
	}
	
	
	private function BandwidthObserver(loadItem:BytesLoadInterface) {
		super();
		
		this.$stopwatch = new Stopwatch();
		
		this.$loadItem = loadItem;
		this.$loadItem.addEventObserver(this.$stopwatch, Load.EVENT_LOAD_START, 'start');
		this.$loadItem.addEventObserver(this, BytesLoad.EVENT_LOAD_PROGRESS, '$calculateKBps');
		this.$loadItem.addEventObserver(this, Load.EVENT_LOAD_ERROR, '$clean');
		
		this.$setClassDescription('org.casalib.load.BandwidthObserver');
	}
	
	/**
		@return returns the kBps of the specific load this instance is observing.
	*/
	public function getKBps():Number {
		return this.$kBps;
	}
	
	/**
		@return Returns the bytes load instance being observed.
	*/
	public function getLoadItem():Object {
		return this.$loadItem;
	}
	
	public function destroy():Void {
		this.$clean();
		
		ArrayUtil.removeArrayItem(BandwidthObserver.$observedLoads, this.$loadItem);
		
		this.$loadItem.removeEventObserversForScope(this);
		this.$loadItem.removeEventObserversForScope(this.$stopwatch);
		
		this.$stopwatch.destroy();
		
		delete this.$stopwatch;
		delete this.$loadItem;
		
		super.destroy();
	}
	
	private function $calculateKBps(sender:Object, bytesLoaded:Number, bytesTotal:Number):Void {
		this.$kBps = LoadUtil.calculateKBps(bytesLoaded, 0, this.$stopwatch.getTime());
	}
	
	private function $clean():Void {
		delete this.$kBps;
	}
}