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

import org.casalib.movieclip.ReversibleMovieClip;
import org.casalib.time.EnterFrame;
import org.casalib.util.ArrayUtil;

/**
	Gives the ability to dynamically place and change <code>stop()</code> actions on frames.

	@author Aaron Clinger
	@version 04/09/07
	@since Flash Player 7
	@example This will start playing a MovieClip at frame 5 and will stop once the MovieClip has reached frame 10:
		<code>
			this.stoppable_mc.addStopFrame(10);
		</code>
	@usageNote See {@link ReversibleMovieClip}.
*/

class org.casalib.movieclip.StoppableMovieClip extends ReversibleMovieClip {
	private var $stopFrames:Array;
	private var $framePulse:EnterFrame;
	private var $hasStoppedBefore:Boolean;
	
	
	private function StoppableMovieClip() {
		super();
		
		this.$framePulse       = EnterFrame.getInstance();
		this.$stopFrames       = new Array();
		this.$hasStoppedBefore = false;
		
		this.$setClassDescription('org.casalib.movieclip.StoppableMovieClip');
	}
	
	/**
		Marks a frame which will trigger <code>stop</code> when playhead reaches it.

		@param frame: A number representing the frame number.
		@return Returns <code>true</code> frame was successfully added and unique; otherwise <code>false</code>.
	*/
	public function addStopFrame(frame:Number):Boolean {
		if (frame > this._totalframes || ArrayUtil.contains(this.$stopFrames, frame) > 0) return false;
		this.$stopFrames.push(frame);
		
		if (!this.$hasStoppedBefore) this.$addStopFrameCheck();
		
		return true;
	}
	
	/**
		Removes frame number from triggering <code>stop</code> when playhead reaches.

		@param frame: A number representing the frame number.
		@return Returns <code>true</code> frame was found and removed; otherwise <code>false</code>.
	*/
	public function removeStopFrame(frame:Number):Boolean {
		return ArrayUtil.removeArrayItem(this.$stopFrames, frame) >= 1;
	}
	
	private function $addStopFrameCheck():Void {
		if (this.$stopFrames.length == 0) return;
		this.$framePulse.addEventObserver(this, EnterFrame.EVENT_ENTER_FRAME, '$checkForStopFrame');
	}
	
	private function $checkForStopFrame():Void {
		if (ArrayUtil.contains(this.$stopFrames, this._currentframe) > 0) this.stop();
	}
	
	/**
		@exclude 
	*/
	public function playBackwards():Void {
		this.$addStopFrameCheck();
		super.playBackwards();
	}
	
	/**
		@exclude 
	*/
	public function gotoAndPlayBackwards(frame:Object):Void {
		this.$addStopFrameCheck();
		super.gotoAndPlayBackwards(frame);
	}
	
	/**
		@exclude
	*/
	public function gotoAndPlay(frame:Object):Void {
		this.$addStopFrameCheck();
		super.gotoAndPlay(frame);
	}
	
	/**
		@exclude
	*/
	public function play():Void {
		this.$addStopFrameCheck();
		super.play();
	}
	
	/**
		@exclude
	*/
	public function stop():Void {
		this.$hasStoppedBefore = true;
		this.$framePulse.removeEventObserver(this, EnterFrame.EVENT_ENTER_FRAME, '$checkForStopFrame');
		super.stop();
	}
	
	/**
		@exclude 
	*/
	public function gotoAndStop(frame:Object):Void {
		this.$hasStoppedBefore = true;
		this.$framePulse.removeEventObserver(this, EnterFrame.EVENT_ENTER_FRAME, '$checkForStopFrame');
		super.gotoAndStop(frame);
	}
	
	public function destroy():Void {
		this.$framePulse.removeEventObserversForScope(this);
		
		delete this.$stopFrames;
		delete this.$framePulse;
		delete this.$hasStoppedBefore;
		
		super.destroy();
	}
}