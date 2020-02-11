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
import org.casalib.util.LoadUtil;
import org.casalib.math.Percent;
import org.casalib.time.Interval;

/**
	Provides an easy way to load FLVs and includes additional events notifying buffer progress.
	
	@author Aaron Clinger
	@version 04/10/08
	@since Flash Player 7
	@example
		<code>
			function onBufferProgress(sender:FlvLoad, percentBuffered:Percent, secondsTillBuffered:Number):Void {
				trace("Video " + Math.round(percentBuffered.getPercentage()) +"% buffered.");
				trace("Video will be buffered in " + Math.round(secondsTillBuffered) + " seconds.");
			}
			
			function onBufferComplete(sender:FlvLoad):Void {
				this.flvLoad.getNetStream().pause(false);
			}
			
			var flvLoad:FlvLoad = new FlvLoad(this.myVideo, "test.flv");
			this.flvLoad.addEventObserver(this, FlvLoad.EVENT_BUFFER_PROGRESS);
			this.flvLoad.addEventObserver(this, FlvLoad.EVENT_BUFFER_COMPLETE);
			this.flvLoad.start();
		</code>
*/

class org.casalib.load.media.video.FlvLoad extends BytesLoad {
	public static var EVENT_STATUS:String          = 'onStatus';
	public static var EVENT_META_DATA:String       = 'onMetaData';
	public static var EVENT_BUFFER_PROGRESS:String = 'onBufferProgress';
	public static var EVENT_BUFFER_COMPLETE:String = 'onBufferComplete';
	private var $target:Video;
	private var $stream:NetStream;
	private var $connection:NetConnection;
	private var $duration:Number;
	private var $startTime:Number;
	private var $bufferPercent:Percent;
	private var $bufferSeconds:Number;
	private var $pause:Boolean;
	private var $hasBuffered:Boolean;
	private var $readyToCalcBuffer:Boolean;
	private var $retryDelay:Interval;
	
	
	/**
		Defines file and location of load triggered by {@link Load#start start}.
		
		@param target_vid: A path to a Video container where the file specified by <code>flvPath</code> should be loaded into.
		@param flvPath: The absolute or relative URL of the FLV file to be loaded.
		@param pause: <strong>[optional]</strong> Indicates to pause video at start <code>true</code>, or to let the video automatically play <code>false</code>; defaults to <code>true</code>.
		@param duration: <strong>[optional]</strong> Length of FLV in seconds; if left undefined duration is taken from the FLV's meta data.
	*/
	public function FlvLoad(target_vid:Video, flvPath:String, pause:Boolean, duration:Number) {
		super(target_vid, flvPath);
		
		this.$initNetObjects();
		
		this.$pause         = (pause == undefined) ? true : pause;
		this.$retryDelay    = Interval.setTimeout(this, '$retryLoad', 250);
		this.$bufferPercent = new Percent(0);
		
		if (!isNaN(duration)) 
			this.$duration = Math.max(duration - 2, 0); // Making two seconds shorter to insure a good buffer.
		
		this.$setClassDescription('org.casalib.load.media.video.FlvLoad');
	}
	
	/**
		@return Returns Video specified in {@link #FlvLoad}.
	*/
	public function getVideo():Video {
		return this.$target;
	}
	
	/**
		@return Returnes the NetStream object being used internally to load and control the FLV.
	*/
	public function getNetStream():NetStream {
		return this.$stream;
	}
	
	public function getBytesLoaded():Number {
		return this.$stream.bytesLoaded;
	}
	
	public function getBytesTotal():Number {
		return this.$stream.bytesTotal;
	}
	
	public function destroy():Void {
		this.$stopLoad();
		
		this.$retryDelay.destroy();
		this.$bufferPercent.destroy();
		
		delete this.$retryDelay;
		delete this.$stream;
		delete this.$connection;
		delete this.$readyToCalcBuffer;
		delete this.$bufferPercent;
		delete this.$bufferSeconds;
		delete this.$duration;
		delete this.$startTime;
		delete this.$pause;
		delete this.$hasBuffered;
		
		super.destroy();
	}
	
