//= require <base>

Array.prototype.rand = function() {
	function rand(n) { return Math.floor(Math.random() * n); }
	return this[rand(this.length)];
};

$(document).ready(function() {

	if (Base.submissions && GBrowserIsCompatible()) {
		var resize_map, info_window_openers = [], loading, anchor = document.location.toString().split('#')[1], submission_prefix = 'submission_';
		
		Base.set_anchor = function(l) { document.location = '#' + l; };
		
		resize_map = function() { $("#map").css("height", ($(window).height() - 160 )); };		
		resize_map(); $(window).resize(resize_map);
		loading = $('<div id="fancybox-loading"><div></div></div>');
		$('body').append(loading);
		
		$('#goldi').click(function() { $('#the_story').fadeIn(); });
		$('#the_story .close').click(function() { $('#the_story').fadeOut(); return false; });
		
		
		Base.map = new GMap2(document.getElementById("map"));

		Base.map.setCenter(new GLatLng(48.7597,-122.4869),13);
		Base.map.addControl(new GSmallMapControl(),new GControlPosition(G_ANCHOR_TOP_LEFT,new GSize(10, 50)));
		Base.map.setMapType(G_PHYSICAL_MAP);
		// Base.map.enableContinuousZoom();
		Base.map.enableScrollWheelZoom();
	
		
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
				loading.show();
				$.get(submission.info_window_path, function(data){
					loading.hide();
					Base.map.openInfoWindowHtml(marker.getPoint(), data, {
					    onCloseFn: function() { Base.set_anchor(''); },
					    onOpenFn: function() { Base.set_anchor(submission_prefix + submission.id); }
					});
				});
			};
		}
		
		$.each(Base.submissions, function(i, s) {
			var marker = new GMarker(new GLatLng(s.lat, s.lng), { title: s.name, icon: icons[s.media_color] }),
				open_info_window = make_click_handler(marker, s);
			info_window_openers.push(open_info_window);
			if (i == Base.featured_submission_id) $('#featured_submission').click(open_info_window);
			$('#' + submission_prefix + i).click(open_info_window);
			GEvent.addListener(marker, "click", open_info_window);
			Base.map.addOverlay(marker);
			
			if (anchor && anchor == submission_prefix + i) open_info_window();
		});
		
		$('#feeling_lucky').click(function() {
			info_window_openers.rand()();
			return false;
		});
        // 
        // $('#black_rock').click(function() {
        //     var geoXml;
        // 
        //     function zoomToGeoXML(geoXml) {
        //         console.log(geoXml);
        //         var center = geoXml.getDefaultCenter();
        //         console.log(center);
        //         var span = geoXml.getDefaultSpan();
        //         var sw = new GLatLng(center.lat() - span.lat() / 2,
        //         center.lng() - span.lng() / 2);
        //         var ne = new GLatLng(center.lat() + span.lat() / 2,
        //         center.lng() + span.lng() / 2);
        //         var bounds = new GLatLngBounds(sw, ne);
        //         Base.map.setCenter(center);
        //         Base.map.setZoom(Base.map.getBoundsZoomLevel(bounds));
        //         Base.map.addOverlay(geoXml);
        //     }
        //     
        //     geoXml = new GGeoXml("http://localhost:3000/BlackRockFiber20100716.kmz", function() {
        //         zoomToGeoXML(geoXml); // centering the map according to the kml data
        //     });
        //     return false;
        // });


	}
});
