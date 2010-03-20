//= require <base>
//= require <jquery.fancybox-1.3.1>

Array.prototype.rand = function() {
	function rand(n) { return Math.floor(Math.random() * n); }
	return this[rand(this.length)];
};


function show_large(path, title) {
	$.fancybox({ href: path, title: title });
}

$(document).ready(function() {


	if (Base.submissions && GBrowserIsCompatible()) {
		Base.map = new GMap2(document.getElementById("map"));

		Base.map.setCenter(new GLatLng(48.7597,-122.4869),13);
		Base.map.addControl(new GSmallMapControl(),new GControlPosition(G_ANCHOR_TOP_LEFT,new GSize(10, 50)));
		Base.map.setMapType(G_PHYSICAL_MAP);




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

		var info_window_openers = [];
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
	}
});
