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

import org.casalib.load.base.BytesLoad;

/**
	Data load class for items that have the methods <code>load</code> and <code>sendAndLoad</code>. Class needs to be extended further to function properly.
	
	@author Aaron Clinger
	@version 06/08/07
	@since Flash Player 7
*/

class org.casalib.load.base.DataLoad extends BytesLoad {
	public static var EVENT_DATA:String = 'onData';
	private var $method:String;
	private var $target:Object;
	private var $receive:Object;
	private var $isUnloading:Boolean;
	private var $passingValues:Boolean;
	
	
	/**
		@param path: The absolute or relative URL of the variables to be loaded.
		@param method: <strong>[optional]</strong> Defines the method of the HTTP protocol, either <code>"GET"</code> of <code>"POST"</code>; defaults to <code>"POST"</code>.
	*/
	private function DataLoad(path:String, method:String) {
		super(null, path);
		
		this.$method = method;
		
		this.$setClassDescription('org.casalib.load.base.DataLoad');
	}
	
	/**
		Adds or changes HTTP request headers.
		
		@param header: A string that represents an HTTP request header name.
		@param headerValue: A string that represents the value associated with header.
	*/
	public function addRequestHeader(header:Object, headerValue:String):Void {
		this.$target.addRequestHeader(header, headerValue);
		this.$passingValues = true;
	}
	
	public function getBytesLoaded():Number {
		return (this.$receive.getBytesLoaded() != undefined) ? this.$receive.getBytesLoaded() : super.getBytesLoaded();
	}
	
	public function getBytesTotal():Number {
		return (this.$receive.getBytesTotal() != undefined) ? this.$receive.getBytesTotal() : super.getBytesTotal();
	}
	
	public function hasLoaded():Boolean {
		return (this.$receive.loaded != undefined) ? this.$receive.loaded : (this.$target.loaded != undefined) ? this.$target.loaded : false;
	}
	
	public function destroy():Void {
		delete this.$target;
		delete this.$receive;
		delete this.$isUnloading;
		delete this.$passingValues;
		
		super.destroy();
	}
	
	private function $startLoad():Void {
		super.$startLoad();
		
		if (this.$passingValues) {
			this.$remapOnDataHandler(this.$receive);
			this.$target.sendAndLoad(this.getFilePath(), this.$receive, this.$method);
		} else {
			this.$remapOnDataHandler();
			this.$target.load(this.getFilePath());
		}
	}
	
	private function $remapOnDataHandler(loadContainer:Object):Void {
		var context:DataLoad = this;
		var targ:Object      = (loadContainer == undefined) ? this.$target : loadContainer;
		
		targ.onData = function(src:String):Void {
			context.$onData(src);
		};
	}
	
	/**
		<strong>This function needs to be called by a subclass and the contents of <code>src</code> need to be decoded/parsed.</strong>
		
		@sends onData = function(sender:DataLoad, src:String) {}
	*/
	private function $onData(src:String):Void {
		if (src != undefined) {
			this.dispatchEvent(DataLoad.EVENT_DATA, this, src);
			
			if (this.$passingValues)
				this.$receive.loaded = true;
			else
				this.$target.loaded  = true;
			
			this.$onLoad(true);
		} else
			this.$onLoad(false);
	}
	
	private function $stopLoad():Void {
		super.$stopLoad();
		
		this.$isUnloading = true;
		if (this.$passingValues)
			this.$target.sendAndLoad('', this.$receive, this.$method); // Cancels the current load.
		else
			this.$target.load(''); // Cancels the current load.
	}
	
	private function $onLoad(success:Boolean):Void {
		if (!this.$isUnloading)
			super.$onLoad(success);
		else
			delete this.$isUnloading;
	}
	
	private function $checkForLoadComplete():Void {}
}