(function() {
    DistDrawWidgetHelper = function() {
        var helper = this;
        var pointDrawDiv;
        var polylineDrawDiv;
        var polygonDrawDiv;
        var markDrawDiv;
        var pointDrawFlag;
        var polylineDrawFlag;
        var polygonDrawFlag;
        var markDrawFlag;
        var colorDiv;
        var sizeDiv;
        var geometryStyleDiv;
        var textDiv;
        var sizeInput;
        var textInput;
        var geometryStyleSelect;
        var borderBottomStyle = 'solid 3px #0AF9F6';
        var drawToolbar = null;
        var map;
        var sms = new esri.symbol.SimpleMarkerSymbol().setStyle(esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE).setColor(new dojo.Color([255, 0, 0, 0.5]));
        var sls = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SHORTDASH, new dojo.Color([0, 0, 255, 0.5]), 2);
        var sfs = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0, 0.7]), 3), new dojo.Color([151, 219, 20, .7]));
        var pointColor = 'red';
        var polylineColor = 'red';
        var polygonColor = 'red';
        var textColor = 'red';
        var pointSize = 10;
        var polylineSize = 2;
        var textSize = 14;
        var pointStyle = esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE;
        var polylineStyle = esri.symbol.SimpleLineSymbol.STYLE_SOLID;
        var polygonStyle = esri.symbol.SimpleFillSymbol.STYLE_SOLID;
        var textValue;

        //var drawIng=false;

        var pointStyles = [
                                { label: '圆形', style: esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE },
                                { label: '方形', style: esri.symbol.SimpleMarkerSymbol.STYLE_SQUARE },
                                { label: '钻石', style: esri.symbol.SimpleMarkerSymbol.STYLE_DIAMOND },
                                { label: '十字', style: esri.symbol.SimpleMarkerSymbol.STYLE_CROSS }
                            ];
        var polylineStyles = [
                                { label: '实线', style: esri.symbol.SimpleLineSymbol.STYLE_SOLID },
                                { label: '虚线', style: esri.symbol.SimpleLineSymbol.STYLE_DASH },
                                { label: '点线', style: esri.symbol.SimpleLineSymbol.STYLE_DOT }
                            ];
        var polygonStyles = [
                                { label: '填充', style: esri.symbol.SimpleFillSymbol.STYLE_SOLID },
                                { label: '水平纹', style: esri.symbol.SimpleFillSymbol.STYLE_HORIZONTAL },
                                { label: '垂直纹', style: esri.symbol.SimpleFillSymbol.STYLE_VERTICAL },
                                { label: '前斜纹', style: esri.symbol.SimpleFillSymbol.STYLE_FORWARD_DIAGONAL },
                                { label: '后斜纹', style: esri.symbol.SimpleFillSymbol.STYLE_BACKWARD_DIAGONAL },
                                { label: '交叉纹', style: esri.symbol.SimpleFillSymbol.STYLE_CROSS },
                                { label: '交叉对角纹', style: esri.symbol.SimpleFillSymbol.STYLE_DIAGONAL_CROSS }
                            ];

        //需要设置Draw工具的目标map
        this.setMap = function(esrimap) {
            ///if(!drawToolbar){
            drawToolbar = new esri.toolbars.Draw(esrimap);
            map = esrimap;
            // drawIng=true;
            //}
        }

        //取消绘制
        this.unDraw = function() {
            //drawIng=false;
            if (drawToolbar && drawToolbar.finishDrawing) drawToolbar.finishDrawing();
        }

        //绘制文字标记
        this.drawMarkGeometry = function(sym) {
            var markListener = dojo.connect(map, 'onClick', function(evt) {
                dojo.disconnect(markListener);
                //if (map.graphics)
                //    map.graphics.clear();
                var graphic = new esri.Graphic(evt.mapPoint, sym);
                map.graphics.add(graphic);
            });
        }

        //绘制普通geometry
        this.drawGeometry = function(geometryType, sym) {
            //if (map.graphics)
            //    map.graphics.clear();
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
                if (drawToolbar.finishDrawing) drawToolbar.finishDrawing();
                drawToolbar.deactivate(geometryType);
                //if (map.graphics)
                //    map.graphics.clear();
                var graphic = new esri.Graphic(geometry, sym);
                map.graphics.add(graphic);
            });

        }

        //绘制自由geometry
        this.drawFreeGeometry = function(geometryType, sym) {
            //if (map.graphics)
            //    map.graphics.clear();
            if (drawToolbar.finishDrawing) drawToolbar.finishDrawing();
            drawToolbar.deactivate(geometryType);
            drawToolbar.activate(geometryType);
            if (geometryType == esri.toolbars.Draw.FREEHAND_POLYLINE) {
                sym = sym ? sym : sls;
                drawToolbar.setLineSymbol(sym);
            }
            else if (geometryType == esri.toolbars.Draw.FREEHAND_POLYGON) {
                sym = sym ? sym : sfs;
                drawToolbar.setFillSymbol(sym);
            }
            drawToolbar.onDrawEnd = function(geometry) {
                if (drawToolbar.finishDrawing) drawToolbar.finishDrawing();
                drawToolbar.deactivate(geometryType);
                //if (map.graphics)
                //    map.graphics.clear();
                var graphic = new esri.Graphic(geometry, sym);
                map.graphics.add(graphic);

            }
        }

        //设置SELECT数据源
        this.setSelectDataSrc = function(select, dataSrc) {
            if (select && dataSrc && dataSrc.length > 0) {
                select.innerHTML = '';
                for (var i = 0; i < dataSrc.length; i++) {
                    var o = document.createElement('OPTION');
                    o.value = dataSrc[i].style;
                    o.innerText = dataSrc[i].label;
                    select.appendChild(o);
                }
            }
        }

        //设置UI界面
        this.setDrawDiv = function(div) {
            div.innerHTML = '';

            var drawTypeDiv = document.createElement('DIV');
            drawTypeDiv.style.padding = '5px';
            drawTypeDiv.style.display = 'block';
            drawTypeDiv.style.borderBottom = 'solid 1px #cccccc';

            pointDrawDiv = document.createElement('DIV');
            pointDrawDiv.className = 'widget-button';
            pointDrawDiv.innerText = '画点';

            polylineDrawDiv = document.createElement('DIV');
            polylineDrawDiv.className = 'widget-button';
            polylineDrawDiv.innerText = '画线';

            polygonDrawDiv = document.createElement('DIV');
            polygonDrawDiv.className = 'widget-button';
            polygonDrawDiv.innerText = '画面';

            markDrawDiv = document.createElement('DIV');
            markDrawDiv.className = 'widget-button';
            markDrawDiv.innerText = '标注';
            markDrawDiv.style.display = 'none';

            var clearDraw = document.createElement('DIV');
            clearDraw.className = 'widget-button';
            clearDraw.innerText = '清除';

            var styleDiv = document.createElement('DIV');
            styleDiv.style.display = 'block';

            colorDiv = document.createElement('DIV');
            colorDiv.className = 'widget-param';
            colorDiv.style.display = 'none';
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
            canvasPicker['var'] = 1;
            canvasPicker.style.width = '300';
            canvasPicker.style.height = '300';

            sizeDiv = document.createElement('DIV');
            sizeDiv.className = 'widget-param';
            var sizeLabelDiv = document.createElement('DIV');
            sizeLabelDiv.innerText = '大小';
            sizeLabelDiv.className = 'widget-param-name';
            var sizeContainer = document.createElement('DIV');
            sizeContainer.className = 'widget-param-input';
            sizeInput = document.createElement('SELECT');
            for (var i = 1; i <= 10; i++) {
                var op = new Option(i, i);
                sizeInput.options[i - 1] = op;
            }

            //sizeInput.onkeyup = function() { if (!/\d+/.test(this.value)) { alert('只能输入数字'); this.value = 5 } }
            //sizeInput.onafterpaste = function() { if (!/\d+/.test(this.value)) { alert('只能输入数字'); this.value = 5 } }

            geometryStyleDiv = document.createElement('DIV');
            geometryStyleDiv.className = 'widget-param';
            //geometryStyleDiv.style.display = 'none';
            var geometryStyleLabelDiv = document.createElement('DIV');
            geometryStyleLabelDiv.innerText = '样式';
            geometryStyleLabelDiv.className = 'widget-param-name';
            var geometryStyleContainer = document.createElement('DIV');
            geometryStyleContainer.className = 'widget-param-input';
            geometryStyleSelect = document.createElement('SELECT');

            textDiv = document.createElement('DIV');
            textDiv.className = 'widget-param';
            //textDiv.style.display = 'none';
            var textLabelDiv = document.createElement('DIV');
            textLabelDiv.innerText = '文字';
            textLabelDiv.className = 'widget-param-name';
            var textContainer = document.createElement('DIV');
            textContainer.className = 'widget-param-input';
            textInput = document.createElement('INPUT');

            drawTypeDiv.appendChild(pointDrawDiv);
            drawTypeDiv.appendChild(polylineDrawDiv);
            drawTypeDiv.appendChild(polygonDrawDiv);
            drawTypeDiv.appendChild(markDrawDiv);
            drawTypeDiv.appendChild(clearDraw);
            colorPicker3.appendChild(canvasPicker);
            colorDiv.appendChild(colorLabelDiv);
            colorDiv.appendChild(colorPreviewContainer);
            colorPreviewContainer.appendChild(colorPreview);
            colorPreviewContainer.appendChild(colorPicker3);
            sizeContainer.appendChild(sizeInput);
            sizeDiv.appendChild(sizeLabelDiv);
            sizeDiv.appendChild(sizeContainer);
            geometryStyleContainer.appendChild(geometryStyleSelect);
            geometryStyleDiv.appendChild(geometryStyleLabelDiv);
            geometryStyleDiv.appendChild(geometryStyleContainer);
            textContainer.appendChild(textInput);
            textDiv.appendChild(textLabelDiv);
            textDiv.appendChild(textContainer);
            styleDiv.appendChild(colorDiv);
            styleDiv.appendChild(sizeDiv);
            styleDiv.appendChild(geometryStyleDiv);
            div.appendChild(drawTypeDiv);
            div.appendChild(styleDiv);
            div.appendChild(textDiv);

            var clearFun = function(sender) {
                pointDrawDiv.className = 'widget-button';
                polylineDrawDiv.className = 'widget-button';
                polygonDrawDiv.className = 'widget-button';
                markDrawDiv.className = 'widget-button';
                if (sender)
                    sender.className = 'widget-button but-selected';

                markDrawDiv.style.borderBottom = polylineDrawDiv.style.borderBottom = polygonDrawDiv.style.borderBottom = '';
                markDrawFlag = polylineDrawFlag = polygonDrawFlag = false;
                helper.unDraw();
                colorDiv.style.display = '';
                sizeDiv.style.display = '';
                textDiv.style.display = 'none';
                geometryStyleDiv.style.display = '';
                /*
                if (map.graphics)
                map.graphics.clear();
                */
            }

            $(clearDraw).touchlink().bind('touchend click', function() {
                clearFun();
                colorDiv.style.display = 'none';
                sizeDiv.style.display = 'none';
                geometryStyleDiv.style.display = 'none';
                if (map.graphics)
                    map.graphics.clear();
            });

            $(pointDrawDiv).touchlink().bind('touchend click', function() {
                clearFun(this);
                pointDrawFlag = true;
                $('.preview3').css('backgroundColor', pointColor);
                sizeInput.value = pointSize;
                helper.setSelectDataSrc(geometryStyleSelect, pointStyles);
                startDrawPoint();
            });


            $(polylineDrawDiv).touchlink().bind('touchend click', function() {
                clearFun(this);
                polylineDrawFlag = true;
                $('.preview3').css('backgroundColor', polylineColor);
                sizeInput.value = polylineSize;
                helper.setSelectDataSrc(geometryStyleSelect, polylineStyles);
                startDrawPolyline();
            });

            $(polygonDrawDiv).touchlink().bind('touchend click', function() {
                clearFun(this);
                polygonDrawFlag = true;
                $('.preview3').css('backgroundColor', polygonColor);
                helper.setSelectDataSrc(geometryStyleSelect, polygonStyles);
                startDrawPolygon();
            });

            $(markDrawDiv).touchlink().bind('touchend click', function() {
                clearFun(this);
                textDiv.style.display = '';
                markDrawFlag = true;
                $('.preview3').css('backgroundColor', textColor);
                sizeInput.value = textSize;
            });


            geometryStyleSelect.onchange = function() {
                if (pointDrawFlag) {
                    pointStyle = geometryStyleSelect.value;
                    startDrawPoint();
                }

                if (polylineDrawFlag) {
                    polylineStyle = geometryStyleSelect.value;
                    startDrawPolyline();
                }

                if (polygonDrawFlag) {
                    polygonStyle = geometryStyleSelect.value;
                    startDrawPolygon();
                }

                if (markDrawFlag) {
                    textStyle = geometryStyleSelect.value;
                    startDrawText();
                }
            }



            sizeInput.onchange = function() {
                if (pointDrawFlag) {
                    pointSize = sizeInput.value;
                    startDrawPoint();
                }

                if (polylineDrawFlag) {
                    polylineSize = sizeInput.value;
                    startDrawPolyline();
                }

                if (polygonDrawFlag) {
                    polygonSize = sizeInput.value;
                    startDrawPolygon();
                }

                if (markDrawFlag) {
                    textSize = sizeInput.value;
                    startDrawText();
                }
            }

            textInput.onkeyup = function() {
                if (markDrawFlag) {
                    textSize = sizeInput.value;
                    startDrawText();
                }
            }


            function startDrawPoint() {
                pointStyle = geometryStyleSelect.value ? geometryStyleSelect.value : pointStyle;
                pointSize = sizeInput.value ? sizeInput.value : pointSize;
                var sym = new esri.symbol.SimpleMarkerSymbol(pointStyle, pointSize, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color(pointColor), 1), new dojo.Color(pointColor));
                helper.drawFreeGeometry(esri.toolbars.Draw.POINT, sym);
            }

            function startDrawPolyline() {
                polylineStyle = geometryStyleSelect.value ? geometryStyleSelect.value : polylineStyle;
                polylineSize = sizeInput.value ? sizeInput.value : polylineSize;
                var sym = new esri.symbol.SimpleLineSymbol(polylineStyle, new dojo.Color(polylineColor), polylineSize);
                helper.drawFreeGeometry(esri.toolbars.Draw.POLYLINE, sym);
            }

            function startDrawPolygon() {
                polygonStyle = geometryStyleSelect.value ? geometryStyleSelect.value : polygonStyle;
                var sym = new esri.symbol.SimpleFillSymbol(polygonStyle, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color(polygonColor), 3), new dojo.Color(polygonColor));
                helper.drawFreeGeometry(esri.toolbars.Draw.POLYGON, sym);
            }

            function startDrawText() {
                textValue = textInput.value;
                if (textValue && textValue != '') {
                    textSize = sizeInput.value ? sizeInput.value : textSize;
                    var sym = new esri.symbol.TextSymbol(textValue, new esri.symbol.Font(textSize + "pt"), new dojo.Color(textColor))
                    helper.drawMarkGeometry(sym);
                }
            }

            var bCanPreview = true; // can preview

            // create canvas and context objects
            var canvas = document.getElementById('picker3');
            var ctx = canvas.getContext('2d');

            // drawing active image
            var image = new Image();
            image.onload = function() {
                ctx.drawImage(image, 0, 0, image.width, image.height); // draw the image on the canvas
            }

            // select desired colorwheel
            var imageSrc = 'images/colorwheel1.png';
            switch ($(canvas).attr('var')) {
                case '2':
                    imageSrc = 'images/colorwheel2.png';
                    break;
                case '3':
                    imageSrc = 'images/colorwheel3.png';
                    break;
                case '4':
                    imageSrc = 'images/colorwheel4.png';
                    break;
                case '5':
                    imageSrc = 'images/colorwheel5.png';
                    break;
            }
            image.src = imageSrc;

            $(canvasPicker).mousemove(function(e) { // mouse move handler
                if (bCanPreview) {
                    // get coordinates of current position
                    var canvasOffset = $(canvas).offset();
                    var canvasX = Math.floor(e.pageX - canvasOffset.left);
                    var canvasY = Math.floor(e.pageY - canvasOffset.top);

                    // get current pixel
                    var imageData = ctx.getImageData(canvasX, canvasY, 1, 1);
                    var pixel = imageData.data;

                    // update preview color
                    var pixelColor = "rgb(" + pixel[0] + ", " + pixel[1] + ", " + pixel[2] + ")";
                    $('.preview3').css('backgroundColor', pixelColor);

                    var dColor = pixel[2] + 256 * pixel[1] + 65536 * pixel[0];
                    var cv = '#' + ('0000' + dColor.toString(16)).substr(-6);

                    if (pointDrawFlag) {
                        pointColor = cv;
                        startDrawPoint();
                    }

                    if (polylineDrawFlag) {
                        polylineColor = cv;
                        startDrawPolyline();
                    }

                    if (polygonDrawFlag) {
                        polygonColor = cv;
                        startDrawPolygon();
                    }

                    if (markDrawFlag) {
                        textColor = cv;
                        startDrawText();
                    }
                }
            });

            $(canvasPicker).click(function(e) { // click event handler
                bCanPreview = false;
                colorPicker3.style.display = 'none';
            });

            $(colorPreview).click(function(e) { // preview click
                if (colorPicker3.style.display == 'none') {
                    colorPicker3.style.display = 'block';
                    bCanPreview = true;
                } else {
                    colorPicker3.style.display = 'none';
                    bCanPreview = false;
                }
            });
        }


    }


})()