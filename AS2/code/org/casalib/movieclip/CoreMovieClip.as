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

import org.casalib.core.CoreInterface;
import org.casalib.util.MovieClipUtil;

/**
	A core MovieClip to inherent from which extends Flash's built-in MovieClip class. All MovieClip classes should extend from here.
	
	@author Aaron Clinger
	@auther Mike Creighton
	@version 09/12/08
*/

class org.casalib.movieclip.CoreMovieClip extends MovieClip implements CoreInterface {
	private var $instanceDescription:String;
	
	
	/**
		Creates an empty instance of the CoreMovieClip class. Use this instead of a traditional <code>new</code> constructor statement due to limitations of ActionScript 2.0.
		
		@param target: Location where the MovieClip should be attached.
		@param instanceName: A unique instance name for the MovieClip.
		@param depth: <strong>[optional]</strong> The depth level where the MovieClip is placed; defaults to next highest open depth.
		@param initObject: <strong>[optional]</strong> An object that contains properties with which to populate the newly attached MovieClip.
		@return Returns a reference to the created instance.
		@example <code>var myCore_mc:CoreMovieClip = CoreMovieClip.create(this, "example_mc");</code>
		@usageNote If you want to extend a non empty MovieClip you can either define the ActionScript 2.0 class in the Flash IDE library or use {@link MovieClipUtil#attachMovieRegisterClass}.
		@since Flash Player 7
	*/
	public static function create(target:MovieClip, instanceName:String, depth:Number, initObject:Object):CoreMovieClip {
		return CoreMovieClip(MovieClipUtil.createMovieRegisterClass('org.casalib.movieclip.CoreMovieClip', target, instanceName, depth, initObject));
	}
	
	
	private function CoreMovieClip() {
		this.$setClassDescription('org.casalib.movieclip.CoreMovieClip');
	}
	
	public function toString():String {
		return '[' + this.$instanceDescription + ']';
	}
	
	/**
		Removes the MovieClip after automatically calling {@link #destroy}.
		
		@usageNote <code>removeMovieClip</code> and {@link #destroy} work identically; you can call either method to destroy and remove the MovieClip.
	*/
	public function removeMovieClip():Void {
		this.destroy();
	}
	
	public function destroy():Void {
		delete this.$instanceDescription;
		
		super.removeMovieClip();
	}
	
	private function $setClassDescription(description:String):Void {
		this.$instanceDescription = description;
	}
}
