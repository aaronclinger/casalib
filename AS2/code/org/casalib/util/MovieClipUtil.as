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

/**
	Provides utility functions for attaching and creating MovieClips.
	
	@author Aaron Clinger
	@auther Mike Creighton
	@version 09/12/08
	@since Flash Player 7
*/

class org.casalib.util.MovieClipUtil {
	
	/**
		Makes it easier to change or assign classes to library MovieClips without having to change the item's linkage AS 2.0 class settings in the Flash IDE environment. An added benefit is that it allows multiple classes to use a single MovieClip in the library.
		
		@param className: The fully qualified name of a class you have defined in an external class file to extend the MovieClip instance.
		@param target: Location where the MovieClip should be attached.
		@param linkageId: The linkage name of the MovieClip in the library.
		@param instanceName: <strong>[optional]</strong> A unique instance name for the MovieClip; defaults to <code>linkageId</code>.
		@param depth: <strong>[optional]</strong> The depth level where the MovieClip is placed; defaults to next highest open depth.
		@param initObject: <strong>[optional]</strong> An object that contains properties with which to populate the newly attached MovieClip.
		@return Returns a reference to the created MovieClip instance.
		@example
			<code>
				import com.example.MyClass;
				
				var myMc:MyClass = MyClass(MovieClipUtil.attachMovieRegisterClass(MyClass, this, "libraryIdentifier", "myMovieClip_mc", 100, {_x:100, _alpha:75}));
			</code>
		@usageNote Be sure to always cast the returned MovieClip reference as the class type to get error notifcation and a valid reference.
	*/
	public static function attachMovieRegisterClass(className:Function, target:MovieClip, linkageId:String, instanceName:String, depth:Number, initObject:Object):MovieClip {
		Object.registerClass(linkageId, className);
		
		var mc:MovieClip = MovieClipUtil.attachMovie(target, linkageId, instanceName, depth, initObject);
		
		Object.registerClass(linkageId, null);
		
		return mc;
	}
	
	/**
		Creates an empty subclassed MovieClip extended by a specified class without requiring an empty MovieClip in the Flash IDE library with a linkage identifier and AS 2.0 class specification. 
		
		@param classPath: The fully qualified name of a class you have defined in an external class file to extend the MovieClip instance.
		@param target: Location where the MovieClip should be attached.
		@param instanceName: A unique instance name for the MovieClip.
		@param depth: <strong>[optional]</strong> The depth level where the MovieClip is placed; defaults to next highest open depth within the <code>target</code> MovieClip.
		@param initObject: <strong>[optional]</strong> An object that contains properties with which to populate the newly attached MovieClip.
		@return Returns a reference to the created MovieClip subclass instance.
		@example
			<code>
				import com.example.MyClass;
				
				var myMc:MyClass = MyClass(MovieClipUtil.createMovieRegisterClass("com.example.MyClass", this, "myMovieClip_mc", 100, {_x:100, _alpha:75}));
			</code>
		@usageNote Be sure to always cast the returned MovieClip reference as the class type to get error notifcation and a valid reference.
	*/
	public static function createMovieRegisterClass(classPath:String, target:MovieClip, instanceName:String, depth:Number, initObject:Object):MovieClip {
		return MovieClipUtil.attachMovieRegisterClass(eval(classPath), target, '__Packages.' + classPath, instanceName, depth, initObject);
	}	
	
	/**
		Mimics the abilities of {@link #attachMovie} by providing the option to pass an object that contains properties with which to populate the created MovieClip.
		
		@param target: Location where the MovieClip should be attached.
		@param instanceName: A unique instance name for the MovieClip.
		@param depth: <strong>[optional]</strong> The depth level where the MovieClip is placed; defaults to next highest open depth.
		@param initObject: <strong>[optional]</strong> An object that contains properties with which to populate the newly attached MovieClip.
		@return Returns a reference to the created MovieClip instance.
		@example
			<code>
				var myMc:MovieClip = MovieClipUtil.createEmptyMovieClip(this, "myMovieClip_mc", 100, {_x:15, _alpha:70});
			</code>
	*/
	public static function createEmptyMovieClip(target:MovieClip, instanceName:String, depth:Number, initObject:Object):MovieClip {
		var mc:MovieClip = target.createEmptyMovieClip(instanceName, (depth == undefined) ? target.getNextHighestDepth() : depth);
		
		for (var prop:String in initObject)
			mc[prop] = initObject[prop];
		
		return mc;
	}
	
	/**
		Mirrors the abilities of the <code>MovieClip.attachMovie</code> but defaults <code>depth</code> to the next highest open depth.
		
		@param target: Location where the MovieClip should be attached.
		@param linkageId: The linkage name of the MovieClip in the library.
		@param instanceName: <strong>[optional]</strong> A unique instance name for the MovieClip; defaults to <code>linkageId</code>.
		@param depth: <strong>[optional]</strong> The depth level where the MovieClip is placed; defaults to next highest open depth.
		@param initObject: <strong>[optional]</strong> An object that contains properties with which to populate the newly attached MovieClip.
		@return Returns a reference to the created MovieClip instance.
		@example
			<code>
				var myMc:MovieClip = MovieClipUtil.attachMovie(this, "libraryIdentifier", "myMovieClip_mc", 100, {_x:100, _alpha:75});
			</code>
	*/
	public static function attachMovie(target:MovieClip, linkageId:String, instanceName:String, depth:Number, initObject:Object):MovieClip {
		return target.attachMovie(linkageId, (instanceName == undefined) ? linkageId : instanceName, (depth == undefined) ? target.getNextHighestDepth() : depth, initObject);
	}
	
	private function MovieClipUtil() {} // Prevents instance creation
}