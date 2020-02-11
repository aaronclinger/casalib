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

import org.casalib.load.base.Load;
import org.casalib.load.base.RetryableLoadInterface;

/**
	Retryable load class. Class needs to be extended further to function properly.
	
	@author Aaron Clinger
	@version 12/22/06
	@since Flash Player 7
*/

class org.casalib.load.base.RetryableLoad extends Load implements RetryableLoadInterface {
	public static var EVENT_LOAD_RETRY:String = 'onLoadRetry';
	public static var loadRetries:Number = 2;
	private var $attempts:Number;
	private var $loadRetries:Number;
	
	
	/**
		@param target: A path to a container where the file specified by <code>filePath</code> should be loaded into.
		@param filePath: The absolute or relative URL of the file to be loaded.
	*/
	private function RetryableLoad(target:Object, filePath:String) {
		super(target, filePath);
		
		this.setLoadRetries(RetryableLoad.loadRetries);
		
		this.$setClassDescription('org.casalib.load.base.RetryableLoad');
	}
	
	/**
		{@inheritDoc}
		
		@usageNote Class defaults to <code>2</code> additional retries / <code>3</code> total load attempts.
	*/
	public function setLoadRetries(loadRetries:Number):Void {
		this.$loadRetries = loadRetries;
	}
	
	public function destroy():Void {
		this.$clean();
		
		delete this.$loadRetries;
		
		super.destroy();
	}
	
	private function $startLoad():Void {
		var loadAttempts:Number = isNaN(this.$attempts) ? 0 : this.$attempts;
		this.$clean();
		this.$attempts = loadAttempts;
		
		super.$startLoad();
	}
	
	private function $onLoad(success:Boolean):Void {
		if (success)
			this.$onComplete();
		else
			this.$retryLoad();
	}
	
	/**
		@sends onLoadRetry = function(sends:RetryableLoad, attempts:Number) {}
	*/
	private function $retryLoad():Void {
		if (++this.$attempts > this.$loadRetries) {
			this.stop();
			return;
		}
		
		this.dispatchEvent(RetryableLoad.EVENT_LOAD_RETRY, this, this.$attempts);
		this.$startLoad();
	}
	
	private function $clean():Void {
		delete this.$attempts;
		
		super.$clean();
	}
}