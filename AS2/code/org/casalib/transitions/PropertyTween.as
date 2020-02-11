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

import org.casalib.transitions.Tween;
import org.casalib.util.TypeUtil;
import org.casalib.util.PropertySetter;

/**
	A simple property tween class that extends {@link Tween}.
	
	@author Aaron Clinger
	@version 03/22/07
	@example
		<code>
			var boxMove:PropertyTween = new PropertyTween(this.box_mc, "_x", com.robertpenner.easing.Bounce.easeOut, 250, 2);
			boxMove.start();
		</code>
	@usageNote If you want to tween a value other than a property use {@link Tween}.
	@see <a href="http://www.robertpenner.com/easing/">Robert Penner's easing equations</a>
*/

class org.casalib.transitions.PropertyTween extends Tween {
	private var $init:Boolean;
	private var $scope:Object;
	private var $property:String;
	private var $propSetter:PropertySetter;
	
	
	/**
		Creates and defines property tween.
		
		@param scope: An object that contains the property specified by "property".
		@param property: Name of the property you want to tween.
		@param equation: Tween equation.
		@param endPos: The ending value of the tween.
		@param duration: Length of time of the tween.
		@param useFrames: <strong>[optional]</strong> Indicates to use frames <code>true</code>, or seconds <code>false</code> in relation to the value specified in the <code>duration</code> parameter; defaults to <code>false</code>.
		@usageNote Class uses the property's current value when {@link #start} is called as the starting position.
	*/
	public function PropertyTween(scope:Object, property:String, equation:Function, endPos:Number, duration:Number, useFrames:Boolean) {
		super(equation, 0, endPos, duration, useFrames);
		
		this.$setClassDescription('org.casalib.transitions.PropertyTween');
		
		if (!TypeUtil.isTypeOf(scope[property], 'number')) {
			this.destroy();
			return;
		}
		
		this.$init     = false;
		this.$scope    = scope;
		this.$property = property;
		
		this.$propSetter = new PropertySetter(this.$scope, this.$property, 1);
		this.addEventObserver(this.$propSetter, Tween.EVENT_POSITION, 'defineProperty');
	}
	
	public function start():Void {
		if (this.$destroyed)
			return;
		
		this.$initPropertyTween();
		
		super.start();
	}
	
	public function resume():Void {
		if (this.$destroyed)
			return;
		
		if (!this.$init) {
			this.start();
			return;
		}
		
		super.resume();
	}
	
	public function continueTo(endPos:Number, duration:Number):Void {
		if (this.$destroyed)
			return;
		
		this.$initPropertyTween();
		
		super.continueTo(endPos, duration);
	}
	
	/**
		Retrieves the object defined as scope in the class' constructor.
		
		@return Returns the object whose property is being tweened.
	*/
	public function getScope():Object {
		return this.$scope;
	}
	
	/**
		Retrieves the property string defined in the class' constructor.
		
		@return Returns the name of property being tweened.
	*/
	public function getProperty():String {
		return this.$property;
	}
	
	/**
		@exclude
	*/
	public function removeEventObserversForEvent(eventName:String):Boolean {
		var removed:Boolean = super.removeEventObserversForEvent(eventName);
		
		if (eventName == Tween.EVENT_POSITION)
			this.addEventObserver(this.$propSetter, Tween.EVENT_POSITION, 'defineProperty');
		
		return removed;
	}
	
	/**
		@exclude
	*/
	public function removeAllEventObservers():Boolean {
		var removed:Boolean = super.removeAllEventObservers();
		
		this.addEventObserver(this.$propSetter, Tween.EVENT_POSITION, 'defineProperty');
		
		return removed;
	}
	
	private function $initPropertyTween():Void {
		this.$begin = this.$currentPosition = this.$scope[this.$property];
		this.$diff  = this.$end - this.$begin;
		this.$init  = true;
	}
	
	public function destroy():Void {
		this.$propSetter.destroy();
		
		delete this.$init;
		delete this.$scope;
		delete this.$property;
		delete this.$propSetter;
		
		super.destroy();
	}
}