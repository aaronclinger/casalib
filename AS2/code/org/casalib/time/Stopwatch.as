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
import org.casalib.control.ResumeableInterface;

/**
	Simple stopwatch class that records elapsed time in milliseconds.
	
	@author Aaron Clinger
	@version 06/11/07
	@example
		<code>
			var stopwatch:Stopwatch = new Stopwatch();
			
			this.start_mc.onPress = function():Void {
				this._parent.stopwatch.start();
				trace("Stopwatch started.");
			}
			
			this.stop_mc.onPress = function():Void {
				this._parent.stopwatch.stop();
				trace("Stopwatch stopped. Time elapsed: " + this._parent.stopwatch.getTime());
			}
			
			this.resume_mc.onPress = function():Void {
				this._parent.stopwatch.resume();
				trace("Stopwatch continued.");
			}
		</code>
*/

class org.casalib.time.Stopwatch extends CoreObject implements ResumeableInterface {
	private var $startTime:Number;
	private var $elapsedTime:Number;
	private var $stopped:Boolean;
	
	public function Stopwatch() {
		super();
		
		this.$setClassDescription('org.casalib.time.Stopwatch');
		
		this.$elapsedTime = this.$startTime = 0;
		this.$stopped = false;
	}
	
	/**
		Starts stopwatch and resets previous elapsed time.
	*/
	public function start():Void {
		this.$elapsedTime = 0;
		this.$startTime   = this.$getTimer();
		this.$stopped     = false;
	}
	
	/**
		Stops stopwatch.
	*/
	public function stop():Void {
		this.$elapsedTime = this.getTime();
		this.$startTime   = 0;
		this.$stopped     = true;
	}
	
	/**
		Resumes stopwatch from {@link #stop}.
	*/
	public function resume():Void {
		if (this.$stopped)
			this.$startTime = this.$getTimer();
	}
	
	/**
		Gets the time elapsed since {@link #start} or until {@link #stop} was called.
		
		@return Returns the elapsed time in milliseconds.
		@usageNote Can be called before or after calling {@link #stop}.
	*/
	public function getTime():Number {
		return (this.$startTime != 0) ? this.$getTimer() - this.$startTime + this.$elapsedTime : this.$elapsedTime;
	}
	
	private function $getTimer():Number {
		return getTimer();
	}
	
	public function destroy():Void {
		delete this.$startTime;
		delete this.$elapsedTime;
		delete this.$stopped;
		
		super.destroy();
	}
}