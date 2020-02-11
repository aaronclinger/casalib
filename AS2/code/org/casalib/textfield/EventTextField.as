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

import org.casalib.textfield.DispatchableTextField;
import org.casalib.util.MovieClipUtil;

/**
	Dispatches TextField event handler notification using {@link EventDispatcher}.
	
	@author Aaron Clinger
	@version 06/21/07
	@example
		<code>
			function onTextChanged(sender:EventTextField):Void {
				trace("Text has changed to: " + sender.text);
			}
			
			var myText_mc:EventTextField = EventTextField.create(this, "text_mc", null, 250, 50);
			this.myText_mc.border = this.myText_mc.background = true;
			this.myText_mc.type = "input";
			this.myText_mc.text = "Hello World!";
			this.myText_mc.addEventObserver(this, EventTextField.EVENT_CHANGED, "onTextChanged");
		</code>
	@see {@link CoreTextField}
*/

class org.casalib.textfield.EventTextField extends DispatchableTextField {
	public static var EVENT_CHANGED:String    = 'onChanged';
	public static var EVENT_KILL_FOCUS:String = 'onKillFocus';
	public static var EVENT_SCROLLER:String   = 'onScroller';
	public static var EVENT_SET_FOCUS:String  = 'onSetFocus';
	
	
	/**
		Creates an empty instance of the EventTextField class. Use this instead of a traditional <code>new</code> constructor statement due to limitations of ActionScript 2.0.
		
		@param target: Location where the TextField should be attached.
		@param instanceName: A unique instance name for the TextField.
		@param depth: <strong>[optional]</strong> The depth level where the TextField is placed; defaults to next highest open depth.
		@param width: A positive integer that specifies the width of the new text field.
		@param height: A positive integer that specifies the height of the new text field.
		@return Returns a reference to the created instance.
		@example <code>var myText_mc:EventTextField = EventTextField.create(this, "text_mc", null, 250, 50);</code>
		@since Flash Player 7
	*/
	public static function create(target:MovieClip, instanceName:String, depth:Number, width:Number, height:Number):EventTextField {
		var tf:EventTextField = EventTextField(MovieClipUtil.createMovieRegisterClass('org.casalib.textfield.EventTextField', target, instanceName, depth));
		
		tf.width  = width;
		tf.height = height;
		
		return tf;
	}
	
	
	private function EventTextField() {
		super();
		
		this.$setClassDescription('org.casalib.textfield.EventTextField');
	}
	
	/**
		@exclude
		@sends onChanged = function(sender:EventTextField) {}
	*/
	public function onChanged():Void {
		this.dispatchEvent(EventTextField.EVENT_CHANGED, this);
	}
	
	/**
		@exclude
		@sends onKillFocus = function(sender:EventTextField, newFocus:Object) {}
	*/
	public function onKillFocus(newFocus:Object):Void {
		this.dispatchEvent(EventTextField.EVENT_KILL_FOCUS, this, newFocus);
	}
	
	/**
		@exclude
		@sends onScroller = function(sender:EventTextField) {}
	*/
	public function onScroller():Void {
		this.dispatchEvent(EventTextField.EVENT_SCROLLER, this);
	}
	
	/**
		@exclude
		@sends onSetFocus = function(sender:EventTextField, oldFocus:Object) {}
	*/
	public function onSetFocus(oldFocus:Object):Void {
		this.dispatchEvent(EventTextField.EVENT_SET_FOCUS, this, oldFocus);
	}
}