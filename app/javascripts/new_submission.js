//= require <jquery.scope.min>

$(document).ready(function() {

	function candybar(to_show, to_hide) {
		$(to_show).slideDown();
		$(to_hide).slideUp();
		return false;
	}
		
	$('.candybar').as_scope(function($) {	
		$('.address').click(function(){ return candybar('#location_address', '#location_latlng'); }).click();
		$('.latlng').click(function(){  return candybar('#location_latlng',  '#location_address'); });
		
		$('.photo').click(function(){ return candybar('#media_photo', '#media_video, #media_none'); }).click();
		$('.video').click(function(){ return candybar('#media_video', '#media_photo, #media_none'); });
		$('.none').click(function(){  return candybar('#media_none',  '#media_photo, #media_video'); });
		
		
	});
});
