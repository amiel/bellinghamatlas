//= require <base>
//= require "sea_monster"

Array.prototype.rand = function() {
	function rand(n) { return Math.floor(Math.random() * n); }
	return this[rand(this.length)];
};


function show_large(path, title, img) {
	$.fancybox({ href: path, title: $('<span>').html($('<img/>').attr('src', img)).append(title).html() });
	// close infowindow and set it up to reopen
	if (!Base.map.getInfoWindow().isHidden()) $(window).one('fancybox-cleanup', function() { Base.map.getInfoWindow().show(); });
	Base.map.getInfoWindow().hide();
	return false;
}

$(document).ready(function() {

	if (Base.submissions && GBrowserIsCompatible()) {
		var resize_map, info_window_openers = [];
		resize_map = function() { $("#map").css("height", ($(window).height() - 160 )); };
		
		resize_map(); $(window).resize(resize_map);
		
		Base.map = new GMap2(document.getElementById("map"));

		Base.map.setCenter(new GLatLng(48.7597,-122.4869),13);
		Base.map.addControl(new GSmallMapControl(),new GControlPosition(G_ANCHOR_TOP_LEFT,new GSize(10, 50)));
		Base.map.setMapType(G_PHYSICAL_MAP);
		// Base.map.enableContinuousZoom();
		Base.map.enableScrollWheelZoom();
		
		$('#goldi').click(function() {
			$('#the_story').fadeIn();
		});
		
		$('#the_story .close').click(function() {
			$('#the_story').fadeOut();
			return false;
		});

		
		var icons = (function(){
			function make_icon(color) {
				var base_icon = new GIcon();
				base_icon.iconSize = new GSize(35, 40);
				base_icon.iconAnchor = new GPoint(20, 33);
				base_icon.infoWindowAnchor = new GPoint(20, 33); // change
				base_icon.image = "/images/" + color + "_marker.png";
				return base_icon;
			}

			return {
				blue: make_icon('blue'),
				red: make_icon('red'),
				green: make_icon('green')
			};
		})();


		function make_click_handler(marker, submission) {
			return function() {
				$.fancybox.showActivity();
				$.get(submission.info_window_path, function(data){
					$.fancybox.hideActivity();
					Base.map.openInfoWindowHtml( marker.getPoint(), data, {} );
				});
			};
		}

		$.each(Base.submissions, function(i, s) {
			var marker = new GMarker(new GLatLng(s.lat, s.lng), { title: s.name, icon: icons[s.media_color] }),
			open_info_window = make_click_handler(marker, s);
			info_window_openers.push(open_info_window);
			$('#submission_' + i).click(open_info_window);
			GEvent.addListener(marker, "click", open_info_window);
			Base.map.addOverlay(marker);
		});

		$('#feeling_lucky a').click(function() {
			info_window_openers.rand()();
			return false;
		});
	}
});


//= require <jquery.fancybox-1.3.1>
