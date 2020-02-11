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

import org.casalib.event.EventDispatcher;
import org.casalib.load.base.LoadInterface;
import org.casalib.load.base.BytesLoadInterface;
import org.casalib.load.base.BytesLoad;
import org.casalib.math.Percent;

/**
	Allows multiple loads to be treated as one larger load item.
	
	@author Aaron Clinger
	@version 06/08/07
	@example
		<code>
			var xmlLoad:XmlLoad = new XmlLoad("test.xml");
			var imageLoad:MediaLoad = new MediaLoad(this.loadZone_mc, "test.jpg");
			
			var myLoadGroup = new LoadGroup();
			this.myLoadGroup.addLoad(this.xmlLoad);
			this.myLoadGroup.addLoad(this.imageLoad);
			this.myLoadGroup.addEventObserver(this, LoadGroup.EVENT_LOAD_PERCENT, "onGroupLoadPercent");
			this.myLoadGroup.addEventObserver(this, LoadGroup.EVENT_LOAD_ERROR, "onGroupLoadError");
			
			function onGroupLoadPercent(sender:LoadGroup, progress:Percent):Void {
				trace("My group is " + progress.getPercentage() + "% loaded.");
			}
			
			function onGroupLoadError(sender:LoadGroup, failedLoad:BytesLoadInterface):Void {
				this.myLoadGroup.removeLoad(failedLoad);
				this.myLoadGroup.start();
			}
			
			this.myLoadGroup.start();
		</code>
*/

class org.casalib.load.LoadGroup extends EventDispatcher implements LoadInterface {
	public static var EVENT_LOAD_START:String    = 'onLoadStart';
	public static var EVENT_LOAD_STOP:String     = 'onLoadStop';
	public static var EVENT_LOAD_ERROR:String    = 'onLoadError';
	public static var EVENT_LOAD_PERCENT:String  = 'onLoadPercent';
	public static var EVENT_LOAD_COMPLETE:String = 'onLoadComplete';
	private var $hasLoaded:Boolean;
	private var $isLoading:Boolean;
	private var $group: /*Object*/ Array;
	private var $position:Number;
	private var $percent:Number;
	
	
	/**
		Creates a new LoadGroup object.
	*/
	public function LoadGroup() {
		super();
		
		this.$group = new Array();
		this.$hasLoaded = this.$isLoading = false;
		
		this.$setClassDescription('org.casalib.load.LoadGroup');
	}
	
	/**
		Add a load item to the group.
		
		@param loadItem: Load to be added to the load group. Can be any class that implements {@link BytesLoadInterface} and dispatches events <code>"onLoadProgress"</code>, <code>"onLoadComplete"</code> and <code>"onLoadError"</code>.
		@param percentOfGroup: <strong>[optional]</strong> Defines the percentage of the total group the size of the load item represents; defaults to equal increments.
	*/
	public function addLoad(loadItem:BytesLoadInterface, percentOfGroup:Percent):Void {
		if (this.isLoading() || this.hasLoaded())
			return;
		
		this.removeLoad(loadItem);
		
		var loadInfo:Object = new Object();
		loadInfo.load       = loadItem;
		loadInfo.percent    = (percentOfGroup != undefined) ? percentOfGroup.clone() : new Percent(.01);
		
		this.$group.push(loadInfo);
	}
	
	/**
		Removes a load item from the group.
		
		@param loadItem: Load to be removed from the load group.
		@return Returns <code>true</code> if item was successfully found and removed; otherwise <code>false</code>.
		@usageNote You cannot remove a load item when the LoadGroup is in the process of loading.
	*/
	public function removeLoad(loadItem:BytesLoadInterface):Boolean {
		if (this.isLoading())
			return false;
		
		var l:Number = this.$group.length;
		while (l--) {
			if (loadItem == this.$group[l].load) {
				this.$group.splice(l, 1);
				return true;
			}
		}
		
		return false;
	}
	
	/**
		@return Returns an Array contains all load items in the {@link LoadGroup}.
	*/
	public function getLoads(): /*BytesLoadInterface*/ Array {
		var l:Number = this.$group.length;
		var loads: /*BytesLoadInterface*/ Array = new Array();
		
		while (l--)
			loads.push(this.$group[l].load);
		
		return loads;
	}
	
