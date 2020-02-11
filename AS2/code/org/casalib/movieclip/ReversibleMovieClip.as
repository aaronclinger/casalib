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

import org.casalib.time.EnterFrame;
import org.casalib.movieclip.CoreMovieClip;

/**
	Extends MovieClip to provide additional timeline controlling functions: {@link #playBackwards} and {@link #gotoAndPlayBackwards}.
	
	@author Aaron Clinger
	@version 04/09/07
	@since Flash Player 7
	@example <code>this.backwards_mc.gotoAndPlayBackwards("frameLabel");</code>
	@usageNote When calling timeline contolling functions (<code>stop</code>, <code>gotoAndStop</code>, <code>play</code> and <code>gotoAndPlay</code>) from inside a MovieClip extended by {@link ReversibleMovieClip} ALWAYS prefix with <code>this</code>. Example:

	<code>this.stop();</code>

	This way the class' methods will handle the call instead of the global function equivalent.
*/

class org.casalib.movieclip.ReversibleMovieClip extends CoreMovieClip {
	private var $playingInReverse:Boolean;
	private var $reverseController:EnterFrame;
	
	
	/**
		@exclude
		
		To prevent blank instance creation of ReversibleMovieClip and classes that extend it.
	*/
	private static function create():Void {}
	
	
	private function ReversibleMovieClip() {
		super();
		
		this.$reverseController = EnterFrame.getInstance();
		this.$playingInReverse  = false;
		
		this.$setClassDescription('org.casalib.movieclip.ReversibleMovieClip');
	}
	
	/**
		Plays the Timeline in reverse from current playhead position.
	*/
	public function playBackwards():Void {
		this.$playInReverse();
	}
	
	/**
		Sends the playhead to the specified frame on the Timeline and plays in reverse from that frame.
		
		@param frame: A number representing the frame number, or a string representing the label of the frame, to which the playhead is sent.
	*/
	public function gotoAndPlayBackwards(frame:Object):Void {
		this.gotoAndStop(frame);
		this.$playInReverse();
	}
	
	/**
		@exclude
	*/
	public function gotoAndPlay(frame:Object):Void {
		this.$stopReversing();
		super.gotoAndPlay(frame);
	}
	
	/**
		@exclude
	*/
	public function gotoAndStop(frame:Object):Void {
		this.$stopReversing();
		super.gotoAndStop(frame);
	}
	
	/**
		@exclude
	*/
	public function play():Void {
		this.$stopReversing();
		super.play();
	}
	
	/**
		@exclude
	*/
	public function stop():Void {
		this.$stopReversing();
		super.stop();
	}
	
	/**
		Returns if the MovieClip is or isn't playing in reverse.
		
		@return Returns <code>true</code> if the MovieClip is currently playing in reverse; otherwise <code>false</code>.
	*/
	public function isPlayingBackwards():Boolean {
		return this.$playingInReverse;
	}
	
	public function destroy():Void {
		this.$reverseController.removeEventObserversForScope(this);
		
		delete this.$playingInReverse;
		delete this.$reverseController;
		
		super.destroy();
	}
	
	private function $stopReversing():Void {
		if (!this.$playingInReverse) return;
		this.$playingInReverse = false;
		
		this.$reverseController.removeEventObserver(this, EnterFrame.EVENT_ENTER_FRAME, '$gotoFrameBefore');
	}
	
	private function $playInReverse():Void {
		if (this.$playingInReverse) return;
		this.$playingInReverse = true;
		
		this.$reverseController.addEventObserver(this, EnterFrame.EVENT_ENTER_FRAME, '$gotoFrameBefore');
	}
	
	private function $gotoFrameBefore():Void {
		if (this._currentframe == 1) {
			// Calling another function to fix super scope event bug.
			this.$gotoLastFrame();
		} else this.prevFrame();
	}
	
	private function $gotoLastFrame():Void {
		super.gotoAndStop(this._totalframes);
	}
}