(function() {
    DistDrawWidgetHelper = function(params) {

        var $s = this;
        this.paras = params;
        //this.map = paras.map;
        if (params) {
            if (params.drawEndHandle)
                this.drawEndHandle = params.drawEndHandle;
            if (params.container)
                this.container = params.container;
        }

        this.toolbar = null;
        this.hasInit = false;
        this.drawLayerID = "DIST_DRAW_LAYER_" + dist.desktop.nextSequence();
        this.renderPara = { color: '#FF0000' };
        this.pointGeometryType = "point";
        this.lineGeometryType = "polyline";
        this.polygonGeometryType = "polygon";
        this.isAddLabel = false;
        this.drawToolbar = null;
        this.drawing = false;
        this.drawType = '';

        this.clickHandleUnit;

        this.pointType = [{ "label": "圆形", "value": esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE },
                       { "label": "十字", "value": esri.symbol.SimpleMarkerSymbol.STYLE_CROSS },
                       { "label": "菱形", "value": esri.symbol.SimpleMarkerSymbol.STYLE_DIAMOND },
                       { "label": "方形", "value": esri.symbol.SimpleMarkerSymbol.STYLE_SQUARE },
                       { "label": "X", "value": esri.symbol.SimpleMarkerSymbol.STYLE_X}];
        this.lineType = [{ "label": "虚线", "value": esri.symbol.SimpleLineSymbol.STYLE_DASH },
                      { "label": "实线", "value": esri.symbol.SimpleLineSymbol.STYLE_SOLID}];
        this.polygonType = [{ "label": "全填充", "value": esri.symbol.SimpleFillSymbol.STYLE_SOLID },
                         { "label": "左斜线", "value": esri.symbol.SimpleFillSymbol.STYLE_BACKWARD_DIAGONAL },
                         { "label": "网格", "value": esri.symbol.SimpleFillSymbol.STYLE_CROSS },
                         { "label": "斜网格", "value": esri.symbol.SimpleFillSymbol.STYLE_DIAGONAL_CROSS },
                         { "label": "右斜线", "value": esri.symbol.SimpleFillSymbol.STYLE_FORWARD_DIAGONAL },
                         { "label": "水平线", "value": esri.symbol.SimpleFillSymbol.STYLE_HORIZONTAL },
                         { "label": "垂直线", "value": esri.symbol.SimpleFillSymbol.STYLE_VERTICAL}];
        this.pointSize = [{ "label": "20", "value": 20 },
                       { "label": "25", "value": 25 },
                       { "label": "30", "value": 30 },
                       { "label": "35", "value": 35}];
        this.lineWidth = [{ "label": "5", "value": 5 },
                       { "label": "6", "value": 6 },
                       { "label": "7", "value": 7 },
                       { "label": "8", "value": 8 },
                       { "label": "9", "value": 9}];

        this.labelSize = [{ "label": "15", "value": "15pt" },
                       { "label": "20", "value": "20pt" },
                       { "label": "25", "value": "25pt" },
                       { "label": "30", "value": "30pt" },
                       { "label": "35", "value": "35pt"}];


        this.maxSize_his = 10;

        this.preHistory = [];
        this.nextHistory = [];

        //需要设置Draw工具的目标map
        this.setMap = function(esrimap) {
            var toDraw = this.drawing;
            if (this.drawing) {
                this.deactiveDrawTool();
            }
            this.toolbar = new esri.toolbars.Draw(esrimap);
            dojo.connect(this.toolbar, "onDrawEnd", this.addToMap);
            this.map = esrimap;
            if (toDraw)
                this.activeDrawTool(this.drawType, this.renderPara);
        }

        //取消绘制
        this.unDraw = function() {
            this.clearGraphics();
        }


        this.addlayer = function() {
            var drawlayer = this.map.getLayer(this.drawLayerID);
            if (!drawlayer) {
                var graphicsLayer = new esri.layers.GraphicsLayer({ id: this.drawLayerID });
                this.map.addLayer(graphicsLayer);
                graphicsLayer.disableMouseEvents();
                return graphicsLayer;
            }
            else {
                return drawlayer;
            }
        }

        this.addToMap = function(geometry) {
            var symbol;
            switch (geometry.type) {
                case "point":
                    symbol = new esri.symbol.SimpleMarkerSymbol($s.renderPara.type, $s.renderPara.size, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color($s.renderPara.color), 1), new dojo.Color($s.renderPara.color));
                    break;
                case "polyline":
                    symbol = new esri.symbol.SimpleLineSymbol($s.renderPara.type, new dojo.Color($s.renderPara.color), $s.renderPara.size);
                    break;
                case "polygon":
                    var co = new dojo.Color($s.renderPara.color);
                    co.a = 0.5;
                    symbol = new esri.symbol.SimpleFillSymbol($s.renderPara.type, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color($s.renderPara.color), 2), co);
                    break;
            }
            var graphic = new esri.Graphic(geometry, symbol);
            $s.addlayer().add(graphic);

            $s.addToHistory(graphic);
            //$s.deactiveDrawTool();

            if ($s.drawEndHandle)
                eval($.drawEndHandle)();
        }

        this.addToHistory = function(gra) {
            var graphic_His = new esri.Graphic(gra.geometry, gra.symbol);
            $s.preHistory.push(graphic_His);

            if ($s.preHistory.length > $s.maxSize_his) {
                $s.preHistory[0] = null;
                $s.preHistory.splice(0, 1);
            }
            $s.nextHistory = [];
        }

        this.undo = function() {
            if ($s.preHistory.length == 0) {
                return;
            }
            var layer = $s.addlayer();

            if (layer.graphics.length > 0) {
                $s.preHistory.pop(drawToolbar.preHistory.length - 1);
                var gra = layer.graphics[layer.graphics.length - 1];
                var graphic_His = new esri.Graphic(gra.geometry, gra.symbol);
                $s.nextHistory.push(graphic_His);
                layer.remove(layer.graphics[layer.graphics.length - 1]);
            }
        }
        this.redo = function() {
            if ($s.nextHistory.length == 0) {
                return;
            }
            var layer = $s.addlayer();

            var gra = drawToolbar.nextHistory[$s.nextHistory.length - 1];
            var graphic_His = new esri.Graphic(gra.geometry, gra.symbol);
            $s.preHistory.push(graphic_His);
            layer.add(gra);
            $s.nextHistory.pop(drawToolbar.nextHistory.length - 1);
        }

        this.deactiveDrawTool = function() {
            if (this.toolbar) {
                //不知道什么原因，在触发了FREEHAND_POLYLINE或者FREEHAND_POLYGON之后，就会出现地图拖动不了的问题，所以加上下面这句
                //估计是个esri的bug
                this.toolbar.activate(esri.toolbars.Draw.FREEHAND_POLYLINE);
                this.toolbar.deactivate();
                this.map.showZoomSlider();
            }
            if (this.clickHandleUnit) {
                dojo.disconnect(this.clickHandleUnit);
                this.clickHandleUnit = null;
                this.isAddLabel = false;
            }
            this.drawing = false;
        }

        this.mapClickHandler = function(evt) {
            $s.deactiveDrawTool();
            if ($s.renderPara.labelText != "") {
                var font = new esri.symbol.Font($s.renderPara.labelSize, esri.symbol.Font.STYLE_NORMAL, esri.symbol.Font.VARIANT_NORMAL, esri.symbol.Font.WEIGHT_BOLDER);
                var symbol = esri.symbol.TextSymbol($s.renderPara.labelText, font, new dojo.Color($s.renderPara.color))
                var pt = new esri.geometry.Point(evt.mapPoint.x, evt.mapPoint.y, drawToolbar.map.spatialReference);
                var graphic = new esri.Graphic(pt, symbol);
                $s.addlayer().add(graphic);
                addToHistory(graphic);
            }
            if ($s.drawEndHandle)
                eval($s.drawEndHandle)();
        }

        //renderPara.type对应pointType、lineType、polygonType的value；
        //renderPara.size是点的大小；
        //renderPara.width是线的宽度；
        //renderPara.color是颜色值，例如[255,0,0,0.25]，"#C0C0C0"，"blue"；
        this.activeDrawTool = function(type, renderPara) {
            if (dist.desktop.globle.gisFunction != "绘制" && dist.desktop.globle.falseFunction != null) {
                eval(dist.desktop.globle.falseFunction)();
            }
            this.deactiveDrawTool();
            this.renderPara = renderPara;
            this.drawType = type;
            switch (type) {
                case "point":
                    this.toolbar.activate(esri.toolbars.Draw.POINT);
                    break;
                case "polyline":
                    this.toolbar.activate(esri.toolbars.Draw.FREEHAND_POLYLINE);
                    break;
                case "polygon":
                    this.toolbar.activate(esri.toolbars.Draw.FREEHAND_POLYGON);
                    break;
            }
            this.map.hideZoomSlider();
            dist.desktop.globle.gisFunction = "绘制";
            dist.desktop.globle.falseFunction = this.deactiveDrawTool;
            this.drawing = true;
        }

        //renderPara.labelText  标签的内容
        //renderPara.color 标签的颜色值
        //renderPara.labelSize 标签的大小
        this.activeAddLabel = function(renderPara) {
            if (dist.desktop.globle.gisFunction != "绘制" && dist.desktop.globle.falseFunction != null) {
                eval(dist.desktop.globle.falseFunction)();
            }
            this.deactiveDrawTool();
            this.isAddLabel = true;
            this.renderPara = renderPara;
            this.clickHandleUnit = dojo.connect(drawToolbar.map, "onClick", drawToolbar.mapClickHandler);

            dist.desktop.globle.gisFunction = "绘制";
            dist.desktop.globle.falseFunction = this.deactiveDrawTool;

        }
        //清除绘制
        this.clearGraphics = function() {
            if (!this.map)
                return;
            var drawlayer = this.map.getLayer(this.drawLayerID);
            if (drawlayer) {
                drawlayer.clear();
            }
            //this.toolbar.deactivate();
            //this.map.showZoomSlider();
        }

        this.drawTypeElements = [];
        this.drawParamSelector = [];
        this.drawParamEleGroup = [];
        this.colorSelecotrEle = null;
        this.initControl = function() {

            var pointDrawDiv = document.createElement('DIV');
            pointDrawDiv.className = 'widget-button';
            pointDrawDiv.innerText = '画点';

            var polylineDrawDiv = document.createElement('DIV');
            polylineDrawDiv.className = 'widget-button';
            polylineDrawDiv.innerText = '画线';

            var polygonDrawDiv = document.createElement('DIV');
            polygonDrawDiv.className = 'widget-button';
            polygonDrawDiv.innerText = '画面';

            var markDrawDiv = document.createElement('DIV');
            markDrawDiv.className = 'widget-button';
            markDrawDiv.innerText = '标注';
            markDrawDiv.style.display = 'none';

            var stopDraw = document.createElement('DIV');
            stopDraw.className = 'widget-button';
            stopDraw.innerText = '停止绘制';

            var clearDraw = document.createElement('DIV');
            clearDraw.className = 'widget-button';
            clearDraw.innerText = '清除';

            this.drawTypeElements = [pointDrawDiv, polylineDrawDiv, polygonDrawDiv];

            //颜色
            this.colorSelecotrEle = this.createColorPicker();

            //点大小
            var pointSizeDiv = this.createParameterControl(this.pointSize, '大小', this.onSizeChange);

            //点样式
            var pointStyleDiv = this.createParameterControl(this.pointType, '样式', this.onStyleChange);

            //线宽
            var lineSizeDiv = this.createParameterControl(this.lineWidth, '线宽', this.onSizeChange);

            //线样式
            var lineStyleDiv = this.createParameterControl(this.lineType, '样式', this.onStyleChange);

            //面样式
            var polygonStyleDiv = this.createParameterControl(this.polygonType, '样式', this.onStyleChange);

            this.drawParamEleGroup = [[pointSizeDiv, pointStyleDiv], [lineSizeDiv, lineStyleDiv], [polygonStyleDiv]];

            this.container.appendChild(pointDrawDiv);
            this.container.appendChild(polylineDrawDiv);
            this.container.appendChild(polygonDrawDiv);
            this.container.appendChild(stopDraw);
            this.container.appendChild(clearDraw);

            this.container.appendChild(this.colorSelecotrEle);
            this.container.appendChild(pointSizeDiv);
            this.container.appendChild(pointStyleDiv);
            this.container.appendChild(lineSizeDiv);
            this.container.appendChild(lineStyleDiv);
            this.container.appendChild(polygonStyleDiv);

            this.showEle(-1);

            $(pointDrawDiv).touchlink().bind('touchend click', function() {
                $s.showEle(0);
                $s.activeDrawTool('point', $s.getDrawParam('point'));
            });

            $(polylineDrawDiv).touchlink().bind('touchend click', function() {
                $s.showEle(1);
                $s.activeDrawTool('polyline', $s.getDrawParam('polyline'));
            });

            $(polygonDrawDiv).touchlink().bind('touchend click', function() {
                $s.showEle(2);
                $s.activeDrawTool('polygon', $s.getDrawParam('polygon'));
            });

            $(stopDraw).touchlink().bind('touchend click', function() {
                $s.showEle(-1);
                $s.deactiveDrawTool();
            });

            $(clearDraw).touchlink().bind('touchend click', function() {
                $s.clearGraphics();
            });
        }

        this.showEle = function(j) {
            if (j == -1)
                this.colorSelecotrEle.style.display = 'none';
            else
                this.colorSelecotrEle.style.display = 'block';
            for (var i = 0; i < this.drawTypeElements.length; i++) {
                this.drawTypeElements[i].className = i == j ? 'widget-button but-selected' : 'widget-button';
            }
            for (var i = 0; i < this.drawParamEleGroup.length; i++) {
                var g = this.drawParamEleGroup[i];
                var display = i == j ? 'block' : 'none';
                for (var k = 0; k < g.length; k++) {
                    g[k].style.display = display;
                }
            }
        }

        this.createParameterControl = function(source, label, changedFunction) {
            var paramDiv = document.createElement('DIV');
            paramDiv.className = 'widget-param';
            var labelDiv = document.createElement('DIV');
            labelDiv.innerText = label;
            labelDiv.className = 'widget-param-name';
            var valueContainer = document.createElement('DIV');
            valueContainer.className = 'widget-param-input';
            var select = document.createElement('SELECT');
            for (var i = 0; i < source.length; i++) {
                var op = new Option(source[i].label, source[i].value);
                select.options[i] = op;
            }
            select.onchange = changedFunction;
            paramDiv.appendChild(labelDiv);
            paramDiv.appendChild(valueContainer);
            valueContainer.appendChild(select);
            this.drawParamSelector.push(select);
            return paramDiv;
        }

        this.onStyleChange = function() {
            $s.renderPara.type = this.value;
        }

        this.onSizeChange = function() {
            $s.renderPara.size = this.value;
        }

        this.getDrawParam = function(t) {
            if (t == 'point') {
                return { type: this.drawParamSelector[1].value, size: this.drawParamSelector[0].value, color: this.renderPara.color };
            } else if (t == 'polyline') {
                return { type: this.drawParamSelector[3].value, size: this.drawParamSelector[2].value, color: this.renderPara.color };
            } else if (t == 'polygon') {
                return { type: this.drawParamSelector[4].value, size: 0, color: this.renderPara.color };
            }
        }

        this.createColorPicker = function() {
            var colorDiv = document.createElement('DIV');
            colorDiv.className = 'widget-param';
            var colorLabelDiv = document.createElement('DIV');
            colorLabelDiv.innerText = '颜色';
            colorLabelDiv.className = 'widget-param-name';
            var colorPreviewContainer = document.createElement('DIV');
            colorPreviewContainer.className = 'widget-param-input';
            var colorPreview = document.createElement('DIV');
            colorPreview.className = 'preview3';
            var colorPicker3 = document.createElement('DIV');
            colorPicker3.className = 'colorpicker3';
            colorPicker3.style.display = 'none';
            var canvasPicker = document.createElement('CANVAS');
            canvasPicker.id = 'picker3';
            //canvasPicker.style.position = 'absolute';
            canvasPicker.style.width = '300';
            canvasPicker.style.height = '300';
            //canvasPicker.style.display = 'none';
            colorPicker3.appendChild(canvasPicker);
            colorDiv.appendChild(colorLabelDiv);
            colorDiv.appendChild(colorPreviewContainer);
            colorPreviewContainer.appendChild(colorPreview);
            colorPreviewContainer.appendChild(colorPicker3);

            var bCanPreview = true; // can preview

            // create canvas and context objects
            //var canvas = document.getElementById('picker3');
            var ctx = canvasPicker.getContext('2d');

            // drawing active image
            var image = new Image();
            image.onload = function() {
                ctx.drawImage(image, 0, 0, image.width, image.height); // draw the image on the canvas
            }
            image.src = 'images/colorwheel1.png';

            $(canvasPicker).mousemove(function(e) { // mouse move handler
                if (bCanPreview) {
                    // get coordinates of current position
                    var canvasOffset = $(canvasPicker).offset();
                    var canvasX = Math.floor(e.pageX - canvasOffset.left);
                    var canvasY = Math.floor(e.pageY - canvasOffset.top);

                    // get current pixel
                    var imageData = ctx.getImageData(canvasX, canvasY, 1, 1);
                    var pixel = imageData.data;

                    // update preview color
                    var pixelColor = "rgb(" + pixel[0] + ", " + pixel[1] + ", " + pixel[2] + ")";
                    colorPreview.style.backgroundColor = pixelColor;

                    var dColor = pixel[2] + 256 * pixel[1] + 65536 * pixel[0];
                    var cv = '#' + ('0000' + dColor.toString(16)).substr(-6);

                }
            });

            $(canvasPicker).bind('touchend click', function(e) {
                bCanPreview = false;
                colorPicker3.style.display = 'none';
                $s.renderPara.color = colorPreview.style.backgroundColor;
            });

            $(colorPreview).bind('touchend click', function(e) { // preview click
                if (colorPicker3.style.display == 'none') {
                    colorPicker3.style.display = 'block';
                    bCanPreview = true;
                } else {
                    colorPicker3.style.display = 'none';
                    bCanPreview = false;
                }
            });

            return colorDiv;
        }

        if (this.container)
            this.initControl();
    }
})();