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

import org.casalib.time.Interval;

/**
	GetUrlSequencer delays/spaces out <code>getURL</code> requests to prevent browsers from choking from too many requests sent quickly in succession.
	
	@author Aaron Clinger
	@version 06/05/07
	@example
		<code>
			GetUrlSequencer.getURL("javascript:alert('call one');");
			GetUrlSequencer.getURL("javascript:alert('call two');");
			GetUrlSequencer.getURL("javascript:alert('call three');");
		</code>
*/

class org.casalib.util.GetUrlSequencer {
	private static var $queue:Array;
	private static var $delay:Number = 250;
	private static var $hasInit:Boolean;
	private static var $interval:Interval;
	
	/**
		Loads a document from a specific URL into a window or passes variables to another application at a defined URL.
		
		@param url: The URL from which to obtain the document.
		@param window: <strong>[optional]</strong> Specifies the window or HTML frame into which the document should load.
		@param method: <strong>[optional]</strong> A <code>GET</code> or <code>POST</code> method for sending variables.
		@usageNote This acts identical to flash's native <code>getURL</code>.
	*/
	public static function getURL(url:String, window:String, method:String):Void {
		if (!GetUrlSequencer.$hasInit)
			GetUrlSequencer.$init();
		
		GetUrlSequencer.$queue.push({u:url, w:window, m:method});
		
		if (!GetUrlSequencer.$interval.isFiring())
			GetUrlSequencer.$interval.start();
	}
	
	/**
		Changes the delay/spacing between <code>getURL</code> calls.
		
		@param delay: The time in milliseconds between calls.
		@usageNote Class defaults to <code>250</code> milliseconds between <code>getURL</code> calls.
	*/
	public static function changeDelay(delay:Number):Void {
		if (GetUrlSequencer.$hasInit)
			GetUrlSequencer.$interval.changeDelay(delay);
		else
			GetUrlSequencer.$delay = delay;
	}
	
	private static function $init():Void {
		GetUrlSequencer.$queue    = new Array();
		GetUrlSequencer.$interval = Interval.setInterval(GetUrlSequencer, "$sendRequest", GetUrlSequencer.$delay);
		GetUrlSequencer.$hasInit  = true;
	}
	
	private static function $sendRequest():Void {
		var request:Object = GetUrlSequencer.$queue.shift();
		_root.getURL(request.u, request.w, request.m);
		
		if (GetUrlSequencer.$queue.length == 0)
			GetUrlSequencer.$interval.stop();
	}
	
	
	private function GetUrlSequencer() {} // Prevents instance creation
}	