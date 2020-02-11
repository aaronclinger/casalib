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

/**
	Creates a setter function for properties. Designed to be used with objects where methods require a function but you want to ultimately set a value of a property.
	
	@author Aaron Clinger
	@version 11/11/06
	@example
		<code>
			var buttonLock:PropertySetter = new PropertySetter(this.button_mc, "enabled");
			
			var timeOut:Interval = Interval.setTimeout(this.buttonLock, "defineProperty", 5000, false);
			this.timeOut.start();
		</code>
		or
		<code>
			var clipMove:PropertySetter = new PropertySetter(this.box_mc, "_x");
			
			var slideMotion:Tween = new Tween(com.robertpenner.easing.Bounce.easeOut, 0, 250, 1.5);
			this.slideMotion.addEventObserver(this.clipMove, Tween.EVENT_POSITION, "defineProperty");
			this.slideMotion.start();
		</code>
	@see {@link Interval} & {@link Tween}.
*/

class org.casalib.util.PropertySetter extends CoreObject {
	private var $scope:Object;
	private var $property:String;
	private var $argument:Number;
	
	/**
		Defines the property you wish to define with {@link #defineProperty}.
		
		@param scope: An object that contains the property specified by "property".
		@param property: Name of the property you want to assign the value of.
		@param argument: <strong>[optional]</strong> The position the value to assign falls in the argument order; defaults to <code>0</code>.
	*/
	public function PropertySetter(scope:Object, property:String, argument:Number) {
		if (scope[property] == undefined) return;
		
		this.$scope    = scope;
		this.$property = property;
		this.$argument = (argument == undefined) ? 0 : argument;
		
		this.$setClassDescription('org.casalib.util.PropertySetter');
	}
	
	/**
		Defines property with the value of the targeted argument.
	*/
	public function defineProperty():Void {
		this.$scope[this.$property] = arguments[this.$argument];
	}
	
	public function destroy():Void {
		delete this.$scope;
		delete this.$property;
		delete this.$argument;
		
		super.destroy();
	}
}