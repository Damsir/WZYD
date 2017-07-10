$(document).ready(function () {
    dist.desktop.init();
});

dist.desktop = {
    mapClickEvents: [],
    projectQueryParam: [],
    addressQueryParam: [],
    defaultExtent: null,

    init: function () {
        dojo.require("esri.map");
        dojo.require("esri.graphic");
        dojo.require("esri.symbol");
        dojo.require("esri.geometry.Circle");
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
        dojo.require("esri.tasks.find");
        dojo.require("dijit.layout.BorderContainer");
        dojo.require("dijit.layout.ContentPane");

        this.controlPanel.init();
        this.ctrl.init();
        dist.map.load('map.json?r=' + Math.random(), this.mapConfigLoaded);
        if (window.parent && window.parent.mapPageLoaded)
            window.parent.mapPageLoaded(window.location.href);
        if (document.body.addEventListener) {
            document.getElementById('map-control-panel').addEventListener("touchstart", function (e) {
                var tagName = '';
                if (e.srcElement)
                    tagName = e.srcElement.tagName;
                if (tagName == 'SELECT' || tagName == 'INPUT') {
                    return;
                }
                e.preventDefault();
                return false;
            });
        }
    },
    globle: {
        gisFunction: null,
        falseFunction: null
    },
    currentSequence: 0,
    nextSequence: function () {
        return ++this.currentSequence;
    },
    mapScreens: [],
    //电子地图图层对象
    baseMapObjs: [],
    //影像地图图层对象
    imageMapObjs: [],
    //2.5维地图图层对象
    dMapObjs:[],
    //专题图层对象
    themeMapObjs: [],
    //默认可切换影像
    isSwitchMap:true,
    currentScreen: null,
    //存放用于属性查询、测量、分析是要素高亮的GraphicLayer
    graphicLayerList: null,
    //地图辅助类
    distMapHelper: null,
    distLocate: null,
    configLoaded: false,
    showAttributes: false,
    distMapNavigationHelper: null,
    isShowToolMenu:false,
    mapConfigLoaded: function (data) {
        dist.map.init('mapDiv');
        if (!dist.map.config.iSearch)
            $('#btn-iSearch').hide();
        if (!dist.map.config.addressSearch)
            $('#searchContainer').hide();
        if (!dist.map.config.draw)
            $('#btnDraw').hide();
        if (!dist.map.config.measure)
            $('#btnMeasure').hide();
        if (!dist.map.config.about)
            $('#btn-about').hide();
        if (dist.map.config.projectSearch) {
            dist.desktop.projectQueryParam = dist.map.config.projectSearch;  //项目查询图层
        }
        if (dist.map.config.addressSearch) {
            dist.desktop.addressQueryParam = dist.map.config.addressSearch;  //项目查询图层
        }
    },
    registerMapClick: function (callback) {
        this.mapClickEvents.push(callback);
    },
    mapInitialized: function () {
        this.configLoaded = true;
        this.createDefaultScreen();
    },
    mapLoaded: function () {
        if (window.parent && window.parent.mapLoaded)
            window.parent.mapLoaded(window.location.href);
        dist.map.initGisMapHanlder();
        if (window.parent && window.parent.mapContainer) {
            window.parent.mapContainer.mapOpend(true);
        }

    },
    createDefaultScreen: function () {
        this.newScreen(dist.map.cloneMap(dist.map.config.defaultMap));
    },
    newScreen: function (cfg) {
        var s = new dist.desktop.screen(cfg, this.mapScreens.length);
        this.mapScreens.push(s);
        if (this.mapScreens.length == 1)
            this.currentScreen = s;
    },
    mapExtentChanged: function (mapCfg, extent) {
        for (var i = 0; i < this.mapScreens.length; i++) {
            var sc = this.mapScreens[i];
            if (sc == mapCfg)
                continue;
            sc.map.syncingExtent = true;
            sc.map.esrimap.setExtent(extent, false);
        }
    },
    //显示属性
    onMapClick: function (attribute, geometry) {
        var graphicHelper = new dist.gis.graphicAttributeWidgetHelper(attribute);
        var ul = document.getElementById('graphicAttributeUl');
        graphicHelper.setAttributeList(ul);
        dist.desktop.controlPanel.show('graphicAttributeContainer');
    },
    //审批项目打开后定位到审批红线
    locateProject: function (name, key) {
        distLocate = new dist.gis.locateProject(name, key);
        distLocate.locate();
    },
    zoomFull: function () {
        var esrimap = dist.desktop.currentScreen.map.esrimap;
        if (dist.desktop.defaultExtent) {
            esrimap.setExtent(dist.desktop.defaultExtent);
        } else {
            if (dist.desktop.distMapNavigationHelper == null) {
                dist.desktop.distMapNavigationHelper = new esri.toolbars.Navigation(esrimap);
            }
            dist.desktop.distMapNavigationHelper.zoomToFullExtent();
        }
    }
}

