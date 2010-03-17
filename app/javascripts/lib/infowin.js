// InfoWin class for displaying a miniature info window. Does not
// respond to any events - so you should show and remove the
// overlay yourself as necessary.

// from http://ajaxian.com/archives/custom-info-windows-with-jquery-and-google-maps
 
function InfoWin(latlng, html) {
        this.latlng_ = latlng;
        this.html_ = html;
        this.prototype = new GOverlay();
 
        // Creates the DIV representing the infowindow
        this.initialize = function(map) {
                var div = $('<div />');
                div.css({
                        position : 'absolute',
                        width : 321
                }).appendTo(map.getPane(G_MAP_FLOAT_PANE));
 
                this.map_ = map;
                this.div_ = div;
 
                this.update(html);
        };
 
        this.update = function(html){
                this.html_ = html;
 
                this.div_.empty();
 
                $('<div />').css({
                        'background-image' : 'url(/images/popout_top.png)',
                        height : 23,
                        padding: '0 0 0 0'
                }).appendTo(this.div_);
 
                var content = $('<div />').addClass('infowin-content').css({
                        'position' : 'relative',
                        'overflow' : 'hidden',
                        'max-height' : 570,
                        'top' : -5
                }).html(html);
 
                $('<div />').css({
                        'background-image' : 'url(/images/popout_bottom.png)',
                        'background-position' : 'bottom left',
                        'padding' : '0 10px 100px 10px'
                }).append(content).appendTo(this.div_);
 
                this.redraw(true);
        };
 
        // Remove the main DIV from the map pane
        this.remove = function() {
          this.div_.remove();
        };
 
        // Copy our data to a new instance
        this.copy = function() {
          return new InfoWin(this.latlng_, this.html_);
        };
 
        // Redraw based on the current projection and zoom level
        this.redraw = function(force) {
                if (!force) return;
 
                var point = this.map_.fromLatLngToDivPixel(this.latlng_);
 
                // Now position our DIV based on the DIV coordinates of our bounds
                this.div_.css({
                        left : point.x - 325,
                        top : point.y - this.div_.height() - 20
                });
        };
}
 

