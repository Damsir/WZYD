(function() {
    var polygonBorderWidth = null;     //边框宽度
    var polygonBorderColor = null;    //边框颜色
    //window.FeatureLayerHelper = function(featurelayer) {
    dist.gis.featureLayerHelper = function(featurelayer) {
        if (!featurelayer) return;
        var self = this;

        var geometryType = featurelayer.geometryType;
        var symbol = featurelayer.renderer.symbol ? featurelayer.renderer.symbol : featurelayer.renderer.defaultSymbol;

        var symbolType = null;
        if (symbol) {
            symbolType = symbol.type;
        }
        
        //设置Point符号的大小
        this.setPointSymbolSize = function(size) {
            if (size < 0) return;
            symbol.setSize(size);
            featurelayer.refresh();
        }

        //获取Point符号的大小
        this.getPointSymbolSize = function() {
            return symbol.size;
        }

        //获取Polyline符号的线宽
        this.getPolylineSymbolWidth = function() {
            return symbol.width;
        }

        //设置Point、Polyline、Polygon符号的线型
        //Point仅支持SimpleMarkerSymbol，不支持PictureMarkerSymbol
        //Polygon仅支持SimpleFillSymbol，不支持PictureFillSymbol
        this.setSymbolStyle = function(style) {
            if (symbolType == 'picturemarkersymbol' || symbolType == 'picturefillsymbol') {
                alert('不支持修改该Symbol类型，请使用标准Symbol类型。');
                return;
            }
            // var newSymbol = this.newSymbol(symbol).setStyle(style);

            symbol.style = style;
            var newSymbol = this.newSymbol(symbol);
            var renderer = new esri.renderer.SimpleRenderer(newSymbol);
            featurelayer.setRenderer(renderer);
            featurelayer.refresh();
        }

        //设置Polyline符号的线宽
        this.setPolylineSymbolWidth = function(width) {
            if (width < 0) return;
            symbol.width = width;
            var newSymbol = this.newSymbol(symbol);
            var renderer = new esri.renderer.SimpleRenderer(newSymbol);
            featurelayer.refresh();
        }

        //设置Point、Polyline、Polygon符号的颜色
        this.setSymbolColor = function(color) {
            var newSymbol = this.newSymbol(symbol).setColor(color);
            var renderer = new esri.renderer.SimpleRenderer(newSymbol);
            featurelayer.setRenderer(renderer);
            featurelayer.refresh();
        }



        //设置Polygon边框的宽度和颜色
        this.setSymbolOutline = function(parm, flag) {
            if (flag == 'w') { polygonBorderWidth = parm; }
            if (flag == 'c') { polygonBorderColor = new dojo.Color(parm); }

            if (polygonBorderWidth != '' && polygonBorderColor != '') {
                var OutLineSymbol;
                if (polygonBorderWidth == 'null' || polygonBorderColor == 'null') {
                    OutLineSymbol = this.newSymbol(symbol).setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0]), 0.0000000000001));
                }
                else {
                    OutLineSymbol = this.newSymbol(symbol).setOutline(new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, polygonBorderColor, polygonBorderWidth));
                }
                var renderer = new esri.renderer.SimpleRenderer(OutLineSymbol);
                featurelayer.setRenderer(renderer);
                featurelayer.refresh();
            }

        }

        this.setDefaultSymbol = function() {
            var initSym = this.newSymbol(featurelayer.initSymbol);
            var renderer = new esri.renderer.SimpleRenderer(initSym);
            featurelayer.setRenderer(renderer);
            featurelayer.refresh();
        }

        this.newSymbol = function(sym) {

            var symType = sym.type;
            var newSym;
            if (symType == 'simplemarkersymbol') {
                var outline = this.newSymbol(sym.outline);
                newSym = new esri.symbol.SimpleMarkerSymbol(sym.style, sym.size, outline, sym.color);
            }
            else if (symType == 'simplelinesymbol') {
                newSym = new esri.symbol.SimpleLineSymbol(sym.style, sym.color, sym.width);
            }
            else if (symType == 'simplefillsymbol') {
                var outline = this.newSymbol(sym.outline);
                newSym = new esri.symbol.SimpleFillSymbol(sym.style, outline, sym.color);
            }
            else if (symType == 'picturemarkersymbol') {

            }
            else if (symType == 'picturefillsymbol') {

            }
            return newSym;
        }

        this.clearSymbol = function() {
            var newSymbol = this.newSymbol(symbol);
            var renderer = new esri.renderer.SimpleRenderer(newSymbol);
            featurelayer.setRenderer(renderer);
            //dist.desktop.currentScreen.map.esrimap.removeLayer(featurelayer);
            featurelayer.setVisibility(false);
            featurelayer.refresh();
        }
        this.removeFeatureLayer = function() {
            dist.map.removeLayer(featurelayer)
        }

        if (!featurelayer.initSymbol) {
            if(symbol){
                featurelayer.initSymbol = this.newSymbol(symbol);
            }
        }
    }
})();



