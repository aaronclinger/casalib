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
import org.casalib.time.EnterFrame;

/**
	Creates a common time which isn't affected by delays caused by code execution; the time is only updated every frame.
	
	@author Aaron Clinger
	@version 08/02/07
	@example
		<code>
			var frameTimeInstance:FrameTime = FrameTime.getInstance();
			var field:TextField;
			var total:Number = 25;
			
			while (total--) {
				var field = this.createTextField("timer" + total + "_txt", this.getNextHighestDepth(), 0, total * 22, 500, 22);
				field.text = "Time when this field was created = " + frameTimeInstance.getTime();
			}
		</code>
*/

class org.casalib.time.FrameTime extends CoreObject {
	private static var $frameTimeInstance:FrameTime;
	private var $enterFrame:EnterFrame;
	private var $time:Number;
	
	
	/**
		@return {@link FrameTime} instance.
	*/
	public static function getInstance():FrameTime {
		if (FrameTime.$frameTimeInstance == undefined)
			FrameTime.$frameTimeInstance = new FrameTime();
		
		return FrameTime.$frameTimeInstance;
	}
	
	private function FrameTime() {
		super();
		
		this.$enterFrame = EnterFrame.getInstance();
		this.$enterFrame.addEventObserver(this, EnterFrame.EVENT_ENTER_FRAME, '$updateTime');
		
		this.$updateTime();
		
		this.$setClassDescription('org.casalib.time.FrameTime');
	}
	
	/**
		@return Returns the number of milliseconds from when the SWF started playing to the last <code>onEnterFrame</code> event.
	*/
	public function getTime():Number {
		return this.$time;
	}
	
	private function $updateTime():Void {
		this.$time = getTimer();
	}
}