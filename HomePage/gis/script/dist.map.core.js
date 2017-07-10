(function(d) {

    d.map = {
        config: null,
        lm: null,
        mapContainerId: null,
        layerContainerId: null,
        configLoadFlag: 0,
        configCount: 0,

        load: function(configUrl, callback) {
            $.ajax({
                url: configUrl,
                dataType: "json",
                contentType: "application/json",
                success: function(d) {
                    dist.map.config = d;
                    callback(d);
                },
                error: function(e, s, a) {
                    console.error('获取图层配置失败：' + s);
                }
            });
        },
        init: function(targetElement, layerElementId) {
            this.mapContainerId = targetElement;
            this.layerContainerId = layerElementId;
            //初始化地图
            var mapConfig = this.config.maps[0];
            this.configCount = mapConfig.basemap.length + mapConfig.imagemap.length + mapConfig.dmap.length + mapConfig.theme.length;

            for (var i = 0; i < this.config.maps.length; i++) {
                var theSingleMap = this.config.maps[i];
                if (!theSingleMap.basemap)
                    theSingleMap.basemap = {};
                if (!theSingleMap.imagemap)
                    theSingleMap.imagemap = {};
                if (!theSingleMap.dmap)
                    theSingleMap.dmap = {};
                if (!theSingleMap.theme)
                    theSingleMap.theme = {};
                theSingleMap.theme.layers = new Array();
                this.loadServiceInfo(theSingleMap.basemap);
                this.loadServiceInfo(theSingleMap.imagemap);
                this.loadServiceInfo(theSingleMap.dmap);
                this.loadServiceInfo(theSingleMap.theme);
            }

            dist.desktop.gisMapHanlder.initHandler();
        },
        loadServiceInfo: function (mapservices) {
            var $s = this;
            for (var i = 0; i < mapservices.length; i++) {
                var mapservice = mapservices[i];
                if (!mapservice.url) {
                    this.configLoadFlag++;
                    continue;
                }
                this.loadServerItemInfo(mapservice);
            }
        },
        loadServerItemInfo: function (mapservice) {
            var $s = this;
            if (mapservice.type != "wmts") {
                var url = mapservice.url;
                if (mapservice.proxyUrl) {
                    url = mapservice.proxyUrl + "?" + url;
                    esriConfig.defaults.io.proxyUrl = mapservice.proxyUrl;
                    esriConfig.defaults.io.alwaysUseProxy = true;
                }
                $.ajax({
                    url: url + '?f=json',
                    dataType: 'JSONP',
                    contentType: "application/json",
                    success: function (d) {
                        for (var p in d)
                            mapservice[p] = d[p];
                        //请求图例服务
                        $s.getLayerDeatils(mapservice);
                    },
                    error: function (e, s, a) {
                        console.error('没有成功获取地图服务属性：' + url + ',' + s);
                    }
                });
            } else {
                //请求图例服务
                $s.getLayerDeatils(mapservice);
            }
        },
        //获取图层服务
        getLayerDeatils: function (mapservice) {
            var $s = this;
            if (mapservice.type != "wmts") {
                var url = mapservice.url;
                if (mapservice.proxyUrl) {
                    url = mapservice.proxyUrl + "?" + url;
                    esriConfig.defaults.io.proxyUrl = mapservice.proxyUrl;
                    esriConfig.defaults.io.alwaysUseProxy = true;
                }
                //请求当前服务的图层
                $.ajax({
                    url: url + '/layers?f=json',
                    dataType: 'JSONP',
                    contentType: "application/json",
                    success: function (d) {
                        mapservice.layerDetails = d.layers;
                        $s.onServiceConfigLoaded();
                    },
                    error: function (e, s, a) {
                        console.error('没有成功获取地图服务图层详情：' + url + ',' + s);
                    }
                });
            } else {
                $s.onServiceConfigLoaded();
            }
        },
        onServiceConfigLoaded: function() {
            this.configLoadFlag++;
            if (this.configLoadFlag == this.configCount) {
                this.mapConfigLoaded();
            }
        },
        mapConfigLoaded: function() {
            dist.desktop.mapInitialized();
        },
        cloneMap: function(i) {
            var m = this.config.maps[i];
            var newObj = this.clone(m);
            var baseMaps = [];
            var themes = [];
            for (var j = 0; j < newObj.basemap.length; j++) {
                var baseMapSP = new this.servicePackage(newObj.basemap[j]);
                baseMaps.push(baseMapSP);
            }
            newObj.basemap = baseMaps;
            for (var k = 0; k < newObj.theme.length; k++) {
                var themeSP = new this.servicePackage(newObj.theme[k]);
                themes.push(themeSP);
            }
            newObj.theme = themes;
            return newObj;
        },
        getCurrentMap: function() {
            return this.config.maps[this.config.mapIndex];
        },
        updateHandler: function(esrimap) {
            this.measureHandler.unDraw();
            this.drawHandler.unDraw();

            this.measureHandler.setMap(esrimap);
            this.drawHandler.setMap(esrimap);
        },
        clone: function(Obj) {
            var buf;
            if (Obj instanceof Array) {
                buf = [];
                var i = Obj.length;
                while (i--) {
                    buf[i] = this.clone(Obj[i]);
                }
                return buf;
            } else if (Obj instanceof Object) {
                buf = {};
                for (var k in Obj) {
                    buf[k] = this.clone(Obj[k]);
                }
                return buf;
            } else {
                return Obj;
            }
        },
        mapHanlderInitialized: false,
        initGisMapHanlder: function() {

            if (this.mapHanlderInitialized)
                return;
            this.mapHanlderInitialized = true;

            //跳出arcgis回调
            setTimeout(function() {
                window.dist.desktop.gisMapHanlder.initMapHanlder();
            }, 100);
        }
    };


    d.map.servicePackage = function(theService) {

        this.findLayer = function(layerId) {
            for (var i = 0; i < this.layers.length; i++) {
                if (this.layers[i].id == layerId)
                    return this.layers[i];
            }
            return null;
        }

        this.getChildLayers = function(parentLayerId) {
            var rs = new Array();
            for (var i = 0; i < this.layers.length; i++) {
                var theLay = this.layers[i];
                if (theLay.parentLayerId == parentLayerId)
                    rs.push(theLay);
            }
            return rs;
        }

        for (var p in theService) {
            this[p] = theService[p];
        }
    }
})(dist);