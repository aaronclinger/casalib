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

import org.casalib.util.ConversionUtil;
import org.casalib.util.NumberUtil;
import org.casalib.math.Percent;

/**
	@author Aaron Clinger
	@author Mike Creighton
	@version 02/10/07
*/

class org.casalib.util.LoadUtil {
	
	/**
		Calculates the percent loaded.
		
		@param loadTarget: Any object that has either <code>getBytesLoaded</code>/<code>getBytesTotal</code> or <code>bytesLoaded</code>/<code>bytesTotal</code> methods.
		@return Percent loaded.
	*/
	public static function getPercentLoaded(loadTarget:Object):Percent {
		if (loadTarget.getBytesLoaded != undefined)
			return new Percent(loadTarget.getBytesLoaded() / loadTarget.getBytesTotal());
		else if (loadTarget.bytesLoaded != undefined)
			return new Percent(loadTarget.bytesLoaded / loadTarget.bytesTotal);
	}
	
	/**
		Calculates the load speed in bytes per second (Bps).
		
		@param bytesLoaded: Number of bytes that have loaded between <code>startTime</code> and <code>elapsedTime</code>.
		@param startTime: Time in milliseconds when the load started. Can be <code>0</code>.
		@param elapsedTime: Time in milliseconds since the load started or time when load completed.
		@return bytes per second.
		@usageNote This gets BYTES per second, not bits per second.
	*/
	public static function calculateBps(bytesLoaded:Number, startTime:Number, elapsedTime:Number):Number {
		var elapsed:Number = (elapsedTime - startTime) / 1000;
		return bytesLoaded / elapsed;
	}
	
	/**
		Calculates the load speed in KBps.
		
		@param bytesLoaded: Number of bytes that have loaded between <code>startTime</code> and <code>elapsedTime</code>.
		@param startTime: Time in milliseconds when the load started. Can be <code>0</code>.
		@param elapsedTime: Time in milliseconds since the load started or time when load completed.
		@return Kilobytes per second.
		@usageNote This gets kiloBYTES per second, not kilobits per second.
	*/
	public static function calculateKBps(bytesLoaded:Number, startTime:Number, elapsedTime:Number):Number {
		var elapsed:Number   = (elapsedTime - startTime) / 1000;
		var sizeInKBs:Number = ConversionUtil.bytesToKilobytes(bytesLoaded);
		
		return sizeInKBs / elapsed;
	}
	
	/**
		Calculates the load speed in kbps.
		
		@param bytesLoaded: Number of bytes that have loaded between <code>startTime</code> and <code>elapsedTime</code>.
		@param startTime: Time in milliseconds when the load started. Can be <code>0</code>.
		@param elapsedTime: Time in milliseconds since the load started or time when load completed.
		@return Kilobits per second.
		@usageNote This gets kiloBITS per second, not kilobytes per second.
	*/
	public static function calculateKbps(bytesLoaded:Number, startTime:Number, elapsedTime:Number):Number {
		var elapsed:Number   = (elapsedTime - startTime) / 1000;
		var sizeInKbs:Number = ConversionUtil.bytesToKilobits(bytesLoaded);
		
		return sizeInKbs / elapsed;
	}
	
	/**
		Calculates the time and percentage until movie/animation has buffered.
		
		@param bytesLoaded: Number of bytes that have loaded between <code>startTime</code> and <code>elapsedTime</code>.
		@param bytesTotal: Number of bytes total to be loaded.
		@param startTime: Time in milliseconds when the load started. Can be <code>0</code>.
		@param elapsedTime: The current time in milliseconds or time when load completed.
		@param lengthInSeconds: Length in seconds of the video or animation being loaded. Can also be calculated by dividing <code>_totalframes</code> by the FPS (frames per second).
		@return An object with properties <code>seconds</code> and <code>percent</code> defined. Property <code>percent</code> is a {@link Percent} object.
		@usage
			<code>
				var bufferInfo:Object = LoadUtil.calculateBuffer(102400, 1536000, 0, 5000, 30);
				trace("File will be buffered in " + bufferInfo.seconds + " seconds.");
				trace("File is " + bufferInfo.percent.getPercentage() + "% buffered.");
			</code>
	*/
	public static function calculateBuffer(bytesLoaded:Number, bytesTotal:Number, startTime:Number, elapsedTime:Number, lengthInSeconds:Number):Object {
		var transferRate:Number = LoadUtil.calculateBps(bytesLoaded, startTime, elapsedTime);
		var totalWait:Number    = bytesTotal / transferRate - lengthInSeconds;
		var secsTillLoad:Number = Math.ceil((bytesTotal - bytesLoaded) / transferRate);
		
		var buffer:Object = new Object();
		buffer.seconds = Math.max(secsTillLoad - lengthInSeconds, 0);
		buffer.percent = totalWait == Number.POSITIVE_INFINITY ? new Percent(0) : new Percent(NumberUtil.makeBetween(1 - buffer.seconds / totalWait, 0, 1)); 
		
		return buffer;
	}
	
	private function LoadUtil() {} // Prevents instance creation
}