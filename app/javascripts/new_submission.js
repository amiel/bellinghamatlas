//= require <jquery.scope.min>

$(document).ready(function() {

	function show_hide(to_show, to_hide) {
		$(to_hide).slideUp();
		$(to_show).stop().slideDown();
	}
		
	$('.candybar').as_scope(function($) {
	    
	    function candybar(scope, me, others) {
	        var others_ids = jQuery.map(others, function(t) { return '#' + scope + '_' + t; }).join(', '),
	         others_classes = jQuery.map(others, function(t) { return '.' + t; }).join(', ');
	        show_hide('#' + scope + '_' + me, others_ids);
	        
	        $(others_classes).removeClass('current');
	        $('.' + me).addClass('current');
	        return false;
	    }
	    	
		$('.address').click(function(){ return candybar('location', 'address', ['latlng']); }).click();
		$('.latlng').click(function(){  return candybar('location', 'latlng', ['address']); });
		
		$('.photo').click(function(){ return candybar('media', 'photo', ['video', 'none']); }).click();
		$('.video').click(function(){ return candybar('media', 'video', ['photo', 'none']); });
		$('.none').click(function(){  return candybar('media', 'none',  ['photo', 'video']); });
	});
});
