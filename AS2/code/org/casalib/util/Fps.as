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
import org.casalib.util.ArrayUtil;
import org.casalib.time.EnterFrame;
import org.casalib.time.Stopwatch;

/**
	Calculates the movie's frames per second.
	
	@author Aaron Clinger
	@version 12/14/06
	@since Flash Player 7
	@example
		<code>
			var movieFps:Fps = Fps.getInstance();
			this.movieFps.start();
			
			this.myButton_btn.onRelease = function():Void {
				trace(this._parent.movieFps.getFps());
			}
		</code>
*/

class org.casalib.util.Fps extends CoreObject implements RunnableInterface {
	private static var $fpsInstance:Fps;
	private var $pulseInstance:EnterFrame;
	private var $frameTimes: /*Number*/ Array;
	private var $stopwatch:Stopwatch;
	private var $frameTotal:Number;
	
	/**
		@return {@link Fps} instance.
	*/
	public static function getInstance():Fps {
		if (Fps.$fpsInstance == undefined)
			Fps.$fpsInstance = new Fps();
		
		return Fps.$fpsInstance;
	}
	
	private function Fps() {
		super();
		
		this.$stopwatch     = new Stopwatch();
		this.$frameTimes    = new Array();
		this.$pulseInstance = EnterFrame.getInstance();
		
		this.setFramesToAverage(20);
		
		this.$setClassDescription('org.casalib.util.Fps');
	}
	
	/**
		Calculates the current frames per second of the movie.
		
		@return The FPS.
	*/
	public function getFps():Number {
		return 1000 / ArrayUtil.average(this.$frameTimes);
	}
	
	/**
		Defines the amount of frames the class compares and averages.
		
		@param total: The amount of previous frames to average; defaults to <code>20</code>.
	*/
	public function setFramesToAverage(total:Number):Void {
		this.$frameTotal = total;
	}
	
	/**
		Starts observing the FPS and actively records and calulates the FPS.
	*/
	public function start():Void {
		this.$stopwatch.start();
		this.$pulseInstance.addEventObserver(this, EnterFrame.EVENT_ENTER_FRAME, '$onEnterFrame');
	}
	
	/**
		Stops observing the FPS.
	*/
	public function stop():Void {
		this.$pulseInstance.removeEventObserver(this, EnterFrame.EVENT_ENTER_FRAME, '$onEnterFrame');
	}
	
	private function $onEnterFrame():Void {
		this.$stopwatch.stop();
		this.$frameTimes.push(this.$stopwatch.getTime());
		
		if (this.$frameTimes.length > this.$frameTotal)
			this.$frameTimes.splice(0, 1);
		
		this.$stopwatch.start();
	}
}
