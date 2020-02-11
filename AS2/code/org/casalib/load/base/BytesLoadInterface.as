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

import org.casalib.load.base.RetryableLoadInterface;

/**
	Load interface to be used in load classes where methods <code>getBytesLoaded</code> and <code>getBytesTotal</code> are available.

	@author Aaron Clinger
	@version 12/21/06
*/

interface org.casalib.load.base.BytesLoadInterface extends RetryableLoadInterface {
	
	/**
		Sets the amount of time a load will wait without receiving further progress before {@link RetryableLoadInterface#setLoadRetries retrying}.
		
		@param loadTimeout: Time in milliseconds.
	*/
	public function setLoadTimeout(loadTimeout:Number):Void;
	
	/**
		Returns the number of bytes that have loaded (streamed).
		
		@return An integer that indicates the number of bytes loaded.
	*/
	public function getBytesLoaded():Number;
	
	/**
		Returns the size, in bytes, of the file currently or completed loading.
		
		@return An integer that indicates the total size, in bytes, of the movie clip.
	*/
	public function getBytesTotal():Number;
}