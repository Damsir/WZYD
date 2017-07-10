(function() {
    window.vScroller = function(target) {
        if (undefined == window.MSGesture)
            return;
        this.ele = $(document.getElementById(target));
        this.ele[0].style.position = 'relative';
        this.endTimeout = 0;
        this.handDown = false;
        this.startY = 0;
        this.startScrollY = 0;
        this.container = this.ele[0].parentNode;

        var $s = this;

        this.ge = function(evt) {
            $s.gestureEventListener(evt);
        };

        this.ele[0].addEventListener("MSGestureStart", this.ge, false);
        this.ele[0].addEventListener("MSGestureEnd", this.ge, false);
        this.ele[0].addEventListener("MSGestureChange", this.ge, false);
        this.ele[0].addEventListener("MSPointerDown", this.ge, false);

        this.containerGesture = new MSGesture();
        this.containerGesture.target = this.ele[0];

        this.gestureEventListener = function(evt) {

            if (evt.type == "MSPointerDown") {
                this.containerGesture.addPointer(evt.pointerId);
                return;
            }
            if (evt.type == 'MSGestureStart') {
                this.startY = evt.screenY;
                var spStr = this.ele[0].style.top;

                if (spStr) {
                    this.startScrollY = parseInt(this.ele[0].style.top.replace('px', ''));
                } else
                    this.startScrollY = 0;
                this.handDown = true;
                clearTimeout(this.endTimeout);
                this.endTimeout = setTimeout(this.timeOverHandler, 3000);
            } else if (evt.type == 'MSGestureChange' && this.handDown) {
                var nowY = evt.screenY;
                var newSL = this.startScrollY + (nowY - this.startY);
                this.ele.css({ top: newSL });
                clearTimeout(this.endTimeout);
                this.endTimeout = setTimeout(this.timeOverHandler, 3000);
            } else if (evt.type == 'MSGestureEnd') {
                this.gsEnd();
            }
        };

        this.gsEnd = function() {
            this.handDown = false;
            var ps = this.ele.position();
            if (ps.top > 0)
                this.ele.animate({ top: 0 });
            else {
                var h = this.container.offsetHeight;
                var fullHeight = this.ele[0].offsetHeight;
                if (h > fullHeight)
                    this.ele.animate({ top: 0 });
                else if (h + Math.abs(ps.top) > fullHeight) {
                    this.ele.animate({ top: h - fullHeight });
                }
            }
            clearTimeout(this.endTimeout);
        };

        this.timeOverHandler = function() {
            $s.gsEnd();
        };
    }
})();
