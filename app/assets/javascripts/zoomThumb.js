Event.observe(window, 'load', setupZoomThumbs);

function setupZoomThumbs(){
		
	var images_loaded = false;
	var pause_loading = false;
	
	
	//what is the var for the image path
	var sImgVar = '?large=';
		
	function preloadTip( oLink , opts){
		
		if( !oLink.match('.loaded') && !oLink.match('.loading') ){
			
			//first get the large image path
			var oThumb = $(oLink).getElementsByTagName('img')[0];
			
			//add a class name of loading
			oLink.addClassName('loading');
			
			if( oThumb ){
			
				var sImgPath = $(oThumb).readAttribute('src');			
				sImgPath = sImgPath.substring( sImgPath.indexOf(sImgVar) + sImgVar.length , sImgPath.length);
				
				//this function waits til' rollover and then 
				//injects the image into the tip
				var oTip = $(oLink).getElementsByClassName('tip')[0];
				
				if( oTip ){
					
					var oImg = document.createElement('img');
					oImg.onload = oImg.onerror = function(){					
						oTip.innerHTML = '<img src="' + oImg.src + '" />';
						$(oLink).addClassName('loaded');
						if( opts.callback && typeof opts.callback == 'function'){
							//resume loading of other tips
							pause_loading = false;

							opts.callback();
							
							delete oImg;
							
						}
						
					}
					oImg.src = sImgPath;
				}
			}
		
		}else{
			//console.log("done loaded");
		}
	}	
	
	//get a collection of the zoomThumb objects
	var aZoomers = $$('.zoom_thumb');
	
	//loop through each link, attaching the rollover function
	aZoomers.each(
		function( zoomer ){
		
			//on mouseover, load the image and show it
			Event.observe( 
				zoomer, 
				'mouseover',
				function( e ){
					
					//console.log( zoomer);
					//var oLink = Event.element(e);
					zoomer.addClassName('zf_hover');
					pause_loading = true;
					preloadTip( zoomer , {});
				}
			);
			Event.observe( 
				zoomer, 
				'mouseout',
				function( e ){
					//var oLink = Event.element(e);
					$(zoomer).removeClassName('zf_hover');
				
				}
			);
		}
	 );
	
	
	function preloadNext(){
		
		//only load if there are images to load and flag to pause isnt set
		if( images_loaded != true && pause_loading != true ){
		
			for(var i=0;i<aZoomers.length;++i){
				if( !$(aZoomers[i]).match('.loading')  && !$(aZoomers[i]).match('.loaded')) break;	
			}
			if( i<aZoomers.length ){
				preloadTip( 
					aZoomers[i] , 
					{ callback: preloadNext }
				);
			}else{
				images_loaded = true;
			}
		}
				
	}
	
	//kick off the recursive tip loading
	preloadNext();

}
