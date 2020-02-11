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

import org.casalib.movieclip.CoreMovieClip;
import org.casalib.event.DispatchableInterface;
import org.casalib.event.EventDispatcher;
import org.casalib.util.MovieClipUtil;

/**
	Base MovieClip that includes {@link EventDispatcher} and extends {@link CoreMovieClip}.
	
	@author Aaron Clinger
	@version 05/13/07
*/

class org.casalib.movieclip.DispatchableMovieClip extends CoreMovieClip implements DispatchableInterface {
	private var $eventDispatcher:EventDispatcher;
	
	
	/**
		Creates an empty instance of the DispatchableMovieClip class. Use this instead of a traditional <code>new</code> constructor statement due to limitations of ActionScript 2.0.
		
		@param target: Location where the MovieClip should be attached.
		@param instanceName: A unique instance name for the MovieClip.
		@param depth: <strong>[optional]</strong> The depth level where the MovieClip is placed; defaults to next highest open depth.
		@param initObject: <strong>[optional]</strong> An object that contains properties with which to populate the newly attached MovieClip.
		@return Returns a reference to the created instance.
		@example <code>var myDispatch_mc:DispatchableMovieClip = DispatchableMovieClip.create(this, "example_mc");</code>
		@usageNote If you want to extend a non empty MovieClip you can either define the ActionScript 2.0 class in the Flash IDE library or use {@link MovieClipUtil#attachMovieRegisterClass}.
		@since Flash Player 7
	*/
	public static function create(target:MovieClip, instanceName:String, depth:Number, initObject:Object):DispatchableMovieClip {
		return DispatchableMovieClip(MovieClipUtil.createMovieRegisterClass('org.casalib.movieclip.DispatchableMovieClip', target, instanceName, depth, initObject));
	}
	
	
	private function DispatchableMovieClip() {
		super();
		
		this.$eventDispatcher = new EventDispatcher();
		
		this.$setClassDescription('org.casalib.movieclip.DispatchableMovieClip');
	}
	
	public function addEventObserver(scope:Object, eventName:String, eventHandler:String):Boolean {
		return this.$eventDispatcher.addEventObserver(scope, eventName, eventHandler);
	}
	
	public function removeEventObserver(scope:Object, eventName:String, eventHandler:String):Boolean {
		return this.$eventDispatcher.removeEventObserver(scope, eventName, eventHandler);
	}
	
	public function removeEventObserversForEvent(eventName:String):Boolean {
		return this.$eventDispatcher.removeEventObserversForEvent(eventName);
	}
	
	public function removeEventObserversForScope(scope:Object):Boolean {
		return this.$eventDispatcher.removeEventObserversForScope(scope);
	}
	
	public function removeAllEventObservers():Boolean {
		return this.$eventDispatcher.removeAllEventObservers();
	}
	
	/**
		{@inheritDoc}
		
		@param eventName: {@inheritDoc}
		@param param(s): {@inheritDoc}
		@return {@inheritDoc}
	*/
	public function dispatchEvent(eventName:String):Boolean {
		return this.$eventDispatcher.dispatchEvent.apply(this.$eventDispatcher, arguments);
	}
	
	public function destroy():Void {
		this.$eventDispatcher.destroy();
		delete this.$eventDispatcher;
		
		super.destroy();
	}
}