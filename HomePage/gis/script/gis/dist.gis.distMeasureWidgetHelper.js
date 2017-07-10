(function() {
    DistMeasureWidgetHelper = function() {
        //        dojo.require("esri.toolbars.draw");

        var helper = this;
        var lengthDiv;
        var areaDiv;
        var valueDiv;
        var selectedColor = '#F99E8F';
        var drawToolbar = null;
        var drawPoints = [];
        var map;
        var drawListener;
        var navToolbar;

        var sls = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SHORTDASH, new dojo.Color([255, 0, 0, 0.5]), 4);
        var sms = new esri.symbol.SimpleMarkerSymbol().setStyle(esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE).setColor(new dojo.Color([255, 0, 0, 0.5]));
        var sfs = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0, 0.7]), 3), new dojo.Color([151, 219, 20, .7]));

        //需要设置Draw工具的目标map
        this.setMap = function(esrimap) {
            //if(!drawToolbar){
            map = esrimap;
            drawToolbar = new esri.toolbars.Draw(map);
            navToolbar = new esri.toolbars.Navigation(map);
            //}
        }

        //取消绘制
        this.unDraw = function() {
            dojo.disconnect(drawListener);
            if (drawToolbar && drawToolbar.finishDrawing) drawToolbar.finishDrawing();
        }

        //绘制普通geometry
        this.drawGeometry = function(geometryType, sym) {
            map.graphics.clear();
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
                map.graphics.clear();
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

            dojo.connect(drawToolbar, "onDrawEnd", function(geometry) {
                dojo.disconnect(drawListener);
                if (drawToolbar.finishDrawing) drawToolbar.finishDrawing();
                drawToolbar.deactivate(geometryType);
                map.graphics.clear();
                var graphic = new esri.Graphic(geometry, sym);
                map.graphics.add(graphic); 
                // //将投影坐标转换成经纬度坐标
                geometry = esri.geometry.webMercatorToGeographic(geometry);
                if (geometryType == 'polyline') {
                    var lengths = esri.geometry.geodesicLengths([geometry], esri.Units.METERS);
                    var len = Math.round(lengths[0]);
                    if (len > 1000) {
                        len = Math.round(len / 1000);
                        valueDiv.innerText = len + ' 千米';
                    }
                    else {
                        valueDiv.innerText = len + ' 米';
                    }
                }
                else if (geometryType == 'polygon') {
                    var areas = esri.geometry.geodesicAreas([geometry], esri.Units.SQUARE_METERS);
                    var area = Math.round(areas[0]);
                    if (area > 1000000) {
                        area = Math.round(area / 1000000);
                        valueDiv.innerText = area + ' 平方千米';
                    }
                    else {
                        valueDiv.innerText = area + ' 平方米';
                    }
                }

            });
        }




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
            valueDiv.innerText = '';

            //div.appendChild(fieldDiv);
            div.appendChild(lengthDiv);
            div.appendChild(areaDiv);
            div.appendChild(btnUnDraw);
            div.appendChild(valueDiv);

            $(lengthDiv).touchlink().bind('touchend click', function() {
                navToolbar.deactivate();
                drawToolbar.activate(esri.toolbars.Draw.FREEHAND_POLYLINE);
                helper.unDraw();
                map.graphics.clear();
                this.className = 'widget-button but-selected';
                valueDiv.innerText = '';
                areaDiv.className = 'widget-button';
                helper.drawFreeGeometry(esri.toolbars.Draw.POLYLINE);
            });

            $(areaDiv).touchlink().bind('touchend click', function() {
                navToolbar.deactivate();
                drawToolbar.activate(esri.toolbars.Draw.FREEHAND_POLYGON);
                helper.unDraw();
                map.graphics.clear();
                this.className = 'widget-button but-selected';
                lengthDiv.className = 'widget-button';
                valueDiv.innerText = '';
                helper.drawFreeGeometry(esri.toolbars.Draw.POLYGON);
            });

            $(btnUnDraw).touchlink().bind('touchend click', function() {
                helper.unDraw();
                map.graphics.clear();
                areaDiv.className = 'widget-button';
                valueDiv.innerText = '';
                lengthDiv.className = 'widget-button';
            });
        }
    }

})()


