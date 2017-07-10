/******************************************
////////////////////////////////////////////////////////////////////////////////
//
//
//Copyright(C) 2012 上海数慧系统技术有限公司
//版权所有。
//文件名：DistMapHelper
//文件功能描述：辅助帮助和控制map
//
//创建标识：Chen Youqing
//创建时间：2012-3-28
////////////////////////////////////////////////////////////////////////////////
******************************************/

///<imports>各种引用</imports>
dojo.require("esri.map");
dojo.require("esri.layers.agsdynamic");
dojo.require("esri.layers.agstiled");

///<summary>Map辅助帮手</summary>
///<param name="map" type="Map">需要辅助管理和控制的Map</param>
///<returns>没有返回值</returns>
dist.gis.mapHelper = function(map) {

    var targetMap = map;
    var dojoConnectionFlag;

    ///<summary>map</summary>
    ///<returns>Map</returns>
    this.map = map;

    ///<summary>map自带的GraphicsLayer</summary>
    ///<returns>GraphicsLayer</returns>
    this.graphics = targetMap.graphics;

    ///<summary>map中所有GraphicsLayer的id</summary>
    ///<returns>String[]</returns>
    this.graphicsLayerIds = targetMap.graphicsLayerIds;

    ///<summary>map的height(屏幕像素)</summary>
    ///<returns>Number</returns>
    this.height = targetMap.height;

    ///<summary>map的id</summary>
    ///<returns>String</returns>
    this.id = targetMap.id;

    ///<summary>map的infoWindow</summary>
    ///<returns>InfoWindow</returns>
    this.infoWindow = targetMap.infoWindow;

    ///<summary>是否显示缩放导航工具条</summary>
    ///<returns>Boolean</returns>
    this.isZoomSlider = targetMap.isZoomSlider;

    ///<summary>map中所有 TiledMapServiceLayers（切片地图） 和 DynamicMapServiceLayers（动态地图） 的id</summary>
    ///<returns>String[]</returns>
    this.layerIds = targetMap.layerIds;

    ///<summary>map的第一个layer是否加装完成</summary>
    ///<returns>Boolean</returns>
    this.loaded = targetMap.loaded;

    ///<summary>map的width(屏幕像素)</summary>
    ///<returns>Number</returns>
    this.width = targetMap.width;

    ///<summary>添加动态地图服务</summary>
    ///<param name="url" type="String">动态地图服务地址</param>
    ///<param name="options" type="Object">动态地图服务参数，可不填
    ///<childParam key="gdbVersion" type="String">指定geodatabase版本</childParam>
    ///<childParam key="id" type="String">id</childParam>
    ///<childParam key="imageParameters" type="ImageParameters">...</childParam>
    ///<childParam key="opacity" type="Number" default="1" range="0.0-1.0">map移动时是否显示Graphics</childParam>
    ///<childParam key="useMapImage" type="Boolean" default="false">...</childParam>
    ///<childParam key="useMapTime" type="Boolean" default="true">...</childParam>
    ///<childParam key="visible" type="Boolean" default="true">GraphicsLayer可视性</childParam>
    ///</param>
    ///<param name="index" type="int">地图索引顺序，可不填</param>
    ///<returns>ArcGISDynamicMapServiceLayer</returns>
    ///<example>addArcGISDynamicMapServiceLayer("your url",{id:"myArcGISDynamicMapServiceLayer",opacity:0.20})</example>
    this.addArcGISDynamicMapServiceLayer = function(url, options, index) {
        var dynamicMapServiceLayer;
        if (arguments.length == 1) {
            dynamicMapServiceLayer = new esri.layers.ArcGISDynamicMapServiceLayer(url);
            targetMap.addLayer(dynamicMapServiceLayer);
        }
        else {
            dynamicMapServiceLayer = new esri.layers.ArcGISDynamicMapServiceLayer(url, options);
            targetMap.addLayer(dynamicMapServiceLayer, index);
        }

        return dynamicMapServiceLayer;
    }
    ///<summary>添加切片地图服务</summary>
    ///<param name="url" type="String">切片地图服务地址</param>
    ///<param name="options" type="Object">切片地图服务参数，可不填
    ///<childParam key="displayLevels" type="Number[]">指定要显示的各级地图切片</childParam>
    ///<childParam key="id" type="String">id</childParam>
    ///<childParam key="opacity" type="Number" default="1" range="0.0-1.0">map移动时是否显示Graphics</childParam>
    ///<childParam key="tileServers" type="String[]" >...</childParam>
    ///<childParam key="visible" type="Boolean" default="true">GraphicsLayer可视性</childParam>
    ///</param>
    ///<param name="index" type="int">地图索引顺序，可不填</param>
    ///<returns>ArcGISTiledMapServiceLayer</returns>
    ///<example>addArcGISTiledMapServiceLayer("your url",{id:"myArcGISTiledMapServiceLayer",displayLevels:[0,1,2,3,4,5,6,7],opacity:0.20})</example>
    this.addArcGISTiledMapServiceLayer = function(url, options, index) {
        var tileMapServiceLayer;
        if (arguments.length == 1) {
            tileMapServiceLayer = new esri.layers.ArcGISTiledMapServiceLayer(url);
            targetMap.addLayer(tileMapServiceLayer);
        }
        else {
            tileMapServiceLayer = new esri.layers.ArcGISTiledMapServiceLayer(url, options);
            targetMap.addLayer(tileMapServiceLayer, index);
        }

        return tileMapServiceLayer;
    }

    ///<summary>添加GraphicsLayer</summary>
    ///<param name="options" type="Object">GraphicsLayer参数对象，可不填
    ///<childParam key="displayOnPan" type="Boolean" default="true">map移动时是否显示Graphics</childParam>
    ///<childParam key="id" type="String" default="null">id</childParam>
    ///<childParam key="opacity" type="Number" default="1" range="0.0-1.0">map移动时是否显示Graphics</childParam>
    ///<childParam key="visible" type="Boolean" default="true">GraphicsLayer可视性</childParam>
    ///</param>
    ///<param name="index" type="int">地图索引顺序，可不填</param>
    ///<returns>GraphicsLayer</returns>
    ///<example>addGraphicsLayer({id:"myGraphicsLayer",opacity:0.20})</example>
    this.addGraphicsLayer = function(options, index) {
        var graphicsLayer;
        if (arguments.length == 0) {
            graphicsLayer = new esri.layers.GraphicsLayer();
            targetMap.addLayer(graphicsLayer);
        }
        else {
            graphicsLayer = new esri.layers.GraphicsLayer(options);
            targetMap.addLayer(graphicsLayer, index);
        }

        return graphicsLayer;
    }

    var graphicLayerIndex = 0;
    this.removeGraphicLayer = function() {
        for(var i = 0;i < graphicLayerList.length;i++)
            targetMap.removeLayer(graphicLayerList[i]);
    }
    ///<summary>增加Graphic到GraphicLayer中</summary>
    ///<param name="geometry" type="Geometry">将要绘制Graphic对象</param>
    ///<param name="isClear" type="Boolean">是否清除GraphicLayer中的Graphic</param>
    ///<returns>没有返回值</returns>
    this.addGraphicLayerHighLight = function(geometry, isClear, imap) {
        if (isClear)
            this.removeGraphicLayer();
        //用于属性查询、测量、分析是要素高亮
        var graphicLayer = new esri.layers.GraphicsLayer();
        var symbol;
        if (geometry instanceof esri.geometry.Point) {
            symbol = new esri.symbol.PictureMarkerSymbol('../GIS/Img/map/dtz2.png', 17, 30);
            symbol.setOffset(0, 15);
        }
        else if (geometry instanceof esri.geometry.Polyline) {
            symbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
            new dojo.Color([255, 0, 0, 0.5]), 5);
        }
        else if (geometry instanceof esri.geometry.Polygon) {
            symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID,
            new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
            new dojo.Color([255, 0, 0, 0.7]), 5), new dojo.Color([151, 219, 20, .7]));
        }
        graphicLayer.add(new esri.Graphic(geometry, symbol));
        graphicLayerList[graphicLayerIndex++] = graphicLayer;
        //graphicLayer增加到map中
        if (imap) { targetMap = imap; }
        targetMap.addLayer(graphicLayer);
        //alert(graphicLayer.id);
    }




    ///<summary>添加GraphicsLayer</summary>
    ///<param name="options" type="Object">GraphicsLayer参数对象，可不填
    ///<childParam key="displayOnPan" type="Boolean" default="true">map移动时是否显示Graphics</childParam>
    ///<childParam key="id" type="String" default="null">id</childParam>
    ///<childParam key="opacity" type="Number" default="1" range="0.0-1.0">map移动时是否显示Graphics</childParam>
    ///<childParam key="visible" type="Boolean" default="true">GraphicsLayer可视性</childParam>
    ///</param>
    ///<param name="index" type="int">地图索引顺序，可不填</param>
    ///<returns>GraphicsLayer</returns>
    ///<example>addGraphicsLayer({id:"myGraphicsLayer",opacity:0.20})</example>
    this.getGraphicsLayer = function(layerId) {
        if (arguments.length != 1) return;
        var lyr = this.getLayer(layerId);
        if (lyr) {
            if (lyr instanceof esri.layers.GraphicsLayer) {
                return lyr;
            }
        }
        else {
            return this.addGraphicsLayer({ id: layerId });
        }
    }

    ///<summary>添加FeatureLayer</summary>
    ///<param name="url" type="String">图层地址</param>
    ///<param name="options" type="Object">GraphicsLayer参数对象，可不填
    ///<childParam key="displayOnPan" type="Boolean" default="true">map移动时是否显示Graphics</childParam>
    ///<childParam key="id" type="String" default="null">id</childParam>
    ///<childParam key="opacity" type="Number" default="1" range="0.0-1.0">map移动时是否显示Graphics</childParam>
    ///<childParam key="visible" type="Boolean" default="true">GraphicsLayer可视性</childParam>
    ///</param>
    ///<param name="index" type="int">地图索引顺序，可不填</param>
    ///<returns>GraphicsLayer</returns>
    ///<example>addGraphicsLayer({id:"myGraphicsLayer",opacity:0.20})</example>
    this.addFeatureLayer = function(url, options, index) {
        var featureLayer;
        if (arguments.length == 1) {
            featureLayer = new esri.layers.FeatureLayer(url);
            targetMap.addLayer(featureLayer);
        }
        else if (arguments.length == 2) {
            featureLayer = new esri.layers.FeatureLayer(url, options);
            targetMap.addLayer(featureLayer);
        }
        else {
            featureLayer = new esri.layers.FeatureLayer(url, options);
            targetMap.addLayer(featureLayer, index);
        }
        dojo.connect(featureLayer, "onClick", onClickFeatureLayerHandler);
        return featureLayer;
    }

    ///<summary>添加FeatureLayer</summary>
    ///<param name="url" type="String">图层地址</param>
    ///<param name="options" type="Object">GraphicsLayer参数对象，可不填
    ///<childParam key="displayOnPan" type="Boolean" default="true">map移动时是否显示Graphics</childParam>
    ///<childParam key="id" type="String" default="null">id</childParam>
    ///<childParam key="opacity" type="Number" default="1" range="0.0-1.0">map移动时是否显示Graphics</childParam>
    ///<childParam key="visible" type="Boolean" default="true">GraphicsLayer可视性</childParam>
    ///</param>
    ///<param name="index" type="int">地图索引顺序，可不填</param>
    ///<returns>GraphicsLayer</returns>
    ///<example>addGraphicsLayer({id:"myGraphicsLayer",opacity:0.20})</example>
    this.addSNAPSHOTFeatureLayer = function(url, index) {
        var featureLayer;
        var infoTemplate = new esri.InfoTemplate("自我介绍", "${*}");
        if (arguments.length == 1) {
            featureLayer = new esri.layers.FeatureLayer(url, {
                mode: esri.layers.FeatureLayer.MODE_SNAPSHOT,
                outFields: ["*"],
                infoTemplate: infoTemplate
            });
            targetMap.addLayer(featureLayer);
        }
        else {
            featureLayer = new esri.layers.FeatureLayer(url, options);
            targetMap.addLayer(featureLayer, index);
        }
        dojo.connect(featureLayer, "onClick", onClickFeatureLayerHandler);

        return featureLayer;
    }
    function mapClear(evt) {
        targetMap.graphics.clear();
        //        dojo.disconnect(dojoConnectionFlag);
    }
    function onClickFeatureLayerHandler(evt) {
        targetMap.graphics.clear();
        
        /*
        var graphic = new esri.Graphic(evt.graphic.geometry);
        if (graphic.geometry instanceof esri.geometry.Point) {
            var sms = new esri.symbol.SimpleMarkerSymbol().setStyle(esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE).setColor(new dojo.Color([255, 0, 0, 0.5]));
            graphic.setSymbol(sms);
        }
        else if (graphic.geometry instanceof esri.geometry.Polyline) {
            var sls = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0, 0.5]), 5);
            graphic.setSymbol(sls);
        }
        else if (graphic.geometry instanceof esri.geometry.Polygon) {
            var sfs = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0, 0.5]), 5), new dojo.Color([255, 255, 0, 0.25]));
            graphic.setSymbol(sfs);
        }
        //        dojoConnectionFlag = dojo.connect(targetMap.graphics, "onMouseOut", mapClear);
        //targetMap.graphics.add(graphic);
        */
        onMapClick(evt.graphic);
    }

    ///<summary>获取layer</summary>
    ///<param name="id" type="String">layer id</param>
    ///<returns>layer</returns>
    this.getLayer = function(id) {
        return targetMap.getLayer(id);
    }

    ///<summary>获取切片地图所在比例尺级数，仅适用于切片地图服务</summary>
    ///<returns>Number</returns>
    this.getLevel = function() {
        return targetMap.getLevel();
    }

    ///<summary>移去地图中所有layers</summary>
    ///<returns>没有返回值</returns>
    this.removeAllLayers = function() {
        return targetMap.removeAllLayers();
    }

    ///<summary>移除地图中指定的layer</summary>
    ///<param name="layer">要移除的layer</param>
    ///<returns>没有返回值</returns>
    this.removeLayer = function(layer) {
        return targetMap.removeLayer(layer);
    }

    ///<summary>重新指定layer在地图中的索引顺序</summary>
    ///<param name="layer">layer</param>
    ///<param name="index" type="Number">新的地图索引</param>
    ///<returns>没有返回值</returns>
    this.reorderLayer = function(layer, index) {
        return targetMap.reorderLayer(layer, index);
    }

    ///<summary>激活鼠标移动地图</summary>
    ///<returns>没有返回值</returns>
    this.enablePan = function() {
        targetMap.enablePan();
    }
    ///<summary>禁用鼠标移动地图</summary>
    ///<returns>没有返回值</returns>
    this.disablePan = function() {
        targetMap.disablePan();
    }
    ///<summary>地图上移</summary>
    ///<returns>没有返回值</returns>
    this.panUp = function() {
        targetMap.panUp();
    }
    ///<summary>地图下移</summary>
    ///<returns>没有返回值</returns>
    this.panDown = function() {
        targetMap.panDown();
    }
    ///<summary>地图左移</summary>
    ///<returns>没有返回值</returns>
    this.panLeft = function() {
        targetMap.panLeft();
    }
    ///<summary>地图右移</summary>
    ///<returns>没有返回值</returns>
    this.panRight = function() {
        targetMap.panRight();
    }
    ///<summary>地图向西南方向（左下）移动</summary>
    ///<returns>没有返回值</returns>
    this.panLowerLeft = function() {
        targetMap.panLowerLeft();
    }
    ///<summary>地图向东南方向（右下）移动</summary>
    ///<returns>没有返回值</returns>
    this.panLowerRight = function() {
        targetMap.panLowerRight();
    }
    ///<summary>地图向西北方向（左上）移动</summary>
    ///<returns>没有返回值</returns>
    this.panUpperLeft = function() {
        targetMap.panUpperLeft();
    }
    ///<summary>地图向东北方向（右上）移动</summary>
    ///<returns>没有返回值</returns>
    this.panUpperRight = function() {
        targetMap.panUpperRight();
    }

    ///<summary>定位某点到地图中心</summary>
    ///<param name="point" type="Point">地图某点</param>
    ///<returns>没有返回值</returns>
    this.centerAt = function(point) {
        if (arguments.length == 0) {
            return;
        }
        else {
            if (point) {
                if (point instanceof esri.geometry.Point) {
                    targetMap.centerAt(point);
                }
            }
        }
    }

    ///<summary>定位某几何</summary>
    ///<param name="geo" type="Geometry">地图某几何</param>
    ///<param name="tolerance" type="Number">容差</param>
    ///<returns>没有返回值</returns>
    this.zoomToGeometry = function(geo, tolerance) {
        if (arguments.length == 0) {
            return;
        }
        else {
            if (geo) {
                if (arguments.length == 1) {
                    tolerance = 3000;
                }
                var targetExtent;
                if (geo instanceof esri.geometry.Point) {
                    targetExtent = new esri.geometry.Extent(geo.x - tolerance, geo.y - tolerance, geo.x + tolerance, geo.y + tolerance, targetMap.spatialReference);
                }
                else {
                    var extent = geo.getExtent();
                    targetExtent = extent.update(extent.xmin - tolerance, extent.ymin - tolerance, extent.xmax + tolerance, extent.ymax + tolerance, targetMap.spatialReference);
                }
                
                targetMap.graphics.clear();
                targetMap.setExtent(targetExtent);
            }
        }
    }

    ///<summary>高亮某几何</summary>
    ///<param name="geo" type="Geometry">高亮某几何</param>
    ///<returns>没有返回值</returns>
    this.highLightOnGeometry = function(geo,sym) {
        if (arguments.length == 0) {
            return;
        }
        else {
            if (geo) {
                var graphic = new esri.Graphic(geo);
                if (geo instanceof esri.geometry.Point) {
                    var sms = new esri.symbol.SimpleMarkerSymbol().setStyle(esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE).setColor(new dojo.Color([255, 0, 0, 0.5]));
                    sym = sym?sym:sms;
                    graphic.setSymbol(sym);
                }
                else if (geo instanceof esri.geometry.Polyline) {
                    var sls = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0, 0.5]), 5);
                    sym = sym?sym:sls;
                    graphic.setSymbol(sym);
                }
                else if (geo instanceof esri.geometry.Polygon) {
                    var sfs = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0, 0.5]), 5), new dojo.Color([255, 255, 0, 0.25]));
                    sym = sym?sym:sfs;
                    graphic.setSymbol(sym);
                }
                targetMap.graphics.add(graphic);
            }
        }
    }

    ///<summary>打开提示窗口到几何</summary>
    ///<param name="geo" type="Geometry">某几何</param>
    ///<param name="title" type="String">html或者String</param>
    ///<param name="content" type="Object">html或者DOM元素</param>
    ///<returns>没有返回值</returns>
    this.showInfoWindowOnGeometry = function(geo, title, content) {
        if (arguments.length == 0) {
            return;
        }
        else {
            if (geo) {
                var anchorPoint;
                if (geo instanceof esri.geometry.Point) {
                    anchorPoint = geo;
                }
                else {
                    var extent = geo.getExtent();
                    anchorPoint = extent.getCenter();
                }

                targetMap.infoWindow.setTitle(title);
                targetMap.infoWindow.setContent(content);
                targetMap.infoWindow.show(anchorPoint);
            }
        }
    }

    ///<summary>关闭提示窗口</summary>
    ///<returns>没有返回值</returns>
    this.hideInfoWindow = function() {
        targetMap.infoWindow.hide();
    }

    ///<summary>清除</summary>
    ///<returns>没有返回值</returns>
    this.clear = function() {
        this.removeGraphicLayer();
        targetMap.graphics.clear();
    }
}