(function() {
    dist.gis.measureWidgetHelper = function() {

        var helper = this;
        var lengthDiv;
        var areaDiv;
        var valueDiv;
        var selectedColor = '#F99E8F';
        var drawToolbar = null;
        var drawPoints = [];
        var measureWidListener; //测量事件监听
        var navToolbar;
        this.geometryType = null;
        this.sym = null;

        
        var sls = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SHORTDASH, new dojo.Color([255, 0, 0, 0.5]), 4);
        var sms = new esri.symbol.SimpleMarkerSymbol().setStyle(esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE).setColor(new dojo.Color([255, 0, 0, 0.5]));
        var sfs = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0, 0.7]), 3), new dojo.Color([151, 219, 20, .7]));

        //需要设置Draw工具的目标map
        this.setMap = function(esrimap) {
            this.map = esrimap;
            this.unDraw();
            drawToolbar = new esri.toolbars.Draw(this.map);
            navToolbar = new esri.toolbars.Navigation(this.map);
            var $s = this;

            dojo.connect(drawToolbar, "onDrawEnd", function(geometry) {
                $s.onDrawEnd(geometry);
            });
        }

        //取消绘制
        this.unDraw = function() {
            if (drawToolbar) {
                drawToolbar.activate(esri.toolbars.Draw.FREEHAND_POLYLINE);
                drawToolbar.deactivate();
            }
            if (this.map)
                this.map.graphics.clear();
            this.btnLength.className = this.btnArea.className = 'widget-button';
        }



        //绘制自由geometry
        this.drawFreeGeometry = function(geometryType) {
            var sym;
            if (geometryType == 'polyline') {
                sym = sls;
                drawToolbar.setLineSymbol(sym);
            }
            else if (geometryType == 'polygon') {
                sym = sfs;
                drawToolbar.setFillSymbol(sym);

            }
            this.geometryType = geometryType;
            this.sym = sym;
        };

        this.onDrawEnd = function(geometry) {
            if (drawToolbar.finishDrawing) drawToolbar.finishDrawing();
            drawToolbar.deactivate(this.geometryType);
            distMapHelper.clear(); //清除map上的GraphicsLayers和Graphics
            var graphic = new esri.Graphic(geometry, this.sym);
            this.map.graphics.add(graphic); 

            //保存测量结果
            var widValue;
            //将投影坐标转换成经纬度坐标
            geometry = esri.geometry.webMercatorToGeographic(geometry);
            if (this.geometryType == 'polyline') {
                var lengths = esri.geometry.geodesicLengths([geometry], esri.Units.METERS);
                var len = Math.round(lengths[0]);
                if (len > 1000) {
                    len = Math.round(len / 1000);
                    widValue = len + ' 千米';
                }
                else {
                    widValue = len + ' 米';
                }
            }
            else if (this.geometryType == 'polygon') {
                var areas = esri.geometry.geodesicAreas([geometry], esri.Units.SQUARE_METERS);
                var area = Math.round(areas[0]);
                if (area > 1000000) {
                    area = Math.round(area / 1000000);
                    widValue = area + ' 平方千米';
                }
                else {
                    widValue = area + ' 平方米';
                }
            }
            valueDiv.style.color = 'Green'
            valueDiv.innerText = widValue;
            //卸载测量事件监听
            dojo.disconnect(measureWidListener);
            this.mapChange = false;
        };

        /*
        //绘制普通geometry
        this.drawGeometry = function(geometryType, sym) {
        //            map.graphics.clear();
        distMapHelper.clear(); //清除map上的GraphicsLayers和Graphics
        if (drawToolbar.finishDrawing) drawToolbar.finishDrawing();
        drawToolbar.deactivate(geometryType);
        drawToolbar.activate(geometryType);
        if (geometryType == esri.toolbars.Draw.POLYLINE) {
        sym = sym ? sym : sls;
        drawToolbar.setLineSymbol(sym);
        }
        else if (geometryType == esri.toolbars.Draw.POLYGON) {
        sym = sym ? sym : sfs;
        drawToolbar.setFillSymbol(sym);
        }
        else if (geometryType == esri.toolbars.Draw.POINT) {
        sym = sym ? sym : sms;
        drawToolbar.setMarkerSymbol(sym);
        }


            dojo.connect(drawToolbar, "onDrawEnd", function(geometry) {
        dojo.disconnect(drawListener);
        if (drawToolbar.finishDrawing) drawToolbar.finishDrawing();
        drawToolbar.deactivate(geometryType);
        //map.graphics.clear();
        distMapHelper.clear(); //清除map上的GraphicsLayers和Graphics
        var graphic = new esri.Graphic(geometry, sym);
        map.graphics.add(graphic);
        //将投影坐标转换成经纬度坐标
        geometry = esri.geometry.webMercatorToGeographic(geometry);
        if (geometryType == esri.toolbars.Draw.POLYLINE) {
        var lengths = esri.geometry.geodesicLengths([geometry], esri.Units.METERS);
        var len = Math.round(lengths[0]);
        //取绝对值
        len = Math.abs(len);
        if (len > 1000) {
        len = Math.round(len / 1000);
        valueDiv.innerText = len + ' 千米';
        }
        else {
        valueDiv.innerText = len + ' 米';
        }
        }
        else if (geometryType == esri.toolbars.Draw.POLYGON) {

                    var areas = esri.geometry.geodesicAreas([geometry], esri.Units.SQUARE_METERS);
        var area = Math.round(areas[0]);
        //取绝对值
        area = Math.abs(area);
        if (area > 1000000) {
        area = Math.round(area / 1000000);
        valueDiv.innerText = area + ' 平方千米';
        }
        else {
        valueDiv.innerText = area + ' 平方米';
        }
        }

            });

            drawPoints = [];
        drawListener = dojo.connect(map, 'onClick', function(evt) {
        drawPoints.push(evt.mapPoint);
        valueDiv.style.color = 'Green'
        if (geometryType == esri.toolbars.Draw.POLYLINE) {
        if (drawPoints.length > 1) {
        var polyline = new esri.geometry.Polyline(map.spatialReference);
        polyline.addPath(drawPoints);
        //将投影坐标转换成经纬度坐标
        polyline = esri.geometry.webMercatorToGeographic(polyline);
        var lengths = esri.geometry.geodesicLengths([polyline], esri.Units.METERS);
        var len = Math.round(lengths[0]);
        //取绝对值
        len = Math.abs(len);
        if (len > 1000) {
        len = Math.round(len / 1000);
        valueDiv.innerText = len + ' 千米';
        }
        else {
        valueDiv.innerText = len + ' 米';
        }
        }
        }
        else if (geometryType == esri.toolbars.Draw.POLYGON) {
        if (drawPoints.length > 2) {
        var polygon = new esri.geometry.Polygon(new esri.SpatialReference({ wkid: 4326 }));
        polygon.addRing(drawPoints);
        //将投影坐标转换成经纬度坐标
        polygon = esri.geometry.webMercatorToGeographic(polygon);
        var areas = esri.geometry.geodesicAreas([polygon], esri.Units.SQUARE_METERS);
        var area = Math.round(areas[0]);
        //取绝对值
        area = Math.abs(area);
        if (area > 1000000) {
        area = Math.round(area / 1000000);
        valueDiv.innerText = area + ' 平方千米';
        }
        else {
        valueDiv.innerText = area + ' 平方米';
        }
        }
        }
        });
        }
        */




        this.btnLength = null;
        this.btnArea = null;

        //设置UI界面
        this.setMeasureDiv = function(div) {
            div.innerHTML = '';
            var fieldDiv = document.createElement('DIV');
            fieldDiv.style.width = '20%';
            fieldDiv.style.display = 'inline-block';
            fieldDiv.style.margin = '5px';
            fieldDiv.style.fontWeight = 'bold';
            fieldDiv.style.backgroundColor = '#cccccc';
            fieldDiv.innerText = '选择';

            lengthDiv = document.createElement('DIV');
            lengthDiv.className = 'widget-button';
            lengthDiv.innerText = '距离量算';

            areaDiv = document.createElement('DIV');
            areaDiv.className = 'widget-button';
            areaDiv.innerText = '面积量算';

            var btnUnDraw = document.createElement('DIV');
            btnUnDraw.className = 'widget-button';
            btnUnDraw.innerText = '停止量算';

            valueDiv = document.createElement('DIV');
            valueDiv.className = 'measure-value';
            valueDiv.innerText = '.';
            valueDiv.style.color = 'White'

            div.appendChild(lengthDiv);
            div.appendChild(areaDiv);
            div.appendChild(btnUnDraw);
            div.appendChild(valueDiv);
            this.btnLength = lengthDiv;
            this.btnArea = areaDiv;
            $(lengthDiv).touchlink().bind('touchend click', function() {
                navToolbar.deactivate();
                drawToolbar.activate(esri.toolbars.Draw.FREEHAND_POLYLINE);

                helper.map.graphics.clear();
                this.className = 'widget-button but-selected';
                valueDiv.innerText = '.';
                valueDiv.style.color = 'White'
                areaDiv.className = 'widget-button';
                helper.drawFreeGeometry(esri.toolbars.Draw.POLYLINE);
            });

            $(areaDiv).touchlink().bind('touchend click', function() {
                navToolbar.deactivate();
                drawToolbar.activate(esri.toolbars.Draw.FREEHAND_POLYGON);


                helper.map.graphics.clear();
                this.className = 'widget-button but-selected';
                lengthDiv.className = 'widget-button';
                valueDiv.innerText = '.';
                valueDiv.style.color = 'White'
                helper.drawFreeGeometry(esri.toolbars.Draw.POLYGON);
            });

            $(btnUnDraw).touchlink().bind('touchend click', function() {
                helper.unDraw();
                distMapHelper.clear(); //清除map上的GraphicsLayers和Graphics
                areaDiv.className = 'widget-button';
                valueDiv.innerText = '.';
                valueDiv.style.color = 'White'
                lengthDiv.className = 'widget-button';
            });

        }
    }

})()