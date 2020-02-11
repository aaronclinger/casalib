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
import org.casalib.time.FrameDelay;

/**
	Allows the implementation of event observers that provide status information while SWF, JPEG, GIF, and PNG files are being loaded into a MovieClip or level. This is designed to replace <code>loadMovie()</code>.
	
	Advantages over MovieClipLoader &amp; <code>loadMovie</code>:
	<ul>
		<li>Includes {@link RetryableLoad#setLoadRetries} and {@link BytesLoad#setLoadTimeout}.</li>
		<li>Sends load events using {@link EventDispatcher}.</li>
		<li>Does not immediatly start loading on definition. Load can be started at anytime with {@link Load#start}.</li>
		<li>Built in {@link Load#stop} which ends a current load or unloads a completed load.</li>
		<li>Option to hide content until file has completely loaded.</li>
	</ul>
	
	@author Aaron Clinger
	@version 01/26/07
	@since Flash Player 7
	@example
		<code>
			this.createEmptyMovieClip("loadZone_mc", this.getNextHighestDepth());
			
			function onImageLoadProgress(sender:MediaLoad, bytesLoaded:Number, bytesTotal:Number):Void {
				trace(bytesLoaded + "/" + bytesTotal + " bytes have been loaded into " + sender.getMovieClip());
			}
			
			var mediaLoad:MediaLoad = new MediaLoad(this.loadZone_mc, "test.jpg");
			this.mediaLoad.addEventObserver(this, MediaLoad.EVENT_LOAD_PROGRESS, "onImageLoadProgress");
			this.mediaLoad.start();
		</code>
*/

class org.casalib.load.media.MediaLoad extends BytesLoad {
	private var $target:MovieClip;
	private var $hideLoad:Boolean;
	
	/**
		Defines file and location of load triggered by {@link Load#start start}.
		
		@param target_mc: A path to a MovieClip container where the file specified by <code>filePath</code> should be loaded into.
		@param filePath: The absolute or relative URL of the SWF, JPEG, GIF, or PNG file to be loaded.
		@param hideUntilLoaded: <strong>[optional]</strong> Indicates to hide <code>target_mc</code> and its contents until file has completely loaded <code>true</code>, or to display contents while loading <code>false</code>; defaults to <code>false</code>.
		@usageNote Loading of GIF or PNG is only allowed when publishing to Flash Player 8 or greater.
	*/
	public function MediaLoad(target_mc:MovieClip, filePath:String, hideUntilLoaded:Boolean) {
		super(target_mc, filePath);
		
		this.$hideLoad  = (hideUntilLoaded != undefined) ? hideUntilLoaded : false;
		
		this.$setClassDescription('org.casalib.load.media.MediaLoad');
	}
	
	/**
		@return Returns MovieClip specified in {@link #MediaLoad}.
	*/
	public function getMovieClip():MovieClip {
		return this.$target;
	}
	
	public function destroy():Void {
		delete this.$hideLoad;
		
		super.destroy();
	}
	
	private function $startLoad():Void {
		if (this.$target.getBytesLoaded() > 4) {
			this.$stopLoad();
			
			this.$isLoading = true;
			
			this.$frameDelay = new FrameDelay(this, '$startLoad');
			this.$frameDelay.start();
			return;
		}
		
		super.$startLoad();
		this.$target.loadMovie(this.getFilePath());
	}
	
	private function $stopLoad():Void {
		super.$stopLoad();
		this.$target.unloadMovie();
	}
	
	private function $loadProgress(bytesLoaded:Number, currentTime:Number):Void {
		super.$loadProgress(bytesLoaded, currentTime);
		
		if (!this.$isProgressing)
			if (this.$hideLoad)
				this.$target._visible = false;
	}
	
	private function $onComplete():Void {
		super.$onComplete();
		
		if (this.$hideLoad)
			this.$target._visible = true;
	}
}