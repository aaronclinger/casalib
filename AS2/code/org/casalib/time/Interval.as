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

import org.casalib.time.Timer;
import org.casalib.util.ArrayUtil;
import org.casalib.util.TypeUtil;

/**
	To be used instead of built in <code>setInterval</code> function. 
	
	Advantages over <code>setInterval</code>:
	<ul>
		<li>Auto stopping/clearing of intervals if method called no longer exists.</li>
		<li>Ability to {@link Timer#stop stop} and {@link Timer#start start} intervals without redefining.</li>
		<li>Change the delay with {@link Timer#changeDelay} without redefining.</li>
		<li>Included {@link #setReps} for intervals that only need to fire finitely.</li>
		<li>{@link #setInterval} returns object instead of interval id for better OOP structure.</li>
		<li>Built in events/event dispatcher.</li>
	</ul>
	
	@author Aaron Clinger
	@author Toby Boudreaux
	@author Mike Creighton
	@version 04/19/07
	@example
		<code>
			function exampleFire(firstName:String):Void {
				trace("exampleFire called and passed firstName = " + firstName);
			}
			
			var example_si:Interval = Interval.setInterval(this, "exampleFire", 1000, "Aaron");
			this.example_si.setReps(3);
			this.example_si.start();
		</code>
	@see {@link PropertySetter}.
*/

class org.casalib.time.Interval extends Timer {
	private var $arguments:Array;
	
	private static var $intervalMap:Array;
	
	
	/**
		Calls a function or a method of an object at periodic intervals.
		
		@param scope: An object that contains the method specified by "methodName".
		@param methodName: A method that exists in the scope of the object specified by "scope".
		@param delay: The time in milliseconds between calls.
		@param param(s): <strong>[optional]</strong> Parameters passed to the function specified by "methodName". Multiple parameters are allowed and should be separated by commas: param1,param2, ...,paramN
		@return: {@link Interval} reference.
	*/
	public static function setInterval(scope:Object, methodName:String, delay:Number, param:Object):Interval {
		if (!TypeUtil.isTypeOf(scope[methodName], 'function'))
			return undefined;
		
		if (Interval.$intervalMap == undefined)
			Interval.$intervalMap = new Array();
		
		var intervalItem:Interval = new Interval(delay);
		intervalItem.setArguments(arguments);
		
		Interval.$intervalMap.push(intervalItem);
		
		return intervalItem;
	}
	
	/**
		Calls a function or a method of an object once after time has elasped, <code>setTimeout</code> defaults {@link #setReps} to 1. 
		
		@param scope: An object that contains the method specified by "methodName".
		@param methodName: A method that exists in the scope of the object specified by "scope".
		@param delay: The time in milliseconds between calls.
		@param param(s): <strong>[optional]</strong> Parameters passed to the function specified by "methodName". Multiple parameters are allowed and should be separated by commas: param1,param2, ...,paramN
		@return: {@link Interval} reference.
	*/
	public static function setTimeout(scope:Object, methodName:String, delay:Number, param:Object):Interval {
		var intervalItem:Interval = Interval.setInterval.apply(null, arguments);
		intervalItem.setReps(1);
		return intervalItem;
	}
	
	/**
		Stops all intervals in a defined location.
		
		@param scope: <strong>[optional]</strong> Object reference that contains a method referenced by one or more Interval instance. If scope is <code>undefined</code>, {@link #stopIntervals} will stop all running intervals.
		@see {@link Timer#stop}
	*/
	public static function stopIntervals(scope:Object):Void {
		var len:Number = Interval.$intervalMap.length;
		
		if (scope == undefined)
			while (len--)
				Interval.$intervalMap[len].stop();
		else
			while (len--)
				if (Interval.$intervalMap[len].$arguments[0] == scope)
					Interval.$intervalMap[len].stop();
	}
	
	
	
	private function Interval(delay:Number) {
		super(delay, undefined);
		
		this.$setClassDescription('org.casalib.time.Interval');
	}
	
	/**
		Defines the amount of total repetitions/fires. If not set repetitions will continue until {@link Timer#stop} is called.
		
		@param reps: The amount of repetitions.
	*/
	public function setReps(reps:Number):Void {
		this.$reps = reps;
	}
	
	/**
		@exclude
	*/
	public function setArguments(args:Array):Void {
		this.$arguments = args;
	}
	
	private function $onFire():Void {
		var scope:Object      = this.$arguments[0];
		var methodName:String = this.$arguments[1];
		
		if (!TypeUtil.isTypeOf(scope[methodName], 'function')) {
			this.stop();
			return;
		}
		
		this.$fires++;
		
		if (this.$reps != undefined) {
			if (this.$reps <= this.$fires) {
				this.$stopInterval();
				scope[methodName].apply(scope, this.$arguments.slice(3));
				this.dispatchEvent(Timer.EVENT_FIRE, this, this.$fires);
				this.dispatchEvent(Timer.EVENT_COMPLETE, this, this.$fires);
				return;
			}
		}
		
		scope[methodName].apply(scope, this.$arguments.slice(3));
		this.dispatchEvent(Timer.EVENT_FIRE, this, this.$fires);
	}
	
	public function destroy():Void {
		this.$arguments.splice(0);
		delete this.$arguments;
		
		ArrayUtil.removeArrayItem(Interval.$intervalMap, this);
		
		super.destroy();
	}
}