dist.desktop.screen = function (mapCfg, i) {
    this.map = mapCfg;
    this.loader = new dist.map.mapLoadHelper(mapCfg, this);
    this.loader.createMap();
    this.index = i;
    this.lm = new dist.map.layerManager(this);
    this.setMap = function (map) {
        this.loader.reloadMap(map);
        this.lm.show();
        this.lm.updateSelector();
    };
    this.onLayerAdded = function (lay) {
        if (lay.id.indexOf('style') == 0) {
            this.lm.styleLayerAdded(lay);
        }
    };
    return this;
}

dist.desktop.controlPanel = {
    ele: null,
    nameEle: null,
    titleEle: null,
    currentNav: null,
    navHistory: [],
    current: '',
    show: function (name, toHistory) {
        var nowWidth = this.ele.width();
        var me = this;
        if (!toHistory && this.navHistory[this.navHistory.length - 1] != name)
            this.navHistory.push(name);
        var target = dist.$g(name);

        var toWidth = $(target).width();
        this.currentNav.style.display = 'none';

        var w1 = nowWidth - 20;
        if (nowWidth > toWidth)
            w1 = nowWidth + 20;
        this.current = name;
        
        me.ele.animate({ width: toWidth }, 200, function () {
            var t = target.getAttribute('dist-title');
            if (t && t != '')
                me.titleEle.show();
            else
                me.titleEle.hide();
            me.nameEle.innerText = t;
            me.currentNav = target;
            me.currentNav.style.display = '';
        });
        this.onShow(name);
    },
    init: function () {
        this.ele = $('#map-control-panel');
        this.nameEle = dist.$g('navName');
        this.titleEle = $('#panel-title');
        //this.currentNav = dist.$g('map-toolbar');
        this.currentNav = dist.$g('defaultHide');
        $('#btnCloseNav').touchlink().bind('touchend click', function () {
            dist.desktop.controlPanel.goback();
            if (document.getElementById('navName').innerHTML == '绘制') { dist.desktop.gisMapHanlder.drawHandler.deactiveDrawTool(); }  //取消绘制

        });
    },
    goback: function () {
        this.navHistory.pop();
        if (this.navHistory.length > 0) {
            var previousNav = this.navHistory[this.navHistory.length - 1];
            this.show(previousNav, true);
        } else {
            this.show('defaultHide');
        }
    },
    onShow: function (t) {
        if (t == 'drawContainer' || t == 'measureContainer') {
            dist.desktop.showAttributes = false;
            $('#btn-iSearch')[0].className = '';
        }
    }
}

dist.desktop.ctrl = {
    layerBox: null,
    init: function () {
        this.layerBox = document.getElementById('layerPanel');
        $('#btn-layers').touchlink().bind('touchend click', function () {
            dist.desktop.ctrl.showCurrentScreenLayer();
        });
        if (dist.isIphone()||dist.isIpad() || dist.isAndroid()) {
            iSearchBtn = $('#btn-iSearch').bind('touchend ', this.doiSearch);
        }
        else {
            iSearchBtn = $('#btn-iSearch').bind('click', this.doiSearch);
        }

        //初始化时，属性查询按钮不选中
        iSearchBtn[0].className = dist.desktop.showAttributes ? 'selectedSwitchBtnMap' : 'unSelectedSwitchBtnMap';

        this.resize();
        if (dist.isIphone() || dist.isIpad() || dist.isAndroid()) {
            new iScroll('graphicAttributeUl');
        } else {
            new vScroller('graphicAttributeUl');
        }
    },

    doiSearch: function () {
        if (dist.desktop.controlPanel.current == 'drawContainer' || dist.desktop.controlPanel.current == 'measureContainer')
            return;
        dist.desktop.showAttributes = !dist.desktop.showAttributes;
        this.className = dist.desktop.showAttributes ? 'selectedSwitchBtnMap' : 'unSelectedSwitchBtnMap';

        dist.desktop.gisMapHanlder.searchHandler.isAddressResult = false;
        //打开或关闭i查询，首先清空graphic
        dist.desktop.currentScreen.map.esrimap.graphics.clear();
        //清除i查询高亮要素
        dist.desktop.distMapHelper.removeGraphicLayer();
    },
    showCurrentScreenLayer: function () {
        var layerElements = dist.desktop.ctrl.layerBox.children;
        if (layerElements.length == 0)
            dist.desktop.ctrl.layerBox.appendChild(dist.desktop.currentScreen.lm.ele);
        else {
            var notFind = true;
            for (var i = 0; i < layerElements.length; i++) {
                var layEle = layerElements[i];
                if (dist.desktop.currentScreen.index == layEle.getAttribute('i')) {
                    layEle.style.display = 'block';
                    notFind = false;
                }
                else
                    layEle.style.display = 'none';
            }
            if (notFind)
                dist.desktop.ctrl.layerBox.appendChild(dist.desktop.currentScreen.lm.ele);
        }
        dist.desktop.controlPanel.show('layerPanel');
        dist.desktop.currentScreen.lm.show();
    },
    resize: function () {
        //$('#graphicAttributeScroller').css({ height: $(document.body).height() - 60 });
    }

}



