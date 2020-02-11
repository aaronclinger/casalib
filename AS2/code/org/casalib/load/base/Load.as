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
import org.casalib.time.FrameDelay;

/**
	Base load class. Class needs to be extended further to function properly.
	
	@author Aaron Clinger
	@version 05/06/07
	@since Flash Player 7
*/

class org.casalib.load.base.Load extends EventDispatcher implements LoadInterface {
	public static var EVENT_LOAD_START:String    = 'onLoadStart';
	public static var EVENT_LOAD_ERROR:String    = 'onLoadError';
	public static var EVENT_LOAD_COMPLETE:String = 'onLoadComplete';
	public static var EVENT_LOAD_INIT:String     = 'onLoadInit';
	private var $filePath:String;
	private var $target:Object;
	private var $hasLoaded:Boolean;
	private var $isLoading:Boolean;
	private var $frameDelay:FrameDelay;
	
	
	/**
		@param target: A path to a container where the file specified by <code>filePath</code> should be loaded into.
		@param filePath: The absolute or relative URL of the file to be loaded.
	*/
	private function Load(target:Object, filePath:String) {
		super();
		
		this.$target    = target;
		this.$filePath  = filePath;
		this.$hasLoaded = this.$isLoading = false;
		
		this.$setClassDescription('org.casalib.load.base.Load');
	}
	
	/**
		Begins the loading process and broadcasts events to observers.
		
		@usageNote Use {@link EventDispatcher#addEventObserver} to listen for broadcasted events.
		@sends onLoadStart = function(sender:Load) {}
	*/
	public function start():Void {
		if (this.isLoading() || this.hasLoaded())
			return;
		
		if (this.$filePath == undefined || this.$target == undefined) {
			this.dispatchEvent(Load.EVENT_LOAD_ERROR, this);
			return;
		}
		
		this.$startLoad();
		
		this.dispatchEvent(Load.EVENT_LOAD_START, this);
	}
	
	/**
		Unloads a file that has previously loaded, or cancels a currently loading file from completing.
		
		@usageNote If you issue this command while a file is loading, event <code>onLoadError</code> is also invoked.
	*/
	public function stop():Void {
		if (this.isLoading()) {
			this.$stopLoad();
			this.dispatchEvent(Load.EVENT_LOAD_ERROR, this);
			return;
		}
		
		this.$stopLoad();
	}
	
	public function getFilePath():String {
		return this.$filePath;
	}
	
	public function hasLoaded():Boolean {
		return this.$hasLoaded;
	}
	
	public function isLoading():Boolean {
		return this.$isLoading;
	}
	
	public function destroy():Void {
		this.$clean();
		
		delete this.$hasLoaded;
		delete this.$filePath;
		delete this.$target;
		
		super.destroy();
	}
	
	/**
		<strong>This function needs to be extended by a subclass.</strong>
	*/
	private function $startLoad():Void {
		this.$isLoading = true;
		this.$hasLoaded = false;
	}
	
	/**
		<strong>This function needs to be extended by a subclass.</strong>
	*/
	private function $stopLoad():Void {
		this.$clean();
		this.$hasLoaded = false;
	}
	
	/**
		<strong>This function needs to be called by a subclass.</strong>
		
		If target in subclass has an reliable <code>"onLoad"</code> handler call this method after target is defined in the constructor.
		
		@param loadContainer: <strong>[optional]</strong> Defines object file is loading into and has the event handler <code>"onLoad"</code>; defaults to <code>$target</code>.
	*/
	private function $remapOnLoadHandler(loadContainer:Object):Void {
		var _this:Load  = this;
		var targ:Object = (loadContainer == undefined) ? this.$target : loadContainer;
		
		targ.onLoad = function(success:Boolean):Void {
			_this.$onLoad(success);
		};
	}
	
	private function $onLoad(success:Boolean):Void {
		if (success)
			this.$onComplete();
	}
	
	/**
		@sends onLoadComplete = function(sender:Load) {}
		@sends onLoadError = function(sender:Load) {}
	*/
	private function $onComplete():Void {
		this.$hasLoaded = true;
		
		this.dispatchEvent(Load.EVENT_LOAD_COMPLETE, this);
		
		this.$frameDelay = new FrameDelay(this, '$onInitialized');
		this.$frameDelay.start();
	}
	
	/**
		@sends onLoadInit = function(sender:Load) {}
	*/
	private function $onInitialized():Void {
		this.dispatchEvent(Load.EVENT_LOAD_INIT, this);
		this.$clean();
	}
	
	private function $clean():Void {
		this.$frameDelay.destroy();
		
		delete this.$frameDelay;
		delete this.$isLoading;
	}
}