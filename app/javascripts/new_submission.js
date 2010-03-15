//= require <jquery.scope.min>

$(document).ready(function() {

	function show_hide(to_show, to_hide) {
		$(to_show).slideDown();
		$(to_hide).slideUp();
		return false;
	}
		
	$('.candybar').as_scope(function($) {	
		$('.address').click(function(){ return show_hide('#location_address', '#location_latlng'); }).click();
		$('.latlng').click(function(){  return show_hide('#location_latlng',  '#location_address'); });
		
		$('.photo').click(function(){ return show_hide('#media_photo', '#media_video, #media_none'); }).click();
		$('.video').click(function(){ return show_hide('#media_video', '#media_photo, #media_none'); });
		$('.none').click(function(){  return show_hide('#media_none',  '#media_photo, #media_video'); });
	});
});
