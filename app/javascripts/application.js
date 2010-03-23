//= require <base>
//= require <konami>


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
		var resize_map, info_window_openers = [], sea_monster_src = "/images/sea-monster-48.png", sea_monster_large_src = "/images/sea-monster-128.png";
		resize_map = function() { $("#map").css("height", ($(window).height() - 160 )); $('#logocontrol').next().css('right', '200px'); };
		
		resize_map(); $(window).resize(resize_map);
		
		Base.map = new GMap2(document.getElementById("map"));

		Base.map.setCenter(new GLatLng(48.7597,-122.4869),13);
		Base.map.addControl(new GSmallMapControl(),new GControlPosition(G_ANCHOR_TOP_LEFT,new GSize(10, 50)));
		Base.map.setMapType(G_PHYSICAL_MAP);
		// Base.map.enableContinuousZoom();
		Base.map.enableScrollWheelZoom();
		
		
		var the_dude = new GGroundOverlay( sea_monster_src, new GLatLngBounds(new GLatLng(48.73151, -122.509), new GLatLng(48.732630, -122.50747)) );
		Base.map.addOverlay(the_dude);
		
		Base.konami = function() {
			if (Base.map.getZoom() != 13) return;
			var sea_monster_img = $('img[src="'+sea_monster_src+'"]'),
				sea_monster = sea_monster_img.parent();
			Base.map.panTo(	new GLatLng(48.72263, -122.5075) );
			sea_monster_img.attr('src', sea_monster_large_src);
			sea_monster_img.animate({ width: '128px', height: '128px' }, 1500);
			sea_monster.animate({ width: '128px', height: '128px', left: 250, top: 460 }, 1000, 'linear', function() {
				var pos = sea_monster.offset();
				sea_monster.appendTo('body').css(pos).css('z-index', 100).animate({ left: 160, top: $(window).height() - 460 }, 400, function() {
					sea_monster.animate({ top: '+=50px' }, 600, function() {
						// remove goldi's head
						sea_monster.animate({ left: '-200px' });
					});
				});
			});
		};
		
		$.konami(Base.konami);
		
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
		});
		
		// I don't really know what to do about this
		window.setTimeout(resize_map, 1000);
	}
});


//= require <jquery.fancybox-1.3.1>
