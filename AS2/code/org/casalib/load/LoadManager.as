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
import org.casalib.control.RunnableInterface;
import org.casalib.load.base.LoadInterface;
import org.casalib.util.ArrayUtil;

/**
	Chains/queues load requests together in the order added. To be used when loading multiple items of same or different type.
	
	@author Aaron Clinger
	@version 06/05/07
	@example
		<code>
			var mediaLoad:MediaLoad = new MediaLoad(this.loadZone_mc, "test.jpg");
			var soundLoad:SoundLoad = new SoundLoad(this.soundContainer_mc, "audio.mp3");
			
			var myLoadQueue:LoadManager = LoadManager.getInstance();
			this.myLoadQueue.addLoad(mediaLoad);
			this.myLoadQueue.addLoad(soundLoad);
			this.myLoadQueue.start();
		</code>
*/

class org.casalib.load.LoadManager extends EventDispatcher implements RunnableInterface {
	public static var EVENT_LOAD_COMPLETE:String = 'onLoadComplete';
	public static var EVENT_LOAD_ERROR:String    = 'onLoadError';
	private static var $loadInstance:LoadManager;
	private var $isLoading:Boolean;
	private var $threads:Number;
	private var $queue:Array;
	
	
	/**
		@return {@link LoadManager} instance.
	*/
	public static function getInstance():LoadManager {
		if (LoadManager.$loadInstance == undefined)
			LoadManager.$loadInstance = new LoadManager();
		
		return LoadManager.$loadInstance;
	}
	
	
	private function LoadManager() {
		super();
		
		this.$isLoading = false;
		this.$threads   = 1;
		this.$queue     = new Array();
		
		this.$setClassDescription('org.casalib.load.LoadManager');
	}
	
	/**
		Adds item to be loaded in order. Can also be used to change a file from/to a priority load.
		
		@param loadItem: Load to be added to the load queue. Can be any class that inherits from {@link LoadInterface} and dispatches events <code>"onLoadComplete"</code> and <code>"onLoadError"</code>.
		@param priority: <strong>[optional]</strong> Indicates to add item to beginning of the queue/next file to load <code>true</code>, or to add it at the end of the queue <code>false</code>; defaults to <code>false</code>.
	*/
	public function addLoad(loadItem:LoadInterface, priority:Boolean):Void {
		var loadObj:Object = loadItem;
		
		var i:Number = ArrayUtil.indexOf(this.$queue, loadObj);
		if (i != -1)
			if (!loadObj.isLoading())
				this.$removeLoad(loadObj, i);
		
		if (priority)
			this.$queue.unshift(loadObj);
		else
			this.$queue.push(loadObj);
		
		this.$checkQueue();
	}
	
	/**
		Removes item from the load queue. If file is currently loading the load is stopped.
		
		@param loadItem: Load to be removed from the load queue.
		@return Returns <code>true</code> if item was successfully found and removed; otherwise <code>false</code>.
		@usageNote Load items are automatically removed from LoadManager on load success or error.
	*/
	public function removeLoad(loadItem:LoadInterface):Boolean {
		var i:Number = ArrayUtil.indexOf(this.$queue, loadItem);
		if (i == -1)
			return false;
		
		if (loadItem.isLoading())
			loadItem.stop();
		
		this.$removeLoad(loadItem, i);
		
		return true;
	}
	
	/**
		Removes all items from the load queue and cancels any currently loading.
	*/
	public function removeAllLoads():Void {
		var l:Number = this.$queue.length;
		var loadItem:Object;
		while (l--) {
			loadItem = this.$queue.pop();
			
			if (loadItem.isLoading())
				loadItem.stop();
			
			loadItem.removeEventObserversForScope(this);
		}
	}
	
	/**
		Starts or resumes loading items from the queue.
	*/
	public function start():Void {
		if (this.$isLoading)
			return;
		
		this.$isLoading = true;
		this.$checkQueue();
	}
	
	/**
		Stops loading items from the queue after the currently loading items complete loading.
	*/
	public function stop():Void {
		this.$isLoading = false;
	}
	
	/**
		Determines whether LoadManager is in the process of loading items from the queue.
		
		@return Returns <code>true</code> if the LoadManager is currently actively loading; otherwise <code>false</code>.
	*/
	public function isLoading():Boolean {
		return this.$isLoading;
	}
	
	/**
		Defines the number of simultaneous file requests/downloads.
		
		@param theads: The number of threads the class will theoretically use, though most browsers cap the amount of threads and hold the other requests in a queue. Pass <code>0</code> for unlimited threads.
		@usageNote Class defaults to <code>1</code> thread. 
	*/
	public function setThreads(threads:Number):Void {
		this.$threads = Math.max(0, Math.round(threads));
		this.$checkQueue();
	}
	
	private function $checkQueue():Void {
		if (!this.$isLoading)
			return;
		
		var t:Number = (this.$threads == 0) ? this.$queue.length : this.$threads;
		var i:Number = 0;
		var l:Number = this.$queue.length;
		
		while (l--)
			if (this.$queue[l].isLoading())
				i++;
		
		if (i >= t)
			return;
		
		t -= i;
		l = -1;
		while (++l < this.$queue.length) {
			if (!this.$queue[l].isLoading()) {
				this.$queue[l].addEventObserver(this, 'onLoadComplete', '$loadCompleted');
				this.$queue[l].addEventObserver(this, 'onLoadError', '$loadError');
				this.$queue[l].start();
				
				if (--t == 0)
					return;
			}
		}
	}
	
	/**
		@sends onLoadCompleted = function(loadItem:LoadInterface) {}
	*/
	private function $loadCompleted(sender:LoadInterface):Void {
		this.$removeLoad(sender);
		this.dispatchEvent(LoadManager.EVENT_LOAD_COMPLETE, sender);
	}
	
	/**
		@sends onLoadError = function(loadItem:LoadInterface) {}
	*/
	private function $loadError(sender:LoadInterface):Void {
		this.$removeLoad(sender);
		this.dispatchEvent(LoadManager.EVENT_LOAD_ERROR, sender);
	}
	
	private function $removeLoad(loadItem:Object, position:Number):Void {
		loadItem.removeEventObserversForScope(this);
		
		if (position == undefined)
			ArrayUtil.removeArrayItem(this.$queue, loadItem);
		else
			this.$queue.splice(position, 1);
		
		this.$checkQueue();
	}
}