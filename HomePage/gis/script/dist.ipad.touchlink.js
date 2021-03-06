﻿//zhangliang 2012-04-17

(function($) {
    $.fn.touchlink = function(options) {
        if (!this)
            return false;

        var sender = $(this);

        function setnomark(ele) {
            var childs = ele.childNodes;
            ele['nomark'] = true;
            if (childs) {
                for (var i = 0; i < childs.length; i++) {
                    setnomark(childs[i]);
                }
            }
        }

        return this.each(function() {
            var $this = $(this);
            setnomark($this[0]);

            var defaultBackgroundColor = $this[0].style.backgroundColor;
            $this.bind('touchstart mousedown', mousedownHandler);
            $this.bind('touchend mouseup', mouseupHandler);
            $this.bind('touchend mouseout', mouseupHandler);
            
            //$this.addClass('bgTrasnsition');
            function mousedownHandler() {
                $this[0].style.backgroundColor = '#5eb2cb';
                $this.addClass('touchdown');
            }

            function mouseupHandler() {
                $this[0].style.backgroundColor = defaultBackgroundColor;
                $this.removeClass('touchdown');
            }

            //阻止响应两次事件
            $this.bind("touchstart", function (e) {
                e.preventDefault();
            })
        });
    }
})(jQuery);