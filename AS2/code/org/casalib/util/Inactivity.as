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
import org.casalib.mouse.EventMouse;
import org.casalib.time.Interval;
import org.casalib.key.EventKey;

/**
	Detects user inactivity by checking for a void in mouse movement and key presses.
	
	@author Aaron Clinger
	@version 07/13/08
	@example
		<code>
			function onInactive(sender:Object):Void {
				trace("User has been inactive for 5 seconds.");
			}
			
			function onReactive(sender:Object):Void {
				trace("User has resumed activity.");
			}
			
			var inactivityDetect:Inactivity = new Inactivity(5000);
			this.inactivityDetect.addEventObserver(this, Inactivity.EVENT_INACTIVE);
			this.inactivityDetect.addEventObserver(this, Inactivity.EVENT_REACTIVE);
		</code>
*/

class org.casalib.util.Inactivity extends EventDispatcher {
	public static var EVENT_INACTIVE:String = 'onInactive';
	public static var EVENT_REACTIVE:String = 'onReactive';
	
	private var $keyInstance:EventKey;
	private var $mouseInstance:EventMouse;
	private var $inactiveInterval:Interval;
	
	
	/**
		Creates Inactivity object, and defines time until user is inactive.
		
		@param timeUntilInactive: The time in milliseconds until a user is considered inactive.
		@sends onInactive = function(sender:Inactivity) {}
	*/
	public function Inactivity(timeUntilInactive:Number) {
		super();
		
		this.$mouseInstance = EventMouse.getInstance();
		this.$mouseInstance.addEventObserver(this, EventMouse.EVENT_MOUSE_MOVE, '$userInput');
		
		this.$keyInstance = EventKey.getInstance();
		this.$keyInstance.addEventObserver(this, EventKey.EVENT_KEY_DOWN, '$userInput');
		
		this.$inactiveInterval = Interval.setTimeout(this, 'dispatchEvent', timeUntilInactive, Inactivity.EVENT_INACTIVE, this);
		this.$inactiveInterval.start();
		
		this.$setClassDescription('org.casalib.util.Inactivity');
	}
	
	public function destroy():Void {
		this.$inactiveInterval.destroy();
		
		this.$mouseInstance.removeEventObserver(this, EventMouse.EVENT_MOUSE_MOVE, '$userInput');
		this.$keyInstance.removeEventObserver(this, EventKey.EVENT_KEY_DOWN, '$userInput');
		
		delete this.$keyInstance;
		delete this.$mouseInstance;
		delete this.$inactiveInterval;
		
		super.destroy();
	}
	
	/**
		@sends onReactive = function(sender:Inactivity) {}
	*/
	private function $userInput():Void {
		if (!this.$inactiveInterval.isFiring())
			this.dispatchEvent(Inactivity.EVENT_REACTIVE, this);
		
		this.$inactiveInterval.start();
	}
}