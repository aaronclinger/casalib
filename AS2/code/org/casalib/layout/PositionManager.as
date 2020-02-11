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

import org.casalib.core.CoreObject;
import org.casalib.stage.EventStage;
import org.casalib.util.StyleSheetUtil;
import org.casalib.util.TypeUtil;
import TextField.StyleSheet;

/**
	Gives the ablility to position and size <code>MovieClip</code>s, <code>TextField</code>s and <code>Button</code>s with either an external CSS file or an internal <code>StyleSheet</code> object.

	@author Aaron Clinger
	@version 04/06/07
	@since Flash Player 7
	@example
		<code>
			var positionManager:PositionManager = new PositionManager();
			
			this.positionManager.setStyleSheet(this.styleSheet);
			
			this.positionManager.addItem(this.text_txt);
			this.positionManager.addItem(this.button_btn);
			this.positionManager.addItem(this.movie_mc, {left:"0", height:"100%"});
			this.positionManager.positionItems();
		</code>
	@see "For information on which CSS properties are supported by {@link PositionManager} see {@link StyleSheetUtil#positionItemWithStyleObject}."
*/
//@TODO Add DistributionCollection support.
class org.casalib.layout.PositionManager extends CoreObject {
	private var $style:StyleSheet;
	private var $updateItemsMap:Object;
	
	
	/**
		Creates a new PositionManager instance.
	*/
	public function PositionManager() {
		super();
		
		this.$updateItemsMap = new Object();
		
		this.$setClassDescription('org.casalib.layout.PositionManager');
	}
	
	/**
		Defines a global stylesheet. 
		
		Class maps style IDs to instance names of added items. Style <code>#square_mc { width: 200px; height: 200px; }</code> would apply to an item with an instance name of <code>"square_mc</code>.
		
		@param style: A StyleSheet to apply to added items.
		@see "For information on which CSS properties are supported by {@link PositionManager} see {@link StyleSheetUtil#positionItemWithStyleObject}."
	*/
	public function setStyleSheet(style:StyleSheet):Void {
		this.$style = style;
		this.positionItems();
	}
	
	/**
		Adds item to be positioned and sized by styles.
		
		@param item: A <code>MovieClip</code>, <code>TextField</code> or <code>Button</code>.
		@param style: <strong>[optional]</strong> An object with style properties defined. Any properties defined here overwrite the values of any identical properties that may have been defined by {@link #setStyleSheet}.
		@return Returns <code>true</code> if item was of type <code>MovieClip</code>, <code>TextField</code> or <code>Button</code> and was successfully added; otherwise <code>false</code>.
		@example <code>this.positionManager.addItem(this.movie_mc, {left:"0", height:"100%"});</code> or <code>this.positionManager.addItem(this.movie_mc, this.styleSheet.getStyle("styleName"));</code>
		@see "For information on which CSS properties are supported by {@link PositionManager} see {@link StyleSheetUtil#positionItemWithStyleObject}."
	*/
	public function addItem(item:Object, style:Object):Boolean {
		switch (TypeUtil.getTypeOf(item)) {
			case 'movieclip' :
			case 'textfield' :
			case 'button' :
				var positionItem:Object = new Object();
				positionItem.item  = item;
				positionItem.name  = item._name;
				if (style != undefined) positionItem.style = style;
				
				this.$updateItemsMap[item] = positionItem;
				break;
			default :
				return false;
		}
		
		return true;
	}
	
	/**
		Removes item previously added with {@link #addItem} from receiving style and position updates from PositionManager. Leaves item at its current size and position.
		
		@param item: A <code>MovieClip</code>, <code>TextField</code> or <code>Button</code> you wish to remove.
		@return Returns <code>true</code> if item was successfully found and removed; otherwise <code>false</code>.
	*/
	public function removeItem(item:Object):Boolean {
		if (this.$updateItemsMap[item] != undefined) {
			delete this.$updateItemsMap[item];
			
			return true;
		}
		
		return false;
	}
	
	/**
		Positions all items added with {@link #addItem} with the defined styles.
		
		@usageNote <code>positionItems</code> is automatically called after {@link #setStyleSheet}.
	*/
	public function positionItems():Void {
		var style:Object;
		var positionItem:Object;
		var isGlobalStyle:Boolean = this.$style != undefined;
		
		for (var i:String in this.$updateItemsMap) {
			positionItem = this.$updateItemsMap[i];
			
			if (isGlobalStyle) {
				style = this.$style.getStyle('#' + positionItem.name);
				
				if (style != undefined)
					StyleSheetUtil.positionItemWithStyleObject(positionItem.item, style);
			}
			
			if (positionItem.style != undefined)
				StyleSheetUtil.positionItemWithStyleObject(positionItem.item, positionItem.style);
		}
	}
}
