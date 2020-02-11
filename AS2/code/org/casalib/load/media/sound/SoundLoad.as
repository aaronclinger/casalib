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

import org.casalib.load.base.BytesLoad;

/**
	Eases the chore of loading mp3s.
	
	@author Aaron Clinger
	@version 01/26/07
	@since Flash Player 7
	@usageNote This class only works with event sounds and does not support streaming sounds. Event <code>onInstantiate</code> is called once the first loaded byte(s) have been received.
	@example
		<code>
			function onSoundComplete(sender:SoundLoad):Void {
				sender.getSound().start();
			}
			
			function onSoundLoading(sender:SoundLoad, bytesLoaded:Number, bytesTotal:Number):Void {
				trace(bytesLoaded + "/" + bytesTotal + " bytes have been loaded into " + sender.getMovieClip());
			}
			
			this.createEmptyMovieClip("soundContainer_mc", this.getNextHighestDepth());
			
			var audioClip:SoundLoad = new SoundLoad(this.soundContainer_mc, "audio.mp3");
			this.audioClip.addEventObserver(this, SoundLoad.EVENT_LOAD_COMPLETE, "onSoundComplete");
			this.audioClip.addEventObserver(this, SoundLoad.EVENT_LOAD_PROGRESS, "onSoundLoading");
			this.audioClip.start();
		</code>
*/

class org.casalib.load.media.sound.SoundLoad extends BytesLoad {
	private var $sound:Sound;
	private var $target:MovieClip;
	private var $isUnloading:Boolean;
	
	
	/**
		Defines file and location of load triggered by {@link Load#start start}.
		
		@param target_mc: The MovieClip instance on which the Sound object operates.
		@param mp3Path: The absolute or relative URL of the MP3 file to be loaded.
	*/
	public function SoundLoad(target_mc:MovieClip, mp3Path:String) {
		super(target_mc, mp3Path);
		
		this.$sound = new Sound(target_mc);
		
		this.$remapOnLoadHandler(this.$sound);
		
		this.$setClassDescription('org.casalib.load.media.sound.SoundLoad');
	}
	
	/**
		@return Returns the sound object SoundLoad class is wrapping and loading.
	*/
	public function getSound():Sound {
		return this.$sound;
	}
	
	/**
		@return Returns MovieClip specified as <code>target_mc</code> in {@link #SoundLoad}.
	*/
	public function getMovieClip():MovieClip {
		return this.$target;
	}
	
	public function getBytesLoaded():Number {
		return this.$sound.getBytesLoaded();
	}
	
	public function getBytesTotal():Number {
		return this.$sound.getBytesTotal();
	}
	
	public function destroy():Void {
		delete this.$sound;
		delete this.$isUnloading;
		
		super.destroy();
	}
	
	private function $startLoad():Void {
		super.$startLoad();
		
		delete this.$isUnloading;
		this.$sound.loadSound(this.getFilePath(), false);
	}
	
	private function $stopLoad():Void {
		super.$stopLoad();
		
		this.$isUnloading = true;
		this.$sound.loadSound(null, false); // Cancels the current load.
	}
	
	private function $onLoad(success:Boolean):Void {
		if (!this.$isUnloading)
			super.$onLoad(success);
		else
			delete this.$isUnloading;
	}
	
	private function $checkForLoadComplete():Void {}
}