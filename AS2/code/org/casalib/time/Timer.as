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

/**
	Timer is used for executing code at a specific callback frequency.
	
	@author Aaron Clinger
	@version 04/09/07
	@example
		<code>
			function onFire(sender:Timer, fires:Number):Void {
				trace("onFire has been called " + fires + " times.");
			}
			
			var myTimer:Timer = new Timer(1000, 3);
			this.myTimer.addEventObserver(this, Timer.EVENT_FIRE, "onFire");
			this.myTimer.start();
		</code>
*/

class org.casalib.time.Timer extends EventDispatcher implements RunnableInterface {
	public static var EVENT_START:String    = 'onStart';
	public static var EVENT_STOP:String     = 'onStop';
	public static var EVENT_FIRE:String     = 'onFire';
	public static var EVENT_COMPLETE:String = 'onComplete';
	private var $id:Number;
	private var $reps:Number;
	private var $delay:Number;
	private var $fires:Number;
	
	/**
		Defines the Timer object that dispatches an event at a specific frequency.
		
		@param delay: The time in milliseconds between calls.
		@param reps: The amount of repetitions.
	*/
	public function Timer(delay:Number, reps:Number) {
		super();
		
		this.$delay = delay;
		this.$reps  = reps;
		
		this.$setClassDescription('org.casalib.time.Timer');
	}
	
	/**
		Starts or restarts the timer. Resets reps/fires to 0.
		
		@sends onStart = function(sender:Timer) {}
	*/
	public function start():Void {
		if (this.isFiring())
			this.$stopInterval();
		
		this.dispatchEvent(Timer.EVENT_START, this);
		
		this.$startInterval();
	}
	
	/**
		Stops the timer.
		
		@sends onStop = function(sender:Timer) {}
	*/
	public function stop():Void {
		if (!this.isFiring())
			return;
		
		this.$stopInterval();
		delete this.$fires;
		
		this.dispatchEvent(Timer.EVENT_STOP, this);
	}
	
	/**
		Changes the time between repetitions. Does NOT reset reps/fires.
		
		@param delay: The time in milliseconds between calls.
	*/
	public function changeDelay(delay:Number):Void {
		var fires:Number = this.getFires();
		this.$stopInterval();
		this.$delay = delay;
		
		if (this.isFiring()) {
			this.$startInterval();
			this.$fires = fires;
		}
	}
	
	/**
		@return Returns the time between repetitions.
	*/
	public function getDelay():Number {
		return this.$delay;
	}
	
	/**
		Determines in the timer is running.
		
		@return Returns <code>true</code> if Timer instance is running/firing; otherwise <code>false</code>.
	*/
	public function isFiring():Boolean {
		return this.$id != undefined;
	}
	
	/**
		Returns the number of fires.
		
		@return The number of elapsed fires.
	*/
	public function getFires():Number {
		return this.$fires;
	}
	
	/**
		@sends onFire = function(sender:Timer, fires:Number) {}
		@sends onComplete = function(sender:Timer, fires:Number) {}
	*/
	private function $onFire():Void {
		this.dispatchEvent(Timer.EVENT_FIRE, this, ++this.$fires);
		
		if (this.$reps != undefined) {
			if (this.$reps <= this.$fires) {
				this.$stopInterval();
				this.dispatchEvent(Timer.EVENT_COMPLETE, this, this.$fires);
			}
		}
	}
	
	private function $startInterval():Void {
		this.$fires = 0;
		this.$id    = _global.setInterval(this, '$onFire', this.$delay);
	}
	
	private function $stopInterval():Void {
		_global.clearInterval(this.$id);
		delete this.$id;
	}
	
	public function destroy():Void {
		if (this.isFiring())
			this.$stopInterval();
		
		delete this.$reps;
		delete this.$delay;
		delete this.$fires;
		
		super.destroy();
	}
}
