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
import org.casalib.control.ResumeableInterface;
import org.casalib.event.DispatchableInterface;
import org.casalib.time.Interval;

/**
	Creates a chain of sequenced methods calls that wait for a specified event before continuing.
	
	@author Aaron Clinger
	@version 03/16/07
	@example
		<code>
			var boxMoveRight:PropertyTween = new PropertyTween(this.box_mc, "_x", com.robertpenner.easing.Bounce.easeOut, 400, 1.5);
			var boxMoveLeft:PropertyTween = new PropertyTween(this.box_mc, "_x", com.robertpenner.easing.Bounce.easeOut, 0, 1.5);
			
			var chain:Chain = new Chain(true);
			chain.addTask(this.boxMoveRight, "start", Tween.EVENT_COMPLETE);
			chain.addTask(this.boxMoveLeft, "start", Tween.EVENT_COMPLETE);
			chain.start();
		</code>
*/

class org.casalib.time.Chain extends EventDispatcher implements ResumeableInterface {
	public static var EVENT_START:String    = 'onStart';
	public static var EVENT_STOP:String     = 'onStop';
	public static var EVENT_RESUME:String   = 'onResume';
	public static var EVENT_LOOP:String     = 'onLoop';
	public static var EVENT_COMPLETE:String = 'onComplete';
	
	private var $isRunning:Boolean;
	private var $isLooping:Boolean;
	private var $completeFired:Boolean;
	private var $interval:Interval;
	private var $sequence:Array;
	private var $current:Number;
	
	
	/**
		Creates a new chain.
		
		@param isLooping: <strong>[optional]</strong> Indicates the sequence replays once completed <code>true</code>, or stops <code>false</code>; defaults to <code>false</code>.
	*/
	public function Chain(isLooping:Boolean) {
		super();
		
		this.$isLooping = (isLooping == undefined) ? false : isLooping;
		this.$sequence  = new Array();
		this.$interval  = Interval.setTimeout(this, '$triggerEvent', 1);
		
		this.$setClassDescription('org.casalib.time.Chain');
	}
	
	/**
		Adds a task to the sequence.
		
		@param scope: An object that contains the method specified by "startMethodName" and that will dispatch "completeEventName" using {@link EventDispatcher}.
		@param startMethodName: A method that exists in the scope of the object specified by "scope".
		@param completeEventName: The event the class waits to receive before continuing.
		@param delay: The time in milliseconds between when the complete event was recieved until the next start method will be called.
		@param position: <strong>[optional]</strong> Specifies the index of the insertion in the sequence order; defaults to the next position.
	*/
	public function addTask(scope:DispatchableInterface, startMethodName:String, completeEventName:String, delay:Number, position:Number):Void {
		this.$createNewTask(scope, startMethodName, completeEventName, delay, position);
	}
	
	/**
		Removes task from the sequence.
		
		@param scope: An object that contains the method specified by "methodName".
		@param methodName: A method that exists in the scope of the object specified by "scope".
		@return Returns <code>true</code> if task was successfully found and removed; otherwise <code>false</code>.
	*/
	public function removeTask(scope:Object, methodName:String):Boolean {
		var i:Number = -1;
		var event:Object;
		
		while (++i < this.$sequence.length) {
			event = this.$sequence[i];
			
			if (event.scope == scope) {
				if (event.method == methodName) {
					this.$removeObserversForSequenceItem(i);
					this.$sequence.splice(i, 1);
					return true;
				}
			}
		}
		
		return false;
	}
	
	/**
		Starts the sequence from the beginning.
		
		@sends onStart = function(sender:Chain) {}
	*/
	public function start():Void {
		this.dispatchEvent(Chain.EVENT_START, this);
		this.$startSequence();
	}
	
	/**
		Stops the sequence at its current position.
		
		@sends onStop = function(sender:Chain) {}
	*/
	public function stop():Void {
		if (!this.$isRunning)
			return;
		
		this.$interval.stop();
		this.$completeFired = this.$isRunning = false;
		this.dispatchEvent(Chain.EVENT_STOP, this);
	}
	
	/**
		Resumes sequence from {@link #stop stopped} position or restarts the sequence from the beginning.
		
		@sends onResume = function(sender:Chain) {}
	*/
	public function resume():Void {
		if (this.$isRunning)
			return;
		
		if (this.$current == -1 || this.$current == undefined) {
			this.start();
			return;
		}
		
		this.$isRunning = true;
		
		this.dispatchEvent(Chain.EVENT_RESUME, this);
		
		if (this.$completeFired)
			this.$startDelay();
		else
			this.$interval.start();
	}
	
	public function destroy():Void {
		this.$interval.destroy();
		
		this.$removeObserversForSequenceItem(this.$current);
		
		this.$sequence.splice(0);
		
		delete this.$isRunning;
		delete this.$isLooping;
		delete this.$interval;
		delete this.$sequence;
		delete this.$current;
		
		super.destroy();
	}
	
	private function $createNewTask(scope:Object, startMethodName:String, completeEventName:String, delay:Number, position:Number):Void {
		var event:Object = new Object();
		event.scope      = scope;
		event.method     = startMethodName;
		event.complete   = completeEventName;
		event.delay      = (delay == undefined) ? 0 : delay;
		
		if (position == undefined)
			this.$sequence.push(event);
		else
			this.$sequence.splice(position, 0, event);
	}
	
	private function $startSequence():Void {
		this.$interval.stop();
		
		this.$isRunning = true;
		this.$current   = -1;
		
		this.$startDelay();
	}
	
	/**
		@sends onComplete = function(sender:Chain) {}
		@sends onLoop = function(sender:Chain) {}
	*/
	private function $startDelay():Void {
		if (this.$current != -1)
			this.$removeObserversForSequenceItem(this.$current);
			
		if (!this.$isRunning) {
			this.$completeFired = true;
			return;
		}
		
		if (++this.$current >= this.$sequence.length) {
			if (this.$isLooping) {
				this.dispatchEvent(Chain.EVENT_LOOP, this);
				this.$startSequence();
			} else {
				this.dispatchEvent(Chain.EVENT_COMPLETE, this);
			}
			
			return;
		}
		
		this.$interval.changeDelay(this.$sequence[this.$current].delay);
		this.$interval.start();
	}
	
	private function $triggerEvent():Void {
		this.$addObserverForSequenceItem(this.$current);
		
		var event:Object = this.$sequence[this.$current];
		event.scope[event.method].apply(event.scope);
	}
	
	private function $addObserverForSequenceItem(position:Number):Void {
		var event:Object = this.$sequence[position];
		event.scope.addEventObserver(this, event.complete, '$startDelay');
	}
	
	private function $removeObserversForSequenceItem(position:Number):Void {
		this.$sequence[position].scope.removeEventObserversForScope(this);
	}
}