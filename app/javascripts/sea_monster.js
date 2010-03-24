//= require <konami>

(function() {
	var the_dude;
	Base.konami = function() {
		var sea_monster_src = "/images/sea-monster-48.png", sea_monster_large_src = "/images/sea-monster-128.png";
		if (typeof the_dude === 'undefined') {
			the_dude = new GGroundOverlay( sea_monster_src, new GLatLngBounds(new GLatLng(48.73151, -122.509), new GLatLng(48.732630, -122.50747)) );
			Base.map.addOverlay(the_dude);
		}
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
})();
	