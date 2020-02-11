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

import org.casalib.load.base.RetryableLoad;
import org.casalib.load.base.BytesLoadInterface;
import org.casalib.time.EnterFrame;

/**
	Base bytes load class for items where methods <code>getBytesLoaded</code> and <code>getBytesTotal</code> are available. Class needs to be extended further to function properly.
	
	@author Aaron Clinger
	@version 05/31/07
	@since Flash Player 7
*/

class org.casalib.load.base.BytesLoad extends RetryableLoad implements BytesLoadInterface {
	public static var EVENT_LOAD_PROGRESS:String = 'onLoadProgress';
	public static var EVENT_INSTANTIATE:String   = 'onInstantiate';
	public static var loadTimeout:Number = 8000;
	private var $loadTimeout:Number;
	private var $previousTime:Number;
	private var $previousBytesLoaded:Number;
	private var $isProgressing:Boolean;
	private var $framePulse:EnterFrame;
	
	/**
		@param target: A path to a container where the file specified by <code>filePath</code> should be loaded into.
		@param filePath: The absolute or relative URL of the file to be loaded.
	*/
	private function BytesLoad(target:Object, filePath:String) {
		super(target, filePath);
		
		this.setLoadTimeout(BytesLoad.loadTimeout);
		
		this.$setClassDescription('org.casalib.load.base.BytesLoad');
	}
	
	/**
		{@inheritDoc}
		
		@usageNote Class defaults to <code>8000</code> milliseconds.
	*/
	public function setLoadTimeout(loadTimeout:Number):Void {
		this.$loadTimeout = loadTimeout;
	}
	
	public function getBytesLoaded():Number {
		return this.$target.getBytesLoaded();
	}
	
	public function getBytesTotal():Number {
		return this.$target.getBytesTotal();
	}
	
	public function destroy():Void {
		this.$clean();
		
		delete this.$loadTimeout;
		
		super.destroy();
	}
	
	/**
		@sends onLoadProgress = function(sender:BytesLoad, bytesLoaded:Number, bytesTotal:Number) {}
	*/
	private function $checkLoadProgress():Void {
		var bl:Number = this.getBytesLoaded();
		var bt:Number = this.getBytesTotal();
		
		var currentTime:Number = getTimer();
		
		if (bl < 50 || bl == this.$previousBytesLoaded || isNaN(bl) || isNaN(bt)) {
			if (currentTime - this.$previousTime >= this.$loadTimeout)
				this.$retryLoad();
			return;
		}
		
		this.$loadProgress(bl, currentTime);
		this.dispatchEvent(BytesLoad.EVENT_LOAD_PROGRESS, this, bl, bt);
		
		this.$checkForLoadComplete();
	}
	
	/**
		If target in subclass has an reliable <code>"onLoad"</code> handler overriding this to a bank method and follow docs located: {@link Load#$remapOnLoadHandler}. Otherwise leave as is.
	*/
	private function $checkForLoadComplete():Void {
		if (this.getBytesTotal() != 0)
			if (this.getBytesLoaded() >= this.getBytesTotal())
				this.$onComplete();
	}
	
	/**
		@sends onInstantiate = function(sender:BytesLoad) {}
	*/
	private function $loadProgress(bytesLoaded:Number, currentTime:Number):Void {
		if (!this.$isProgressing) {
			if (bytesLoaded > 0) {
				this.$isProgressing = true;
				this.dispatchEvent(BytesLoad.EVENT_INSTANTIATE, this);
			}
		}
		
		this.$previousBytesLoaded = bytesLoaded;
		this.$previousTime        = currentTime;
	}
	
	/**
		<strong>This function needs to be extended by a subclass.</strong>
	*/
	private function $startLoad():Void {
		super.$startLoad();
		
		this.$isProgressing = false;
		
		this.$loadProgress(0, getTimer());
		
		this.$framePulse = EnterFrame.getInstance();
		this.$framePulse.addEventObserver(this, EnterFrame.EVENT_ENTER_FRAME, '$checkLoadProgress');
	}
	
	private function $retryLoad():Void {
		this.$framePulse.removeEventObserversForScope(this);
		
		super.$retryLoad();
	}
	
	private function $onComplete():Void {
		this.$framePulse.removeEventObserversForScope(this);
		
		var prevBytesLoaded:Number = this.$previousBytesLoaded;
		
		this.$loadProgress(this.getBytesTotal(), null);
		
		if (this.getBytesTotal() != prevBytesLoaded)
			this.dispatchEvent(BytesLoad.EVENT_LOAD_PROGRESS, this, this.getBytesTotal(), this.getBytesTotal());
		
		super.$onComplete();
	}
	
	private function $clean():Void {
		this.$framePulse.removeEventObserversForScope(this);
		
		delete this.$isProgressing;
		delete this.$framePulse;
		delete this.$previousBytesLoaded;
		delete this.$previousTime;
		
		super.$clean();
	}
}