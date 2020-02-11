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
import org.casalib.event.DispatchableInterface;
import org.casalib.util.TypeUtil;

/**
	Provides event notification and listener management capabilities to objects. 
	
	Advantages of using this EventDispatcher:
	<ul>
		<li>Ability to {@link #addEventObserver remap event handlers} to a function not sharing the same name as the event.</li>
		<li>Ability to {@link #removeEventObserversForEvent remove all} event observers for a specified event.</li>
		<li>Ability to {@link #removeEventObserversForScope remove all} event observers for a specified scope.</li>
		<li>Ability to {@link #removeAllEventObservers remove all} event observers subscribed to broadcasting object.</li>
	</ul>

	@author Aaron Clinger
	@author Mike Creighton
	@version 07/12/07
*/

class org.casalib.event.EventDispatcher extends CoreObject implements DispatchableInterface {
	private var $eventMap:Object;
	
	public function EventDispatcher() {
		super();
		
		this.removeAllEventObservers();
		
		this.$setClassDescription('org.casalib.event.EventDispatcher');
	}
	
	/**
		{@inheritDoc}
		
		@param scope: {@inheritDoc}
		@param eventName: {@inheritDoc}
		@param eventHandler: {@inheritDoc}
		@return {@inheritDoc}
		@example <code>this.eventButton_mc.addEventObserver(this, "onRollOver");</code>
	*/
	public function addEventObserver(scope:Object, eventName:String, eventHandler:String):Boolean {
		var eventFunction:String = (eventHandler == undefined) ? eventName : eventHandler;
		
		if (!TypeUtil.isTypeOf(scope[eventFunction], 'function'))
			return false;
		
		var observers:Array = this.$eventMap[eventName];
		
		if (observers == undefined)
			observers = this.$eventMap[eventName] = new Array();
		else {
			var len:Number = observers.length;
			while (len--)
				if (observers[len].scope == scope && observers[len].funct == eventFunction)
					return false;
		}
		
		var observer:Object = new Object();
		observer.scope      = scope;
		observer.funct      = eventFunction;
		
		observers.push(observer);
		
		return true;
	}
	
	/**
		{@inheritDoc}
		
		@param scope: {@inheritDoc}
		@param eventName: {@inheritDoc}
		@param eventHandler: {@inheritDoc}
		@return {@inheritDoc}
		@example <code>this.eventButton_mc.removeEventObserver(this, "onRollOver");</code>
	*/
	public function removeEventObserver(scope:Object, eventName:String, eventHandler:String):Boolean {
		var funct:String    = (eventHandler == undefined) ? eventName : eventHandler;
		var observers:Array = this.$eventMap[eventName];
		var len:Number      = observers.length;
		
		while (len--) {
			if (observers[len].scope == scope && observers[len].funct == funct) {
				observers.splice(len, 1, null);
				return true;
			}
		}
		
		return false;
	}
	
	/**
		{@inheritDoc}
		
		@param eventName: {@inheritDoc}
		@return {@inheritDoc}
		@example <code>this.eventButton_mc.removeEventObserversForEvent("onRollOver");</code>
	*/
	public function removeEventObserversForEvent(eventName:String):Boolean {
		if (this.$eventMap[eventName] == undefined)
			return false;
		
		delete this.$eventMap[eventName];
		
		return true;
	}
	
	/**
		{@inheritDoc}
		
		@param scope: {@inheritDoc}
		@return {@inheritDoc}
		@example <code>this.eventButton_mc.removeEventObserversForScope(this);</code>
	*/
	public function removeEventObserversForScope(scope:Object):Boolean {
		var removed:Boolean = false;
		var observers:Array;
		var len:Number;
		
		for (var i:String in this.$eventMap) {
			observers = this.$eventMap[i];
			len       = observers.length;
			
			while (len--) {
				if (observers[len].scope == scope) {
					observers.splice(len, 1, null);
					removed = true;
				}
			}
		}
		
		return removed;
	}
	
	public function removeAllEventObservers():Boolean {
		this.$eventMap = new Object();
		
		return true;
	}
	
	/**
		{@inheritDoc}
		
		@param eventName: {@inheritDoc}
		@param param(s): {@inheritDoc}
		@return {@inheritDoc}
		@example <code>this.dispatchEvent("onRelease", 5, true, "Aaron");</code>
	*/
	public function dispatchEvent(eventName:String):Boolean {
		var observers:Array = this.$eventMap[eventName];
		if (observers == undefined)
			return false;
		
		var i:Number              = -1;
		var originalLength:Number = observers.length;
		var dispatched:Boolean    = false;
		var observer:Object;
		
		while (++i < originalLength) {
			observer = observers[i];
			
			if (observer == null) {
				observers.splice(i, 1);
				
				if (observers.length == 0) {
					delete this.$eventMap[eventName];
					break;
				}
				
				i--;
				originalLength--;
			} else {
				observer.scope[observer.funct].apply(observer.scope, arguments.slice(1));
				dispatched = true;
			}
		}
		
		return dispatched;
	}
	
	public function destroy():Void {
		delete this.$eventMap;
		
		super.destroy();
	}
}