	private function $startLoad():Void {
		this.$startTime         = getTimer();
		this.$readyToCalcBuffer = this.$hasBuffered = false;
		this.$bufferSeconds     = undefined;
		
		this.$retryDelay.stop();
		
		this.$bufferPercent.setDecimalPercentage(0);
		
		super.$startLoad();
		
		this.$stream.play(this.$filePath);
		this.$stream.pause(this.$pause);
	}
	
	private function $stopLoad():Void {
		super.$stopLoad();
		
		this.$stream.close();
		this.getVideo().clear();
		this.getVideo().attachVideo(null);
	}
	
	private function $initNetObjects():Void {
		this.$connection = new NetConnection();
		this.$connection.connect(null);
		
		this.$stream = new NetStream(this.$connection);
		
		this.getVideo().attachVideo(this.$stream);
		
		var _this:FlvLoad = this;
		this.$stream.onStatus = function(infoObject:Object):Void {
			_this.$onStatus(infoObject);
		};
		this.$stream.onMetaData = function(infoObject:Object):Void {
			_this.$onMetaData(infoObject);
		};
	}
	
	private function $loadProgress(bytesLoaded:Number, currentTime:Number):Void {
		super.$loadProgress(bytesLoaded, currentTime);
		this.$calculateBuffer(currentTime);
	}
	
	/**
		@sends onStatus = function(sender:FlvLoad, infoObject:Object) {}
	*/
	private function $onStatus(infoObject:Object):Void {
		this.dispatchEvent(FlvLoad.EVENT_STATUS, this, infoObject);
		
		if (infoObject.code.toLowerCase() == 'netstream.play.streamnotfound')
			this.$retryDelay.start();
	}
	
	/**
		@sends onMetaData = function(sender:FlvLoad, infoObject:Object) {}
	*/
	private function $onMetaData(infoObject:Object):Void {
		if (this.$duration == undefined)
			if (!isNaN(infoObject.duration))
				this.$duration = Math.max(infoObject.duration - 2, 0); // Making two seconds shorter to insure a good buffer.
		
		this.dispatchEvent(FlvLoad.EVENT_META_DATA, this, infoObject);
	}
	
	/**
		@sends onBufferProgress = function(sender:FlvLoad, percentBuffered:Percent, secondsTillBuffered:Number) {}
		@sends onBufferComplete = function(sender:FlvLoad) {}
	*/
	private function $calculateBuffer(currentTime:Number):Void {
		if (!isNaN(this.$duration) && !this.$hasBuffered) {
			if (this.$readyToCalcBuffer) {
				var bufferInfo:Object   = LoadUtil.calculateBuffer(this.getBytesLoaded(), this.getBytesTotal(), this.$startTime, currentTime, this.$duration);
				var decimalPer:Number   = bufferInfo.percent.getDecimalPercentage();
				var valueChange:Boolean = false;
				
				if (decimalPer > this.$bufferPercent.getDecimalPercentage() || this.$bufferPercent == undefined) {
					this.$bufferPercent.setDecimalPercentage(decimalPer);
					valueChange = true;
				}
				
				if (bufferInfo.seconds < this.$bufferSeconds || isNaN(this.$bufferSeconds)) {
					this.$bufferSeconds = bufferInfo.seconds;
					valueChange = true;
				}
				
				if (valueChange) {
					this.dispatchEvent(FlvLoad.EVENT_BUFFER_PROGRESS, this, this.$bufferPercent.clone(), this.$bufferSeconds);
					
					if (decimalPer >= 1) {
						this.$hasBuffered = true;
						this.dispatchEvent(FlvLoad.EVENT_BUFFER_COMPLETE, this);
					}
				}
			} else {
				if (currentTime - this.$startTime > 2000)
					this.$readyToCalcBuffer = true;
			}
		}
	}
	
	private function $onComplete():Void {
		if (!this.$hasBuffered) {
			this.$hasBuffered = true;
			this.dispatchEvent(FlvLoad.EVENT_BUFFER_PROGRESS, this, new Percent(1), 0);
			this.dispatchEvent(FlvLoad.EVENT_BUFFER_COMPLETE, this);
		}
		
		super.$onComplete();
	}
}