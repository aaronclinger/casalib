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
import org.casalib.control.RunnableInterface;
import org.casalib.time.EnterFrame;

/**
	Creates a callback after one or more frames have been fired. Helps prevent race conditions by allowing recently created MovieClips, Classed, etc... a frame to initialize before proceeding. Should only need a single frame because <code>onEnterFrame</code> should only occur when all frame jobs are finished.
	
	@author Aaron Clinger
	@version 03/21/08
	@since Flash Player 7
	@example
		<code>
			class Example {
				public function Example() {
					// A lot of inits, attachMovies, etc...
					
					var initDelay:FrameDelay = new FrameDelay(this, "initComplete");
					initDelay.start();
				}
				
				public function initComplete():Void {
					// Safe to execute code
				}
			}
		</code>
		
		When starting a SWF or after attaching a movie:
		<code>
			var initDelay:FrameDelay = new FrameDelay(this, "initComplete", 1, "Aaron", 1984);
			this.initDelay.start();
			
			function initComplete(firstName:String, birthYear:Number):Void {
				trace(firstName + " was born in " + birthYear);
			}
		</code>
*/

class org.casalib.time.FrameDelay extends CoreObject implements RunnableInterface {
	private var $scope:Object;
	private var $methodName:String;
	private var $frames:Number;
	private var $fires:Number;
	private var $arguments:Array;
	private var $enterFrameInstance:EnterFrame;
	
	/**
		Defines {@link FrameDelay} object.
		
		@param scope: An object that contains the method specified by "methodName".
		@param methodName: A method that exists in the scope of the object specified by "scope".
		@param frames: <strong>[optional]</strong> The number of frames to wait before calling "methodName". <code>frames</code> defaults to <code>1</code>.
		@param param(s): <strong>[optional]</strong> Parameters passed to the function specified by "methodName". Multiple parameters are allowed and should be separated by commas: param1,param2, ...,paramN
	*/
	public function FrameDelay(scope:Object, methodName:String, frames:Number, param:Object) {
		super();
		
		this.$setClassDescription('org.casalib.time.FrameDelay');
		
		this.$scope      = scope;
		this.$methodName = methodName;
		this.$frames     = (frames == undefined || frames == null) ? 1 : frames;
		this.$arguments  = arguments.slice(3);
	}
	
	/**
		Starts or restarts the frame delay.
	*/
	public function start():Void {
		this.$fires = 0;
		this.$enterFrameInstance = EnterFrame.getInstance();
		this.$enterFrameInstance.addEventObserver(this, EnterFrame.EVENT_ENTER_FRAME, '$onFrameFire');
	}
	
	/**
		Stops the frame delay from completing.
	*/
	public function stop():Void {
		this.$enterFrameInstance.removeEventObserver(this, EnterFrame.EVENT_ENTER_FRAME, '$onFrameFire');
		delete this.$enterFrameInstance;
		delete this.$fires;
	}
	
	public function destroy():Void {
		this.stop();
		
		delete this.$scope;
		delete this.$methodName;
		delete this.$frames;
		delete this.$arguments;
		
		super.destroy();
	}
	
	private function $onFrameFire():Void {
		if (++this.$fires >= this.$frames) {
			this.stop();
			this.$scope[this.$methodName].apply(this.$scope, this.$arguments);
		}
	}
}