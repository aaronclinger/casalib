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

/**
	Dispatches mouse events to observers. Should be used instead of <code>Mouse.addListener</code>.
	
	@author Aaron Clinger
	@version 9/11/07
	@example
		<code>
			function onMouseMove():Void {
				trace("Mouse position is x:" + _root._xmouse + " y:" + _root._ymouse + ".");
			}
			
			var mouseInstance:EventMouse = EventMouse.getInstance();
			this.mouseInstance.addEventObserver(this, EventMouse.EVENT_MOUSE_MOVE);
		</code>
*/

class org.casalib.mouse.EventMouse extends EventDispatcher {
	public static var EVENT_MOUSE_DOWN:String  = 'onMouseDown';
	public static var EVENT_MOUSE_MOVE:String  = 'onMouseMove';
	public static var EVENT_MOUSE_UP:String    = 'onMouseUp';
	public static var EVENT_MOUSE_WHEEL:String = 'onMouseWheel';
	private static var $mouseInstance:EventMouse;
	private var $mouseDown:Boolean;
	
	/**
		@return {@link EventMouse} instance.
	*/
	public static function getInstance():EventMouse {
		if (EventMouse.$mouseInstance == undefined)
			EventMouse.$mouseInstance = new EventMouse();
		
		return EventMouse.$mouseInstance;
	}
	
	/**
		Determines whether the mouse is currently pressed.
		
		@return Returns <code>true</code> if the mouse is down; otherwise <code>false</code>.
	*/
	public static function isDown():Boolean {
		var instance:EventMouse = EventMouse.getInstance();
		
		return instance.$mouseDown;
	}
	
	private function EventMouse() {
		super();
		
		this.$mouseDown = false;
		
		Mouse.addListener(this);
		
		this.$setClassDescription('org.casalib.mouse.EventMouse');
	}
	
	/**
		@sends onMouseDown = function() {}
	*/
	private function onMouseDown():Void {
		this.$mouseDown = true;
		
		this.dispatchEvent(EventMouse.EVENT_MOUSE_DOWN);
	}
	
	/**
		@sends onMouseMove = function() {}
	*/
	private function onMouseMove():Void {
		this.dispatchEvent(EventMouse.EVENT_MOUSE_MOVE);
	}
	
	/**
		@sends onMouseUp = function() {}
	*/
	private function onMouseUp():Void {
		this.$mouseDown = false;
		
		this.dispatchEvent(EventMouse.EVENT_MOUSE_UP);
	}
	
	/**
		@sends onMouseWheel = function(delta:Number, scrollTarget:String) {}
	*/
	private function onMouseWheel(delta:Number, scrollTarget:String):Void {
		this.dispatchEvent(EventMouse.EVENT_MOUSE_WHEEL, delta, scrollTarget);
	}
}
