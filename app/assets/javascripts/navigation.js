// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//These two functions used to manage the tooltip
function renderTooltip(ycoord, message){
        $("tooltip_helper").update(message);
        $("tooltip").style.top= ycoord + "px";   
        $("tooltip").style.visibility="visible";
}

function hideTooltip(){
        $("tooltip").style.visibility="hidden";
}

//used for TOS checkbox
function isEmpty(elem, helperMsg){
	if(elem.checked == false){
		alert(helperMsg);
		elem.focus();
		return false;
	}
	return true;
}

//these functions are used to aid in switching visibility
function gotoCloseApps(){
	$('#allow_access').hide();
	$('#close_apps').show();
}

function gotoCameraSetup(){
	$('#choose_method').hide();
	$('#cam_dialogue').show();
	$('#setupHeader').update('Camera Setup');
}

function gotoSkip(){
	$('#choose_method').hide();
	$('#tip_dialogue').show();
	$('#setupHeader').update('First Mugshot Tips');
}

function gotoChooseInput(){
	$('#close_apps').hide();
	$('#choose_input').show();
}

function gotoAdvanced(){
	$('#allow_access').hide();
	$('#close_apps').hide();
	$('#choose_input').hide();
	$('#advanced_settings').show();
}

function gotoMugTips(){
	$('#cam_dialogue').hide();
	$('#setupHeader').update('First Mugshot Tips');
	$('#tip_dialogue').show();
}

function firstPic(){
	$('#tip_dialogue').hide();
	$('#setupHeader').update('Time for your First Mugshot!');
	$('#firstPic_dialogue').show();
}

function ffffswfFinished(type){
	alert(type);
	who = $("whoAmI").readAttribute('me');
	alert("who: " + who);
}

function swfFinished(type){
	who = $("whoAmI").readAttribute('me');
	switch(who){
		case 'firstPic':
			window.location = "/authuser/landmarks/fp";	
			break;
		case 'anotherPic':
			/*window.location = "/authuser/motd";*/
			window.location = "/main/browse";	
			break;
		case 'firstLandmarks':
			window.location = "/main/get_reminder";	
			break;
		case 'adjustLandmarks':
			break;
	}
}

function get_update() { 
		new Ajax.Request('/openapis/get_update', {
			method: 'get',
			onSuccess: function(transport){
					/* gather data into JSON object */
					data = transport.responseText
					delimeter = data.search(/\./)
					identifier = data.substr(0,delimeter)
					replacement = data.substr(delimeter+1)
					/*check to see if the identifier already exists */
					if ( Cookie.get('dmsIdentifier') != identifier ){
						Cookie.set('dmsIdentifier', identifier)
						Effect.DropOut($('alert_box'))
						setTimeout(function() {
							;
							$('alert_box').update(replacement);
							Effect.Appear($('alert_box'));
						}, 1000);
					}
				} 
			}
		)
}

// new PeriodicalExecuter( get_update, 10 )

// var Cookie = {
// 	set: function(name,value,seconds){
// 		if(seconds){
// 			d = new Date();
// 			d.setTime(d.getTime() + (seconds * 1000));
// 			expiry = '; expires=' + d.toGMTString();
// 		}else
// 			expiry = '';
// 		document.cookie = name + "=" + value + expiry + "; path=/";
// 	},
// 	get: function(name){
// 		nameEQ = name + "=";
// 		ca = document.cookie.split(';');
// 		for(i = 0; i < ca.length; i++){
// 			c = ca[i];
// 			while(c.charAt(0) == ' ')
// 				c = c.substring(1,c.length);
// 			if(c.indexOf(nameEQ) == 0)
// 				return c.substring(nameEQ.length,c.length);
// 		}
// 		return null
// 	},
// 	unset: function(name){
// 		Cookie.set(name,'',-1);
// 	}
// }

function watermark(){
	//strip strings and make lowercase to compare
	function compare( str1, str2 ){
		return str1.split(" ").join("").toLowerCase() == str2.split(" ").join("").toLowerCase();
	}               
	
	//take note of what the watermark is
	this.watermark = this.attr('value');
	this.value = this.watermark;
	this.className += ' watermark';
	
	//add a focus event to remove watermarking
	this.onfocus = function(){
		if( compare(this.value, this.watermark) ){
			this.value = '';
		}
		this.className = this.className.replace('watermark','');
	}                                       
	
	//add a blur event to restore the watermark
	this.onblur = function(){
		if( compare( this.value, '') ){
			this.value = this.watermark;
			this.className += ' watermark';
		}
		
	}
}


