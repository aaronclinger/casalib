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

import org.casalib.state.LockableInterface;
import org.casalib.movieclip.StatedMovieClip;
import org.casalib.util.MovieClipUtil;

/**
	Extends {@link StatedMovieClip} and creates a locking interface for MovieClips.
	
	This is different then using the <code>enabled</code> property because it completly removes all MovieClip event handlers and properties specified; does not only disable button events. 
	
	@author Toby Boudreaux
	@author Aaron Clinger
	@version 05/13/07
	@example
		<code>
			import org.casalib.util.MovieClipUtil;
			
			MovieClipUtil.attachMovieRegisterClass(org.casalib.movieclip.LockingMovieClip, this, "linkageMovieClip", "locking_mc");
			
			this.locking_mc.onRelease = function():Void {
				trace("I am unlocked.");
			}
			
			this.locking_mc.lock();
		</code>
		
		or is you only want to lock certain event handlers:
		<code>
			import org.casalib.util.MovieClipUtil;
			
			MovieClipUtil.attachMovieRegisterClass(org.casalib.movieclip.LockingMovieClip, this, "linkageMovieClip", "locking_mc");
			
			this.locking_mc.onRelease = function():Void {
				trace("I am unlocked.");
			}
			
			this.locking_mc.onRollOver = function():Void {
				this.gotoAndStop("rollOver");
			}
			
			this.locking_mc.onRollOut = this.locking_mc.onReleaseOutside = function():Void {
				this.gotoAndStop("rollOut");
			}
			
			this.locking_mc.lock(new Array("onRelease"));
		</code>
*/

class org.casalib.movieclip.LockingMovieClip extends StatedMovieClip implements LockableInterface {
	private var $locked:Boolean;
	
	
	/**
		Creates an empty instance of the LockingMovieClip class. Use this instead of a traditional <code>new</code> constructor statement due to limitations of ActionScript 2.0.
		
		@param target: Location where the MovieClip should be attached.
		@param instanceName: A unique instance name for the MovieClip.
		@param depth: <strong>[optional]</strong> The depth level where the MovieClip is placed; defaults to next highest open depth.
		@param initObject: <strong>[optional]</strong> An object that contains properties with which to populate the newly attached MovieClip.
		@return Returns a reference to the created instance.
		@example <code>var myLocking_mc:LockingMovieClip = LockingMovieClip.create(this, "example_mc");</code>
		@usageNote If you want to extend a non empty MovieClip you can either define the ActionScript 2.0 class in the Flash IDE library or use {@link MovieClipUtil#attachMovieRegisterClass}.
		@since Flash Player 7
	*/
	public static function create(target:MovieClip, instanceName:String, depth:Number, initObject:Object):LockingMovieClip {
		return LockingMovieClip(MovieClipUtil.createMovieRegisterClass('org.casalib.movieclip.LockingMovieClip', target, instanceName, depth, initObject));
	}
	
	
	private function LockingMovieClip() {
		super();
		
		this.$locked = false;
		
		this.$setClassDescription('org.casalib.movieclip.LockingMovieClip');
	}
	
	public function lock(inclusionList:Array):Void {
		if (this.$locked)
			return;
		
		this.enabled = false;
		this.$locked = true;
		
		this.createState('unlocked', inclusionList);
		this.switchState('blank', inclusionList);
	}
	
	public function unlock():Void {
		if (!this.$locked)
			return;
		
		this.enabled = true;
		this.$locked = false;
		
		this.switchState('unlocked');
	}
	
	public function toggle():Void {
		if (this.$locked)
			this.unlock();
		else
			this.lock();
	}
	
	public function isLocked():Boolean {
		return this.$locked;
	}
	
	public function destroy():Void {
		delete this.$locked;
		super.destroy();
	}
}