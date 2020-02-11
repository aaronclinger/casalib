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

import org.casalib.event.EventDispatcher;

/**
	Dispatches stage "onResize" event to observers. Should be used instead of <code>Stage.addListener</code>.
	
	@author Aaron Clinger
	@version 12/20/06
	@example
		<code>
			function onResize(stageWidth:Number, stageHeight:Number):Void {
				trace("Stage resized to " + stageWidth + " wide by " + stageHeight + " tall.");
			}
	
			var stageInstance:EventStage = EventStage.getInstance();
			this.stageInstance.addEventObserver(this, EventStage.EVENT_RESIZE);
		</code>
*/

class org.casalib.stage.EventStage extends EventDispatcher {
	public static var EVENT_RESIZE:String = 'onResize';
	private static var $stageInstance:EventStage;
	
	/**
		@return {@link EventStage} instance.
	*/
	public static function getInstance():EventStage {
		if (EventStage.$stageInstance == undefined) EventStage.$stageInstance = new EventStage(); 
		return EventStage.$stageInstance;
	}
	
	private function EventStage() {
		super();
		
		Stage.addListener(this);
		
		this.$setClassDescription('org.casalib.stage.EventStage');
	}
	
	/**
		@sends onResize = function(stageWidth:Number, stageHeight:Number) {}
	*/
	private function onResize():Void {
		this.dispatchEvent(EventStage.EVENT_RESIZE, Stage.width, Stage.height);
	}
}