	/**
		Starts the group load process and begins reporting of the total load percentage of all files to observers.
		
		@sends onLoadStart = function(sender:LoadGroup) {}
	*/
	public function start():Void {
		if (this.isLoading() || this.hasLoaded() || this.$group.length == 0)
			return;
		
		this.$isLoading = true;
		this.$position  = -1;
		this.$percent   = 0;
		
		this.$checkTotalPercentValidity();
		this.$loadNextItem();
		
		this.dispatchEvent(LoadGroup.EVENT_LOAD_START, this);
	}
	
	/**
		Stops the group load process.
		
		@sends onLoadStop = function(sender:LoadGroup) {}
	*/
	public function stop():Void {
		if (!this.isLoading())
			return;
		
		this.$stopLoad();
		
		this.dispatchEvent(LoadGroup.EVENT_LOAD_STOP, this);
	}
	
	public function hasLoaded():Boolean {
		return this.$hasLoaded;
	}
	
	public function isLoading():Boolean {
		return this.$isLoading;
	}
	
	/**
		@exclude
		
		This is needed to adhere to LoadInterface but isn't used in this class.
	*/
	public function getFilePath():String {
		return null;
	}
	
	public function destroy():Void {
		if (this.isLoading())
			this.$group[this.$position].load.removeEventObserversForScope(this);
		
		var i:Number = this.$group.length;
		while (i--)
			this.$group[i].percent.destroy();
		
		this.$group.splice(0);
		
		delete this.$hasLoaded;
		delete this.$isLoading;
		delete this.$group;
		delete this.$position;
		delete this.$percent;
		
		super.destroy();
	}
	
	private function $stopLoad():Void {
		this.$isLoading = false;
		this.$group[this.$position].load.removeEventObserversForScope(this);
	}
	
	/**
		@sends onLoadComplete = function(sender:LoadGroup) {}
	*/
	private function $loadNextItem():Void {
		if (++this.$position >= this.$group.length) {
			this.$hasLoaded = true;
			this.$isLoading = false;
			
			if (this.$percent != 1)
				this.dispatchEvent(LoadGroup.EVENT_LOAD_PERCENT, this, new Percent(1));
			
			this.dispatchEvent(LoadGroup.EVENT_LOAD_COMPLETE, this);
			return;
		}
			
		var loadItem:Object = this.$group[this.$position];
		
		if (loadItem.load.hasLoaded()) {
			this.$loadProgress(loadItem.load, 1, 1);
			this.$loadCompleted(loadItem.load);
			return;
		} else {
			loadItem.load.addEventObserver(this, BytesLoad.EVENT_LOAD_ERROR, '$loadError');
			loadItem.load.addEventObserver(this, BytesLoad.EVENT_LOAD_PROGRESS, '$loadProgress');
			loadItem.load.addEventObserver(this, BytesLoad.EVENT_LOAD_COMPLETE, '$loadCompleted');
			loadItem.load.start();
		}
	}
	
	/**
		@sends onLoadPercent = function(sender:LoadGroup, progress:Percent) {}
	*/
	private function $loadProgress(sender:BytesLoadInterface, bytesLoaded:Number, bytesTotal:Number):Void {
		this.dispatchEvent(LoadGroup.EVENT_LOAD_PERCENT, this, new Percent((bytesLoaded / bytesTotal) * this.$group[this.$position].percent.getDecimalPercentage() + this.$percent));
	}
	
	private function $loadCompleted(sender:BytesLoadInterface):Void {
		var loadItem:Object = this.$group[this.$position];
		
		loadItem.load.removeEventObserversForScope(this);
		this.$percent += loadItem.percent.getDecimalPercentage();
		
		this.$loadNextItem();
	}
	
	/**
		@sends onLoadError = function(sender:LoadGroup, failedLoad:BytesLoadInterface) {}
	*/
	private function $loadError():Void {
		this.$stopLoad();
		this.dispatchEvent(LoadGroup.EVENT_LOAD_ERROR, this, this.$group[this.$position].load);
	}
	
	private function $checkTotalPercentValidity():Void {
		var l:Number = this.$group.length;
		var perTotal:Number = 0;
		var loadItem:Object;
		
		while (l--) {
			loadItem = this.$group[l];
			
			if (loadItem.percent.getDecimalPercentage() <= 0)
				loadItem.percent.setDecimalPercentage(.01);
			
			perTotal += loadItem.percent.getDecimalPercentage();
		}
		
		if (perTotal != 1) {
			l = this.$group.length;
			
			while (l--) {
				loadItem = this.$group[l];
				loadItem.percent.setDecimalPercentage((loadItem.percent.getDecimalPercentage() / perTotal) * 1);
			}
		}
	}
}