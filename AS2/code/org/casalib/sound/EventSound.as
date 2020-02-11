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

import org.casalib.event.DispatchableInterface;
import org.casalib.event.EventDispatcher;

/**
	Base Sound object that includes {@link EventDispatcher} and implements {@link CoreInterface}. All Sound classes implementing EventDispatcher should inherent from this class.

	@author Aaron Clinger
	@version 02/06/07
	@example
		<code>
			function onSoundLoad(sender:EventSound, success:Boolean):Void {
				if (success) {
					sender.start();
				}
			}

			function onSoundId3(sender:EventSound, id3:Object):Void {
				for (var i:String in id3) {
					trace(i + ": " + id3[i]);
				}
			}

			var eventSound:EventSound = new EventSound(this);
			this.eventSound.addEventObserver(this, EventSound.EVENT_LOAD, "onSoundLoad");
			this.eventSound.addEventObserver(this, EventSound.EVENT_ID3, "onSoundId3");
			this.eventSound.loadSound("test.mp3");
		</code>
*/

class org.casalib.sound.EventSound extends Sound implements DispatchableInterface {
	public static var EVENT_ID3:String            = 'onID3';
	public static var EVENT_LOAD:String           = 'onLoad';
	public static var EVENT_SOUND_COMPLETE:String = 'onSoundComplete';
	private var $eventDispatcher:EventDispatcher;
	private var $instanceDescription:String;
	
	/**
		Creates an EventSound object.
		
		@param target_mc: The MovieClip instance on which the Sound object operates.
	*/
	public function EventSound(target_mc:MovieClip) {
		super(target_mc);
		
		this.$eventDispatcher = new EventDispatcher();
		
		this.$setClassDescription('org.casalib.sound.EventSound');
	}
	
	/**
		@sends onID3 = function(sender:EventSound, id3:Object) {}
	*/
	private function onID3():Void {
		this.dispatchEvent(EventSound.EVENT_ID3, this, this.id3);
	}
	
	/**
		@sends onLoad = function(sender:EventSound, success:Boolean) {}
	*/
	private function onLoad(success:Boolean):Void {
		this.dispatchEvent(EventSound.EVENT_LOAD, this, success);
	}
	
	/**
		@sends onSoundComplete = function(sender:EventSound) {}
	*/
	private function onSoundComplete():Void {
		this.dispatchEvent(EventSound.EVENT_SOUND_COMPLETE, this);
	}
	
	public function toString():String {
		return '[' + this.$instanceDescription + ']';
	}

	private function $setClassDescription(description:String):Void {
		this.$instanceDescription = description;
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
	
	public function destroy():Void {
		this.$eventDispatcher.destroy();
		delete this.$eventDispatcher;
		delete this.$instanceDescription;
	}
}
