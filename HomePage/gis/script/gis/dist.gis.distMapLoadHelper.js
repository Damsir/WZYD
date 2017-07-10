(function(distmap) {
    //配置数据加载完成后，进行maps的地图加载工作
    distmap.distMapLoadHelper = function(mapCfg, mapScreen) {
        var helper = this;
        mapCfg.loader = this;
        mapCfg.screen = mapScreen;
        mapCfg.syncingExtent = true;
        this.esrimap = null;
        this.cfg = mapCfg;
        this.screen = mapScreen;
        this.createMap = function() {
            var mapDiv = document.createElement('DIV');
            mapDiv.id = 'mapDiv_' + this.cfg.name;
            mapDiv.className = 'map';
            $('#map-container').append(mapDiv);

            $(mapDiv).bind('touchend click', function() {
                dist.desktop.setCurrentScreen(mapScreen);
            });

            this.cfg.ele = mapDiv;

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

            this.initWMTSLayer = function() {
                dojo.declare("WMTS_TDT_Layer", esri.layers.TiledMapServiceLayer, {
                    constructor: function(layerUrl, minLevel, maxLevel, visible) {
                        this.spatialReference = new esri.SpatialReference({
                            wkid: 4326
                        });
                        this.visible = true;
                        if (visible == "false") {
                            this.visible = false;
                        }
                        this.layerUrl = layerUrl;
                        this.minLevel = minLevel;
                        this.maxLevel = maxLevel;
                        this.initialExtent = new esri.geometry.Extent(120.68206799021897, 27.9882663190575, 120.71137917033371, 28.00257858636097, this.spatialReference);
                        this.fullExtent = new esri.geometry.Extent(-180, -90, 180, 90, this.spatialReference);
                        this.tileInfo = new esri.layers.TileInfo({
                            "dpi": "96",
                            "format": "image/png",
                            "compressionQuality": 0,
                            "spatialReference": {
                                "wkid": "4326"
                            },
                            "rows": 256,
                            "cols": 256,
                            "origin": {
                                "x": -180,
                                "y": 90
                            },
                            "lods": mapLods
                        });
                        this.loaded = true;
                        this.onLoad(this);
                    },
                    getTileUrl: function(level, row, col) {
                        var url = "";
                        var paras = { level: level, row: row, col: col };
                        var keys = ["level", "row", "col"];
                        if (level <= this.maxLevel && level >= this.minLevel) {
                            url = this.layerUrl + "&TILEMATRIX={level}&TILEROW={row}&TILECOL={col}";
                            url = url.replace("{level}", paras["level"]);
                            url = url.replace("{row}", paras["row"]);
                            url = url.replace("{col}", paras["col"]);
                        }
                        return url;
                    }
                });
            }

            //地图的辅助对象
            var distMapHelpers = null;
            var distMapNavigationHelpers = null;
            var distTasksHelpers = [];
            var distLayerHelpers = [];
            var distGeolocationHelpers = [];
            var defaultExtent;
            var distTasksHelper = new DistTasksHelper(); ;
            //地图对象
            //var mapObjs = distmap.config.maps;

            var zfBaseMaps = [];
            var themeServiceLayers = [];
            esriConfig.defaults.io.proxyUrl = window.parent.dist.client.getRootPath() + "gis/proxy/gisproxy.ashx";

            dojo.addOnLoad(function() {

                var map = new esri.Map('mapDiv_' + helper.cfg.name, { logo: false, slider: true }); //{extent:defaultExtent}
                helper.esrimap = map;
                helper.cfg.mapId = map.id;
                helper.cfg.esrimap = map;
                distMapHelpers = new DistMapHelper(map);
                distMapNavigationHelpers = new DistMapNavigationHelper(map);
                dojo.connect(map, 'onLoad', function(theMap) {
                    var scalebar = new esri.dijit.Scalebar({
                        map: theMap,
                        scalebarUnit: 'metric'
                    });
                    //var mapIdx = distmap.config.mapIndex;
                    helper.loadThemeMap(map);
                    distTasksHelper.identifyHandler(map);
                    dist.desktop.mapLoaded();
                });

                dojo.connect(map, "onExtentChange", function(extent) {
                    if (!helper.cfg.syncingExtent) {
                        dist.desktop.mapExtentChanged(helper.cfg, extent);
                    } else
                        helper.cfg.syncingExtent = false;
                });

                dojo.connect(map, 'onZoomEnd', function(extent) {
                    return;
                    var mapIdx = distmap.config.mapIndex;

                    var themeLayers = helper.cfg.theme.layers;
                    var themeUrl = helper.cfg.theme.url;

                    if (themeLayers && themeLayers.length > 0) {
                        for (var j = themeLayers.length - 1; j >= 0; j--) {
                            var subLayerIds = themeLayers[j].subLayerIds;
                            if (subLayerIds && subLayerIds.length > 0) {
                                //no code
                            }
                            else {
                                var featurelayer = this.getLayer('themeFeatureLayer' + themeLayers[j].id);
                                featurelayer.setMaxAllowableOffset(helper.calcOffset(this));
                            }
                        }
                    }
                });

                dojo.connect(map, 'onLayerAdd', function(lay) {
                    helper.screen.onLayerAdded(lay);
                });

                helper.loadBaseMap(map);

                //dojo.connect(map, 'onLayerAddResult', function(lay,error) {
                //    helper.screen.onLayerAdded(lay);
                //});
            })
        };

        this.loadBaseMap = function(map) {
            //加载电子地图服务
            var basemap = helper.cfg.basemap;
            this.loadMap(map, basemap, "basemap");
            //加载影像地图服务
            var imgmap = helper.cfg.imgmap;
            this.loadMap(map, imgmap, "imgmap");
            //加载2.维地图服务
            var dmap = helper.cfg.dmap;
            this.loadMap(map, dmap, "dmap");
        }

        this.loadMap = function(map, baseMapInfo, layerType) {
            if (baseMapInfo) {
                for (var i = 0; i < baseMapInfo.length; i++) {
                    if (baseMapInfo[i]) {
                        var layer = {};
                        layer.id = helper.cfg.mapId;

                        layer.url = baseMapInfo[i].url;

                        layer.type = baseMapInfo[i].layerType;

                        if (layer.type) {
                            layer.name = baseMapInfo[i].name;

                            layer.minLevel = baseMapInfo[i].minLevel;

                            layer.maxLevel = baseMapInfo[i].maxLevel;

                            layer.visible = baseMapInfo[i].visible;

                        }

                        layer.alpha = 1;
                        if (!layer.visible)
                            layer.visible = true;
                        var layerService = helper.addLayerByLayerData(layer, map);
                        if (layerType == "basemap") {
                            dist.desktop.baseMapLayers.push(layerService);
                        }
                        else if (layerType == "imgmap") {
                            dist.desktop.imgMapLayers.push(layerService);
                        }
                        else if (layerType == "dmap") {
                            dist.desktop.dMapLayers.push(layerService);
                        }
                    }
                }
            }

        }

        this.loadThemeMap = function(map) {
            var themeLayers = helper.cfg.theme.layers;
            var themeMap = helper.cfg.theme;
            if (themeMap) {
                for (var i = 0; i < themeMap.length; i++) {
                    var themeUrl = themeMap[i].url;
                    //加载图层配置中的FeatureLayer等
                    if (themeLayers && themeLayers.length > 0) {
                        for (var j = themeLayers.length - 1; j >= 0; j--) {

                            var subLayerIds = themeLayers[j].subLayerIds;
                            themeLayers[j].visible = themeLayers[j].defaultVisibility;
                            themeLayers[j].alpha = 1;
                            if (subLayerIds && subLayerIds.length > 0) {
                                //no code
                            }
                            else {
                                var featureLayerData = {};
                                featureLayerData.url = themeUrl;
                                featureLayerData.id = 'layer' + themeLayers[j].id;
                                featureLayerData.type = helper.cfg.theme.layerType;
                                featureLayerData.visible = themeLayers[j].visible;
                                featureLayerData.alpha = themeLayers[j].alpha;
                                var fl = helper.addLayerByLayerData(featureLayerData, this.esrimap);
                                //if (featureLayerData.visible)
                                //    fl.setVisibleLayers([themeLayers[j].id]);
                                //else
                                fl.setVisibleLayers([themeLayers[j].id]);
                            }
                        }
                    }
                }
            }
        }

        this.reloadMap = function(mf) {
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

        this.calcOffset = function(map) {
            return (map.extent.getWidth() / map.width) * 10;
        };

        this.addLayerByLayerData = function(layerData, map) {
            if (!layerData.url || layerData.url == '') return;
            var layer = null;

            switch (layerData.type) {
                case "Tile":
                    layer = new esri.layers.ArcGISTiledMapServiceLayer(layerData.url, { id: layerData.id, opacity: layerData.alpha, visible: layerData.visible });
                    break;
                case "FeatureLayer":
                    layer = new esri.layers.FeatureLayer(layerData.url, { id: layerData.id, opacity: layerData.alpha, visible: layerData.visible, outFields: ['*'], maxAllowableOffset: this.calcOffset(map) }); //,maxAllowableOffset: calcOffset(map)
                    break;
                case "Dynamic":
                    layer = new esri.layers.ArcGISDynamicMapServiceLayer(layerData.url, { id: layerData.id, opacity: layerData.alpha, visible: layerData.visible });

                    break;
                case "WMTS":
                    var initlayer = this.initWMTSLayer();
                    layer = new WMTS_TDT_Layer(layerData.url, layerData.minLevel, layerData.maxLevel, layerData.visible);
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

