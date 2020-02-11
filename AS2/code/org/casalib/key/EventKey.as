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
	Dispatches key events to observers. Should be used instead of <code>Key.addListener</code>.
	
	@author Aaron Clinger
	@version 10/16/06
	@example
		<code>
			function onKeyDown(code:Number, ascii:Number):Void {
				trace("Code: " + code + "\tACSII: " + ascii + "\tKey: " + String.fromCharCode(ascii));
			}
	
			var keyInstance:EventKey = EventKey.getInstance();
			this.keyInstance.addEventObserver(this, EventKey.EVENT_KEY_DOWN);
		</code>
*/

class org.casalib.key.EventKey extends EventDispatcher {
	public static var EVENT_KEY_UP:String   = 'onKeyUp';
	public static var EVENT_KEY_DOWN:String = 'onKeyDown';
	private static var $keyInstance:EventKey;
	
	/**
		@return {@link EventKey} instance.
	*/
	public static function getInstance():EventKey {
		if (EventKey.$keyInstance == undefined) EventKey.$keyInstance = new EventKey(); 
		return EventKey.$keyInstance;
	}
	
	private function EventKey() {
		super();
		
		Key.addListener(this);
		
		this.$setClassDescription('org.casalib.key.EventKey');
	}
	
	/**
		@sends onKeyDown = function(code:Number, ascii:Number) {}
	*/
	private function onKeyDown():Void {
		this.dispatchEvent(EventKey.EVENT_KEY_DOWN, Key.getCode(), Key.getAscii());
	}
	
	/**
		@sends onKeyUp = function(code:Number, ascii:Number) {}
	*/
	private function onKeyUp():Void {
		this.dispatchEvent(EventKey.EVENT_KEY_UP, Key.getCode(), Key.getAscii());
	}
}
