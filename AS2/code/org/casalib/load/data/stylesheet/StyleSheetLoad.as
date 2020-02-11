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

import TextField.StyleSheet;
import org.casalib.load.base.RetryableLoad;

/**
	StyleSheet object to ease the chore of loading and assigning StyleSheets.
	
	Unfortunately due the sub-par support of StyleSheets, this class cannot follow {@link BytesLoadInterface}/{@link BytesLoad}. The StyleSheet class does not include <code>getBytesLoaded</code> or <code>getBytesTotal</code> for reasions that are totally unclear.
	
	@author Aaron Clinger
	@version 04/13/07
	@since Flash Player 7
	@example
		<code>
			this.createTextField("headline_txt", this.getNextHighestDepth(), 50, 50, 300, 100);
			this.headline_txt.border = this.headline_txt.background = this.headline_txt.html = true;
			
			function initTextField(sender:StyleSheetLoad):Void {
				sender.assignStyleSheet(this.headline_txt);
				this.headline_txt.htmlText = "<h1>Heading</h1>";
			}
			
			var loadStyle:StyleSheetLoad = new StyleSheetLoad("style.css");
			this.loadStyle.addEventObserver(this, StyleSheetLoad.EVENT_LOAD_COMPLETE, "initTextField");
			this.loadStyle.start();
		</code>
	@usageNote Class will stall and fail silently if a empty CSS file is loaded, do to an error in the StyleSheet object.
*/

class org.casalib.load.data.stylesheet.StyleSheetLoad extends RetryableLoad {
	private var $target:StyleSheet;
	private var $isUnloading:Boolean;
	
	/**
		Defines file and location of load triggered by {@link Load#start start}.
		
		@param styleSheetPath: The absolute or relative URL of the CSS file to be loaded.
	*/
	public function StyleSheetLoad(styleSheetPath:String) {
		super(null, styleSheetPath);
		
		this.$target = new StyleSheet();
		
		this.$remapOnLoadHandler();
		
		this.$setClassDescription('org.casalib.load.data.stylesheet.StyleSheetLoad');
	}
	
	/**
		@return Returns the StyleSheet object StyleSheetLoad class is wrapping and loading.
	*/
	public function getStyleSheet():StyleSheet {
		return this.$target;
	}
	
	/**
		Assigns StyleSheet to passed TextField. Can only be called after StyleSheet has successfully loaded.
		
		@param target_txt: Target TextField or {@link CoreTextField}.
		@usageNote StyleSheets in Flash are extremely buggy. It is best to call <code>assignStyleSheet</code> before assigning text to a TextField.
	*/
	public function assignStyleSheet(target_txt:Object):Void {
		if (!this.hasLoaded())
			return;
		
		target_txt.styleSheet = this.getStyleSheet();
	}
	
	public function destroy():Void {
		delete this.$isUnloading;
		
		super.destroy();
	}
	
	private function $startLoad():Void {
		super.$startLoad();
		
		delete this.$isUnloading;
		this.$target.load(this.getFilePath());
	}
	
	private function $stopLoad():Void {
		super.$stopLoad();
		
		this.$isUnloading = true;
		this.$target.load(''); // Cancels the current load.
		this.$target.clear();
	}
	
	private function $onLoad(success:Boolean):Void {
		if (!this.$isUnloading)
			super.$onLoad(success);
		else
			delete this.$isUnloading;
	}
	
	private function $checkForLoadComplete():Void {}
}