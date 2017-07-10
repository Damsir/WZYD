dojo.require("esri.map");
dojo.require("esri.graphic");
dojo.require("esri.symbol");
dojo.require("esri.toolbars.navigation");
dojo.require("esri.tasks.identify");
dojo.require("esri.layers.FeatureLayer");
dojo.require("esri.layers.wms");
dojo.require("esri.dijit.Scalebar");
dojo.require("esri.dijit.Measurement");
dojo.require("esri.dijit.PopupMobile");
dojo.require("esri.toolbars.draw");
dojo.require("esri.tasks.geometry");
dojo.require("esri.tasks.query");

//地图的辅助对象
var distMapHelpers = [];
var distMapNavigationHelpers = [];
var distTasksHelpers = [];
var distLayerHelpers = [];
var distGeolocationHelpers = [];
var defaultExtent;

//地图对象
var maps = [];

var zfBaseMaps = [];
var themeServiceLayers = [];
var sms;
var sls;
var sfs;

function mapsInit() {
    sms = new esri.symbol.SimpleMarkerSymbol().setStyle(esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE).setColor(new dojo.Color([255, 0, 0, 0.5]));
    sls = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SHORTDASH, new dojo.Color([0, 0, 255, 0.5]), 8);
    sfs = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0, 0.7]), 5), new dojo.Color([151, 219, 20, .7]));
    esriConfig.defaults.io.proxyUrl = window.parent.dist.client.getRootPath() + "gis/proxy/proxy.ashx";

    document.body.addEventListener('touchstart', function() {
        if (window.parent && window.parent.maptouchstart)
            window.parent.maptouchstart();
    });


    defaultExtent = new esri.geometry.Extent({ xmin: defaultExtentObj.xmin, ymin: defaultExtentObj.ymin, xmax: defaultExtentObj.xmax, ymax: defaultExtentObj.ymax, spatialReference: { wkid: 102113} });

    if (baseMapConfigData && baseMapConfigData.length > 0) {
        for (var i = 0; i < baseMapConfigData.length; i++) {
            var map = new esri.Map("mapDiv" + i, { logo: false }); //{extent:defaultExtent} 
            baseMapConfigData[i].mapId = map.id;
            maps[i] = map;
            distMapHelpers[i] = new DistMapHelper(map);
            distMapNavigationHelpers[i] = new DistMapNavigationHelper(map);

            //加载专题图，但不添加到地图
            var themeLayers = baseMapConfigData[i].themeLayers;
            var themeServices = [];
            if (themeLayers && themeLayers.length > 0) {
                for (var j = 0; j < themeLayers.length; j++) {
                    themeServices[j] = newLayerByLayerData(themeLayers[j]);
                }
            }
            themeServiceLayers[i] = themeServices;

            //加载地图的背景地图服务
            var baseLayers = baseMapConfigData[i].baseLayers;
            if (baseLayers && baseLayers.length > 0) {
                for (var j = baseLayers.length - 1; j >= 0; j--) {
                    addLayerByLayerData(baseLayers[j], map);
                }
            }

            setLayerList1ByConfigData(); //加载图层管理列表

            dojo.connect(map, 'onLoad', function(theMap) {
                var scalebar = new esri.dijit.Scalebar({
                    map: theMap,
                    scalebarUnit: 'metric'
                });

                var mapIdx;
                var themeLayers = null;
                for (var k = 0; k < baseMapConfigData.length; k++) {
                    if (baseMapConfigData[k].mapId == theMap.id) {
                        themeLayers = baseMapConfigData[k].themeLayers;
                        mapIdx = k;
                        break;
                    }
                }

                updateThemeLayerInfos(themeLayers, themeServiceLayers[mapIdx]); //在专题地图服务加载后，更新图层配置中的layerInfos参数

                //加载图层配置中的FeatureLayer等
                if (themeLayers && themeLayers.length > 0) {
                    for (var j = themeLayers.length - 1; j >= 0; j--) {
                        addLayersByConfigData(themeLayers[j], theMap);
                    }
                }

            });

            dojo.connect(map, "onExtentChange", onExtentChange);
            dojo.connect(map, 'onZoomEnd', function(extent) {
                var mapIdx = getMapIndex(this.id);
                var themeLayers = baseMapConfigData[mapIdx].themeLayers;
                if (themeLayers && themeLayers.length > 0) {
                    for (var j = themeLayers.length - 1; j >= 0; j--) {
                        var featurelayers = themeLayers[j].featurelayers;
                        if (featurelayers && featurelayers.length > 0) {
                            for (var i = 0; i < featurelayers.length; i++) {
                                featurelayers[i].setMaxAllowableOffset(calcOffset(this));
                            }
                        }
                    }
                }
            });
        }

    }

}

function onExtentChange(extent, delta, outLevelChange, outLod) {
}

function mapGraphicsClickHandler(evt) {
    var graphic = evt.graphic;
    if (graphic.geometry.type == 'point') {
    }
    else if (graphic.geometry.type == 'polygon') {
    }

}