//初始化GIS功能界面
dist.desktop.gisMapHanlder = {
    searchHandler: null,
    measureHandler: null,
    drawHandler: null,
    initMapHanlder: function () {

        //初始化搜索界面
        this.searchHandler = new dist.gis.searchWidgetHelper();
        this.searchHandler.setSearchDiv(document.getElementById('searchContainer'));

        //初始化测量界面
        this.measureHandler = new dist.gis.measureWidgetHelper();
        this.measureHandler.setMeasureDiv(document.getElementById('measureContainer'));

        //初始化绘制界面
        this.drawHandler = new dist.gis.drawWidgetHelper({ container: document.getElementById('drawContainer') });

        //存放用于属性查询、测量、分析是要素高亮的GraphicLayer
        graphicLayerList = new Array();
    },

    initHandler: function () {
        $('#btn-clearmap').touchlink().bind('touchend click', function () {
            if (dist.map.measureHandler)
                dist.map.measureHandler.unDraw();

            dist.desktop.currentScreen.map.esrimap.graphics.clear();
            dist.desktop.gisMapHanlder.searchHandler.isAddressResult = false;
            dist.desktop.currentScreen.map.esrimap.infoWindow.hide();

            var esrimap = dist.desktop.currentScreen.map.esrimap;
            var drawGraphicLayer = esrimap.getLayer('DIST_DRAW_LAYER');
            var meaRsDiv = document.getElementById('measureRsDiv');
            if (meaRsDiv)
                meaRsDiv.style.display = 'none';

            if (drawGraphicLayer)
                drawGraphicLayer.clear();

            //清除i查询高亮要素
            dist.desktop.distMapHelper.removeGraphicLayer();

            //清除加载的本地shapefile
            var sfLayers = dist.map.localShapefile;
            if (undefined != sfLayers) {
                for (var i = 0; i < sfLayers.length; i++) {
                    esrimap.removeLayer(sfLayers[i]);
                }
            }

            //清除点图层样式
            var pointLayerId = document.getElementById('pointSymbolContainer').getAttribute('layerId');
            if (pointLayerId) {
                var featurelayerPoint = dist.desktop.currentScreen.map.esrimap.getLayer(pointLayerId);
                var pointFeaturelayerHelper = new dist.gis.featureLayerHelper(featurelayerPoint);
                pointFeaturelayerHelper.clearSymbol();

                var colorValue = document.getElementById('pointStyle-color');
                colorValue.selectedIndex = 0;
            }
            //清除线图层样式
            var lineLayerId = document.getElementById('polylineSymbolContainer').getAttribute('layerId');
            if (lineLayerId) {
                var featurelayerLine = dist.desktop.currentScreen.map.esrimap.getLayer(lineLayerId);
                var lineFeaturelayerHelper = new dist.gis.featureLayerHelper(featurelayerLine);
                lineFeaturelayerHelper.clearSymbol();

                var colorValue = document.getElementById('polyLineStyle-color');
                colorValue.selectedIndex = 0;
            }

            //清除面图层样式
            var polygonLayerId = document.getElementById('polygonSymbolContainer').getAttribute('layerId');
            if (polygonLayerId) {
                var featurelayerPolygon = dist.desktop.currentScreen.map.esrimap.getLayer(polygonLayerId);
                var polygonFeaturelayerHelper = new dist.gis.featureLayerHelper(featurelayerPolygon);
                polygonFeaturelayerHelper.clearSymbol();

                var colorValue = document.getElementById('polygonStyle-color');
                colorValue.selectedIndex = 0;

                var bwValue = document.getElementById('polygonStyle-borderWidth');
                bwValue.selectedIndex = 0;

                var bcValue = document.getElementById('polygonStyle-borderColor');
                bcValue.selectedIndex = 0;
            }
        });

        //底图切换
        $('#switchmap').touchlink().bind('touchend click', function () {
            //切换到影像
            if (dist.desktop.isSwitchMap) {
                //关闭电子地图
                for (var i = 0; i < dist.desktop.baseMapObjs.length; i++) {
                    var baseMapLayer = dist.desktop.baseMapObjs[i];
                    baseMapLayer.hide();
                }
                //打开影像地图
                for (var i = 0; i < dist.desktop.imageMapObjs.length; i++) {
                    var imageMapLayer = dist.desktop.imageMapObjs[i];
                    imageMapLayer.show();
                }
                $('#switchmap')[0].style.backgroundImage = "url(images/baseMap.png)";
                //设置查询标识
                dist.desktop.isSwitchMap = false;
            }
            //切换到电子地图
            else {
                //显示电子地图
                for (var i = 0; i < dist.desktop.baseMapObjs.length; i++) {
                    var baseMapLayer = dist.desktop.baseMapObjs[i];
                    baseMapLayer.show();
                }
                //关闭影像地图
                for (var i = 0; i < dist.desktop.imageMapObjs.length; i++) {
                    var imageMapLayer = dist.desktop.imageMapObjs[i];
                    imageMapLayer.hide();
                }
                $('#switchmap')[0].style.backgroundImage = "url(images/imageMap.png)";
                //设置查询标识
                dist.desktop.isSwitchMap = true;
            }
        });
        //电子底图
        $('#baseMapBtn').touchlink().bind('touchend click', function () {
            //显示电子地图
            for (var i = 0; i < dist.desktop.baseMapObjs.length; i++) {
                var baseMapLayer = dist.desktop.baseMapObjs[i];
                baseMapLayer.show();
            }
            //关闭影像地图
            for (var i = 0; i < dist.desktop.imageMapObjs.length; i++) {
                var imageMapLayer = dist.desktop.imageMapObjs[i];
                imageMapLayer.hide();
            }
            //关闭2.5维地图
            for (var i = 0; i < dist.desktop.dMapObjs.length; i++) {
                var dMapLayer = dist.desktop.dMapObjs[i];
                dMapLayer.hide();
            }

            $('#baseMapBtn').removeClass("unSelectedSwitchBtnMap");
            $('#baseMapBtn').addClass("selectedSwitchBtnMap");
            $('#imgMapBtn').removeClass("selectedSwitchBtnMap");
            $('#imgMapBtn').addClass("unSelectedSwitchBtnMap");
            $('#dMapBtn').removeClass("selectedSwitchBtnMap");
            $('#dMapBtn').addClass("unSelectedSwitchBtnMap");

        });
        //电子影像
        $('#imgMapBtn').touchlink().bind('touchend click', function () {

            //关闭电子地图
            for (var i = 0; i < dist.desktop.baseMapObjs.length; i++) {
                var baseMapLayer = dist.desktop.baseMapObjs[i];
                baseMapLayer.hide();
            }
            //开启影像地图
            for (var i = 0; i < dist.desktop.imageMapObjs.length; i++) {
                var imageMapLayer = dist.desktop.imageMapObjs[i];
                imageMapLayer.show();
            }
            //关闭2.5维地图
            for (var i = 0; i < dist.desktop.dMapObjs.length; i++) {
                var dMapLayer = dist.desktop.dMapObjs[i];
                dMapLayer.hide();
            }

            $('#baseMapBtn').removeClass("selectedSwitchBtnMap");
            $('#baseMapBtn').addClass("unSelectedSwitchBtnMap");
            $('#imgMapBtn').removeClass("unSelectedSwitchBtnMap");
            $('#imgMapBtn').addClass("selectedSwitchBtnMap");
            $('#dMapBtn').removeClass("selectedSwitchBtnMap");
            $('#dMapBtn').addClass("unSelectedSwitchBtnMap");
        });
        //2.5维影像
        $('#dMapBtn').touchlink().bind('touchend click', function () {

            //关闭电子地图
            for (var i = 0; i < dist.desktop.baseMapObjs.length; i++) {
                var baseMapLayer = dist.desktop.baseMapObjs[i];
                baseMapLayer.hide();
            }
            //开启影像地图
            for (var i = 0; i < dist.desktop.imageMapObjs.length; i++) {
                var imageMapLayer = dist.desktop.imageMapObjs[i];
                imageMapLayer.hide();
            }
            //关闭2.5维地图
            for (var i = 0; i < dist.desktop.dMapObjs.length; i++) {
                var dMapLayer = dist.desktop.dMapObjs[i];
                dMapLayer.show();
            }

            $('#baseMapBtn').removeClass("selectedSwitchBtnMap");
            $('#baseMapBtn').addClass("unSelectedSwitchBtnMap");
            $('#imgMapBtn').removeClass("selectedSwitchBtnMap");
            $('#imgMapBtn').addClass("unSelectedSwitchBtnMap");
            $('#dMapBtn').removeClass("unSelectedSwitchBtnMap");
            $('#dMapBtn').addClass("selectedSwitchBtnMap");

        });

        $('#btn-zoomfull').touchlink().bind('touchend click', function () {
            dist.desktop.zoomFull();
        });

        $('#btnDraw').touchlink().bind('touchend click', function () {
            dist.desktop.gisMapHanlder.drawHandler.setMap(dist.desktop.currentScreen.map.esrimap);
            dist.desktop.controlPanel.show('drawContainer');
        });

        $('#addressFav').touchlink().bind('touchend click', function () {
            dist.desktop.controlPanel.show('addressCollectionDiv');
            $('#addressScrollBox').hide();
            $('#darwScrollBox').hide();
            $('#selFavList').hide();
            $('#favoriteList').show();

        });

        $('#btnMeasure').touchlink().bind('touchend click', function () {
            dist.desktop.gisMapHanlder.measureHandler.setMap(dist.desktop.currentScreen.map.esrimap);
            dist.desktop.controlPanel.show('measureContainer');
        });


        $('#pointSizeDown').touchlink().bind('touchend click', function () {
            var size = parseInt($('#pointSize').html());
            if (size <= 1) return;
            size--;
            $('#pointSize').html(size);

            var layerId = document.getElementById('pointSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setPointSymbolSize(size);

            featurelayer.setVisibility(true);
        });

        $('#pointSizeUp').touchlink().bind('touchend click', function () {
            var size = $('#pointSize').html();
            size++;
            $('#pointSize').html(size);

            var layerId = document.getElementById('pointSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setPointSymbolSize(size);

            featurelayer.setVisibility(true);
        });

        $('#polylineSizeDown').touchlink().bind('touchend click', function () {
            var size = parseInt($('#polylineSize').html());
            if (size <= 1) return;
            size--;
            $('#polylineSize').html(size);

            var aa = document.getElementById('polylineSymbolContainer');
            var layerId = document.getElementById('polylineSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setPolylineSymbolWidth(size);

            featurelayer.setVisibility(true);
        });



        $('#polylineSizeUp').touchlink().bind('touchend click', function () {
            var size = $('#polylineSize').html();
            size++;
            $('#polylineSize').html(size);

            var layerId = document.getElementById('polylineSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setPolylineSymbolWidth(size);

            featurelayer.setVisibility(true);
        });

        $('#polylineStyleSolid').touchlink().bind('touchend click', function () {
            var layerId = document.getElementById('polylineSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);

            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setSymbolStyle(esri.symbol.SimpleLineSymbol.STYLE_SOLID);
            featurelayer.setVisibility(true);
        });

        $('#polylineStyleDash').touchlink().bind('touchend click', function () {
            var layerId = document.getElementById('polylineSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setSymbolStyle(esri.symbol.SimpleLineSymbol.STYLE_DASH);
            featurelayer.setVisibility(true);
        });

        $('#polylineStyleRail').touchlink().bind('touchend click', function () {
            var layerId = document.getElementById('polylineSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setSymbolStyle(esri.symbol.SimpleLineSymbol.STYLE_SHORTDASHDOTDOT);
            featurelayer.setVisibility(true);
        });

        $('#resetPointSymbolBtn').touchlink().bind('touchend click', function () {
            var layerId = document.getElementById('pointSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setDefaultSymbol();

            featurelayer.setVisibility(true);
        });

        $('#resetPolylineSymbolBtn').touchlink().bind('touchend click', function () {
            var layerId = document.getElementById('polylineSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setDefaultSymbol();

            featurelayer.setVisibility(true);
        });

        $('#resetPolygonSymbolBtn').touchlink().bind('touchend click', function () {
            var layerId = document.getElementById('polygonSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setDefaultSymbol();
        });

        $('#polygonStyleSolid').touchlink().bind('touchend click', function () {
            var layerId = document.getElementById('polygonSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setSymbolStyle(esri.symbol.SimpleFillSymbol.STYLE_SOLID);
        });

        $('#polygonStyleDash').touchlink().bind('touchend click', function () {
            var layerId = document.getElementById('polygonSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setSymbolStyle(esri.symbol.SimpleFillSymbol.STYLE_NULL);
        });

        $('#polygonStyleRail').touchlink().bind('touchend click', function () {
            var layerId = document.getElementById('polygonSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setSymbolStyle(esri.symbol.SimpleFillSymbol.STYLE_FORWARD_DIAGONAL);
        });



        //设置point颜色
        $('#pointStyle-color').bind('change', function () {
            var layerId = document.getElementById('pointSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setSymbolColor(this.value);
            featurelayer.setVisibility(true);
        });

        //清除point样式
        $('#clearPointSymbolBtn').bind('click touchend', function () {
            var layerId = document.getElementById('pointSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.clearSymbol();

            var colorValue = document.getElementById('pointStyle-color');
            colorValue.selectedIndex = 0;

            //恢复图层的可见性
            var selectedLayerId = layerId.substr(5);
            var layer = dist.desktop.currentScreen.map.esrimap.getLayer("layer" + selectedLayerId);
            if (layer)
                layer.setVisibility(true);

        });



        //设置polyLine线颜色
        $('#polyLineStyle-color').bind('change', function () {
            var layerId = document.getElementById('polylineSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setSymbolColor(this.value);
            featurelayer.setVisibility(true);
        });

        //清除polyLine样式
        $('#clearPolyLineSymboBtn').bind('click touchend', function () {
            var layerId = document.getElementById('polylineSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.clearSymbol();

            var colorValue = document.getElementById('polyLineStyle-color');
            colorValue.selectedIndex = 0;

            //恢复图层的可见性
            var selectedLayerId = layerId.substr(5);
            var layer = dist.desktop.currentScreen.map.esrimap.getLayer("layer" + selectedLayerId);
            if (layer)
                layer.setVisibility(true);
            curLi.className = 'layer-eye eye-selected';
        });



        //设置polygon填充色
        $('#polygonStyle-color').bind('change', function () {
            var layerId = document.getElementById('polygonSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setSymbolColor(this.value);
            featurelayer.setVisibility(true);
        });



        //设置polygon边框线宽
        $('#polygonStyle-borderWidth').bind('change', function () {
            var layerId = document.getElementById('polygonSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setSymbolOutline(this.value, 'w');
            featurelayer.setVisibility(true);
        });

        //设置polygon边框颜色
        $('#polygonStyle-borderColor').bind('change', function () {
            var layerId = document.getElementById('polygonSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.setSymbolOutline(this.value, 'c');
            featurelayer.setVisibility(true);
        });

        //清除polygon样式
        $('#clearPolygonSymboBtn').bind('click touchend', function () {
            var layerId = document.getElementById('polygonSymbolContainer').getAttribute('layerId');
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer(layerId);
            var featurelayerHelper = new dist.gis.featureLayerHelper(featurelayer);
            featurelayerHelper.clearSymbol();

            var colorValue = document.getElementById('polygonStyle-color');
            colorValue.selectedIndex = 0;

            var bwValue = document.getElementById('polygonStyle-borderWidth');
            bwValue.selectedIndex = 0;

            var bcValue = document.getElementById('polygonStyle-borderColor');
            bcValue.selectedIndex = 0;

            //featurelayerHelper.removeFeatureLayer();

            //恢复图层的可见性
            var selectedLayerId = layerId.substr(5);
            var layer = dist.desktop.currentScreen.map.esrimap.getLayer("layer" + selectedLayerId);
            if (layer)
                layer.setVisibility(true);

        });

    }

}