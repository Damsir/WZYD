(function (distmap) {
    //配置数据加载完成后，进行maps的地图加载工作
    distmap.mapLoadHelper = function (mapCfg, mapScreen) {
        var helper = this;
        mapCfg.loader = this;
        mapCfg.screen = mapScreen;
        mapCfg.syncingExtent = true;
        this.esrimap = null;
        this.cfg = mapCfg;
        this.screen = mapScreen;
        this.distTasksHelper = new dist.gis.tasksHelper();

        //创建地图
        this.createMap = function () {
            var mapDiv = document.getElementById('mapDiv');

            this.cfg.ele = mapDiv;

            var map = new esri.Map('mapDiv', { logo: false});
            helper.esrimap = map;
            helper.cfg.mapId = map.id;
            helper.cfg.esrimap = map;

            dist.desktop.currentScreen = mapScreen;
            dist.desktop.distMapHelper = new dist.gis.mapHelper(map);

            ////resize the info window
            //map.infoWindow.resize(250, 300);
            //var infoWindow = map.infoWindow.domNode;
            //var actionList = $("div.actionList",infoWindow)[0];
            //
            ////创建详情按钮
            //var detailA = document.createElement('a');
            //detailA.title = "详情";
            //detailA.className = "action locate";
            //detailA.href = "javascript:void(0);";
            //var detailSpan = document.createElement('span');
            //detailSpan.innerText = "详情";
            //detailA.appendChild(detailSpan);
            //actionList.appendChild(detailA);
            //
            //detailA.onclick = function () {
            //    var index = map.infoWindow.selectedIndex;
            //    var feature = map.infoWindow.features[index];
            //
            //    console.log(feature.geometry);
            //
            //}

            ////绑定图层加载完毕
            //dojo.connect(map, 'onLoad', function (theMap) {
            //    //var scalebar = new esri.dijit.Scalebar({
            //    //   map: map,
            //    //   scalebarUnit: 'metric'
            //    //});
            //
            //    var zoomBtn = document.getElementById("mapDiv_zoom_slider");
            //    zoomBtn.className = "esriSimpleSlider esriSimpleSliderVertical";
            //    //zoomBtn.style.top = "50px";
            //    zoomBtn.style.right = "10px";
            //    zoomBtn.style.bottom = "20px";
            //
            //    dist.desktop.mapLoaded();
            //    helper.loadThemeMap(theMap);
            //    helper.distTasksHelper.identifyHandler(theMap);
            //
            //    //设置默认地图范围
            //    var extentConfig = dist.map.config.extent;
            //    if (extentConfig.xmin && extentConfig.ymin && extentConfig.xmax && extentConfig.ymax) {
            //        dist.desktop.defaultExtent = new esri.geometry.Extent(extentConfig.xmin, extentConfig.ymin, extentConfig.xmax, extentConfig.ymax, map.spatialReference);
            //        theMap.setExtent(dist.desktop.defaultExtent);
            //    }
            //});

            //加载底图服务
            helper.loadBaseMap(map);

            ////绑定图层范围变化
            //dojo.connect(map, "onExtentChange", function (extent) {
            //    if (!helper.cfg.syncingExtent) {
            //        dist.desktop.mapExtentChanged(helper.cfg, extent);
            //    } else
            //        helper.cfg.syncingExtent = false;
            //});

            //绑定图层加载，针对专题图层
            dojo.connect(map, 'onLayerAdd', function (lay) {
                helper.screen.onLayerAdded(lay);
            });

        };


        this.mapOnLoad = function (map) {
            var zoomBtn = document.getElementById("mapDiv_zoom_slider");
            zoomBtn.className = "esriSimpleSlider esriSimpleSliderVertical";
            //zoomBtn.style.top = "50px";
            zoomBtn.style.right = "10px";
            zoomBtn.style.bottom = "20px";

            dist.desktop.mapLoaded();
            helper.loadThemeMap(map);
            helper.distTasksHelper.identifyHandler(map);

            //设置默认地图范围
            var extentConfig = dist.map.config.extent;
            if (extentConfig.xmin && extentConfig.ymin && extentConfig.xmax && extentConfig.ymax) {
                dist.desktop.defaultExtent = new esri.geometry.Extent(extentConfig.xmin, extentConfig.ymin, extentConfig.xmax, extentConfig.ymax, map.spatialReference);
                theMap.setExtent(dist.desktop.defaultExtent);
            }
        };


        this.loadBaseMap = function (map) {
            //加载地图的电子底图服务
            var basemaps = helper.cfg.basemap;
            for (var i = 0; i < basemaps.length; i++) {
                var basemap = basemaps[i];
                if (basemap) {
                    var layer = {};
                    layer.id = basemap.name;
                    layer.url = basemap.url;
                    layer.type = basemap.type;
                    layer.alpha = 1;
                    layer.visible = basemap.visible;
                    layer.minLevel = basemap.minLevel;
                    layer.maxLevel = basemap.maxLevel;
                    var basemapObj = helper.addLayerByLayerData(layer, map);
                    if (basemapObj != null) {
                        dist.desktop.baseMapObjs.push(basemapObj);
                    }
                }
            }
            //加载地图的影像地图服务
            var imagemaps = helper.cfg.imagemap;
            for (var i = 0; i < imagemaps.length; i++) {
                var imagemap = imagemaps[i];
                if (imagemap) {
                    var layer = {};
                    layer.id = imagemap.name;
                    layer.url = imagemap.url;
                    layer.type = imagemap.type;
                    layer.alpha = 1;
                    layer.visible = imagemap.visible;
                    layer.minLevel = imagemap.minLevel;
                    layer.maxLevel = imagemap.maxLevel;
                    var imagemapObj = helper.addLayerByLayerData(layer, map);
                    if (imagemapObj != null) {
                        dist.desktop.imageMapObjs.push(imagemapObj);
                    }
                }
            }
            //加载2.5地图的影像地图服务
            var dmaps = helper.cfg.dmap;
            for (var i = 0; i < dmaps.length; i++) {
                var dmap = dmaps[i];
                if (dmap) {
                    var layer = {};
                    layer.id = dmap.name;
                    layer.url = dmap.url;
                    layer.type = dmap.type;
                    layer.alpha = 1;
                    layer.visible = dmap.visible;
                    layer.minLevel = dmap.minLevel;
                    layer.maxLevel = dmap.maxLevel;
                    var dmapObj = helper.addLayerByLayerData(layer, map);
                    if (dmapObj != null) {
                        dist.desktop.dMapObjs.push(dmapObj);
                    }
                }
            }

            helper.mapOnLoad(map);
        }

        this.loadThemeMap = function (map) {
            var themes = helper.cfg.theme;
            for (var i = 0; i < themes.length; i++) {
                var themeObj = themes[i];
                var themeLayers = themeObj.layers;
                var themeUrl = themeObj.url;
                var defaultVisibleLayers = themeObj.defaultVisibleLayers;
                var featureLayerData = {};
                featureLayerData.url = themeUrl;
                featureLayerData.id = themeObj.name;
                featureLayerData.type = themeObj.type;
                featureLayerData.visible = themeObj.visible;
                featureLayerData.defaultVisibleLayers = defaultVisibleLayers;
                featureLayerData.alpha = 1;
                if(themeObj.opacity){
                    featureLayerData.alpha = themeObj.opacity;
                }
                themeObj.layerObj = helper.addLayerByLayerData(featureLayerData, map);
                if (themeObj.layerObj != null) {
                    dist.desktop.themeMapObjs.push(themeObj.layerObj);
                }
            }
        }

        this.reloadMap = function (mf) {
            this.esrimap.removeAllLayers();
            mf.ele = this.cfg.ele;
            mf.screen = this.cfg.screen;
            mf.syncingExtent = this.cfg.syncingExtent;
            mf.loader = this;
            mf.mapId = this.cfg.mapId;
            mf.esrimap = this.esrimap;
            this.screen.map = mf;
            this.cfg = mf;
            this.loadBaseMap(this.esrimap);
            this.loadThemeMap(this.esrimap);
        };

        this.calcOffset = function (map) {
            return (map.extent.getWidth() / map.width) * 10;
        };

        this.addLayerByLayerData = function (layerData, map) {
            if (!layerData.url || layerData.url == '') return null;
            var layer = null;
            var type = layerData.type.toLowerCase();
            switch (type) {
                case "tile":
                    layer = new esri.layers.ArcGISTiledMapServiceLayer(layerData.url, { id: layerData.id, opacity: layerData.alpha, visible: layerData.visible });
                    break;
                case "featurelayer":
                    layer = new esri.layers.FeatureLayer(layerData.url, { id: layerData.id, opacity: layerData.alpha, visible: layerData.visible, outFields: ['*'], maxAllowableOffset: this.calcOffset(map) });
                    break;
                case "dynamic":
                    var visibleLayers = [-1];
                    if(layerData.defaultVisibleLayers){
                        visibleLayers = layerData.defaultVisibleLayers;
                    }
                    layer = new esri.layers.ArcGISDynamicMapServiceLayer(layerData.url, { "id": layerData.id, "opacity": layerData.alpha, "visible": layerData.visible });
                    layer.setVisibleLayers(visibleLayers);
                    break;
                case "wmts":
                    var wmtsLayerInit = new initWMTSLayer();
                    layer = new WMTSLayer(layerData.url, layerData.minLevel, layerData.maxLevel);
                    layer.visible = layerData.visible;
                    layer.id = layerData.id;
                    break;
                default:
                    return null;
                    break;
            }

            map.addLayer(layer);
            return layer;
        };

    }

})(dist.map);