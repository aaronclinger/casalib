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
	Creates "onEnterFrame" events. Can be used instead of all <code>onEnterFrame</code>'s, and to mimic the MovieClip property in object classes.
	
	@author Aaron Clinger
	@author Mike Creighton
	@version 06/27/07
	@since Flash Player 7
	@example
		<code>
			function onFrameFire():Void {
				trace("I will be called every frame.");
			}
			
			var pulseInstance:EnterFrame = EnterFrame.getInstance();
			this.pulseInstance.addEventObserver(this, EnterFrame.EVENT_ENTER_FRAME, "onFrameFire");
		</code>
*/

class org.casalib.time.EnterFrame extends EventDispatcher {
	public  static var EVENT_ENTER_FRAME:String = 'onEnterFrame';
	private static var $pulseInstance:EnterFrame;
	private static var $pulseMovieClip:MovieClip;
	
	/**
		@return {@link EnterFrame} instance.
	*/
	public static function getInstance():EnterFrame {
		if (EnterFrame.$pulseInstance == undefined)
			EnterFrame.$pulseInstance = new EnterFrame();
		else if (EnterFrame.$pulseMovieClip.onEnterFrame == undefined)
			EnterFrame.$pulseInstance.$createBeacon();
		
		return EnterFrame.$pulseInstance;
	}
	
	/**
		@sends onEnterFrame = function() {}
	*/
	private function EnterFrame() {
		super();
		
		this.$createBeacon();
		
		this.$setClassDescription('org.casalib.time.EnterFrame');
	}
	
	private function $createBeacon():Void {
		EnterFrame.$pulseMovieClip = _root.createEmptyMovieClip('framePulse_mc', _root.getNextHighestDepth());
		var context:EnterFrame     = this;
		EnterFrame.$pulseMovieClip.onEnterFrame = function():Void {
			context.dispatchEvent(EnterFrame.EVENT_ENTER_FRAME);
		};
	}
}
