var lotFlag = false;
(function() {
    DistLotWidgetHelper = function() {
        var self = this;

        this.setLotAnalyseDiv = function(div) {

            div.innerHTML = '';

            lotDiv = document.createElement('DIV');
            lotDiv.className = 'widget-button';
            lotDiv.innerText = '面积分析';
            lotDiv.style.cursor = 'pointer';

            clearDiv = document.createElement('DIV');
            clearDiv.className = 'widget-button';
            clearDiv.innerText = '清除结果';
            clearDiv.style.cursor = 'pointer';

            valueDiv = document.createElement('DIV');
            valueDiv.className = 'measure-value';
            valueDiv.id = 'areaValue';
            valueDiv.innerText = '';



            div.appendChild(lotDiv);
            div.appendChild(clearDiv);
            div.appendChild(valueDiv);

            $(lotDiv).touchlink().bind('touchend click', function() {
                dist.desktop.currentScreen.map.esrimap.graphics.clear();
                lotFlag = true;        //开启地块面积分析
                dist.desktop.showAttributes = true;
                this.className = 'widget-button but-selected';

            });

            $(clearDiv).touchlink().bind('touchend click', function() {

                lotFlag = false;        //关闭地块面积分析
                dist.desktop.showAttributes = false;
                lotDiv.className = 'widget-button';
                document.getElementById('areaValue').innerText = "";
                sumArea = 0;
                dist.desktop.currentScreen.map.esrimap.graphics.clear();
            });

        }

    }
})()