
/******************************************
////////////////////////////////////////////////////////////////////////////////
//
//
//Copyright(C) 2012 上海数慧系统技术有限公司
//版权所有。
//文件名：DistTasksHelper
//文件功能描述：各种查询、鉴别等任务辅助帮手
//
//创建标识：Chen Youqing
//创建时间：2012-4-1
////////////////////////////////////////////////////////////////////////////////
******************************************/


///<imports>各种引用</imports>
dojo.require("esri.toolbars.draw");


///<summary>任务辅助帮手</summary>
///<returns>没有返回值</returns>
dist.gis.tasksHelper = function () {
    var identifyMap;
    var identifyParameters;
    var identifyTimes;
    var lyIndex;
    var identifyTask;
    var anchorPoint;


    var identifyMap2;
    var identifyParameters2;
    var identifyTimes2;
    var identifyTask2;
    var anchorPoint2;
    var taskOptions2;
    var identifyListener2;
    var layersArray;

    var findMap;
    var findParameters;
    var findTimes;
    var findVisibleLayerCount;
    var findVisibleLayerTimes;
    var findTask;
    var callbackFindResults;
    var findTaskResultFunction;
    var taskOptions;
    var identifyListener;
    var actived = false;
    this.imap = null;
    ///<summary>开启识别查询</summary>
    ///<param name="map" type="DistMapHelper">DistMapHelper</param>
    ///<returns>没有返回值</returns>
    this.identifyHandler = function (map, options) {
        identifyMap = map;
        this.imap = map;
        taskOptions = options;
        if (!actived) {
            identifyListener = dojo.connect(identifyMap, "onClick", doIdentify);
        }

        actived = true;
    }

    ///<summary>关闭识别查询</summary>
    ///<returns>没有返回值</returns>
    this.closeIdentifyHandler = function () {
        if (identifyListener) {
            dojo.disconnect(identifyListener);
            actived = false;
        }
    }

    function doIdentify(evt) {
        ////判定查询的graphic是否弹出信息窗体
        //var searchHandler = dist.desktop.gisMapHanlder.searchHandler;
        ////地名定位
        //if (searchHandler.isAddressResult) {
        //    if(evt.graphic){
        //        searchHandler.findChoice = "project";
        //        searchHandler.setProjectSearchParm("0=0",searchHandler.findChoice,evt.graphic.geometry);
        //    }
        //}
        
        if (!dist.desktop.showAttributes) {
            if(!evt.graphic){
                identifyMap.infoWindow.hide();
            }
            return;
        }
        if (identifyMap.graphics) {
            if (identifyMap.graphics.graphics.length > 0) {
                //i查询状态下清除当前高亮显示要素
                identifyMap.graphics.clear();
                identifyMap.infoWindow.hide();
            }

        } else { return; }


        identifyMap.infoWindow.hide();
        identifyParameters = new esri.tasks.IdentifyParameters();
        anchorPoint = evt.mapPoint;


        //冗余范围
        //var tolerace = new identifyParameters.tolerance(3);
        identifyParameters.tolerance = 3;
        //进行Identify的图层为可见图层LAYER_OPTION_VISIBLE
        // var layerOption = new identifyParameters.layerOption(esri.tasks.IdentifyParameters.LAYER_OPTION_ALL);
        identifyParameters.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;
        //var width = new identifyParameters.width(identifyMap.width);
        //var height = new identifyParameters.height(identifyMap.height);
        identifyParameters.width = identifyMap.width;
        identifyParameters.height = identifyMap.height;
        //Identify范围
        //var mapExtent = new identifyParameters.mapExtent(identifyMap.extent);
        identifyParameters.mapExtent = identifyMap.extent;
        //Identify的geometry
        //var geometry = new identifyParameters.geometry(evt.mapPoint);
        identifyParameters.geometry = evt.mapPoint;
        //返回地理元素
        // var returnGeometry = new identifyParameters.returnGeometry(true);
        // var spatialReference = new identifyParameters.spatialReference(identifyMap.spatialReference);
        identifyParameters.returnGeometry = true;
        identifyParameters.spatialReference = identifyMap.spatialReference;
        //进行Identify的图层
        var layerIds = identifyMap.layerIds;
        var layerLength = layerIds.length;
        identifyTimes = layerLength;
        identifyTaskExecute(identifyMap, identifyParameters);
    }

    this.doIdentifyByPoint = function (mapPoint) {

        if (identifyMap.graphics) {
            if (identifyMap.graphics.graphics.length > 0) {
                identifyMap.graphics.clear();
                identifyMap.infoWindow.hide();
            }
        } else {
            return;
        }
        identifyMap.graphics.clear();
        identifyMap.infoWindow.hide();
        identifyParameters = new esri.tasks.IdentifyParameters();
        anchorPoint = mapPoint;
        /*
        var tolerace = new identifyParameters.tolerance(10);
        var layerOption = new identifyParameters.layerOption(esri.tasks.IdentifyParameters.LAYER_OPTION_VISIBLE);
        var width = new identifyParameters.width(identifyMap.width);
        var height = new identifyParameters.height(identifyMap.height);
        var mapExtent = new identifyParameters.mapExtent(identifyMap.extent);
        var geometry = new identifyParameters.geometry(mapPoint);
        var returnGeometry = new identifyParameters.returnGeometry(true);
        var spatialReference = new identifyParameters.spatialReference(identifyMap.spatialReference);
        */

        identifyParameters.tolerance = 10;
        identifyParameters.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_VISIBLE;
        identifyParameters.width = identifyMap.width;
        identifyParameters.height = identifyMap.height;
        identifyParameters.mapExtent = identifyMap.extent;
        identifyParameters.geometry = mapPoint;
        identifyParameters.returnGeometry = true;
        identifyParameters.spatialReference = identifyMap.spatialReference;

        var layerIds = identifyMap.layerIds;
        var layerLength = layerIds.length;
        identifyTimes = layerLength;
        lyIndex = layerLength;
        identifyTaskExecute(identifyMap, identifyParameters);
    }

    function identifyTaskExecute(map, ip) {
        identifyTimes--;
        if (identifyTimes >= 0) {
            var layer = map.getLayer(map.layerIds[identifyTimes]);
            if (layer instanceof esri.layers.ArcGISDynamicMapServiceLayer
            || layer instanceof esri.layers.ArcGISTiledMapServiceLayer) {
                var url = layer.url;
                var layerIds = [];
                if (layer.visible == false || layer.opacity <= 0) {
                    identifyTaskExecute(identifyMap, identifyParameters);
                    return;
                }
                if (layer instanceof esri.layers.ArcGISDynamicMapServiceLayer) {
                    layerIds = layer.visibleLayers;
                }
                else {
                    var layerHeper = new dist.gis.layerHelper(layer);
                    layerIds = layerHeper.getLayerIds();
                }
                var copyLayerIds = layerIds.concat();
                //                ip.layerIds = copyLayerIds;
                ip.layerIds = copyLayerIds; //.reverse();
                identifyTask = new esri.tasks.IdentifyTask(url);
                identifyTask.execute(ip, identifyCompleteHandler, errorHandler);
            }
        }
    }


    function identifyCompleteHandler(identifyResults) {
        if (identifyResults && identifyResults.length > 0) {
            var identifyResult = identifyResults[0];
            var graphic = identifyResult.feature;

            if (!check(graphic.attributes)) {
                dist.desktop.onMapClick(null, null);
                return;
            }

            /*
            var infoTemplate = new esri.InfoTemplate();
            infoTemplate.setTitle("自我介绍");
            infoTemplate.setContent("${*}");
            graphic.setInfoTemplate(infoTemplate);

            identifyMap.graphics.add(graphic);
            identifyMap.infoWindow.setTitle("自我介绍");
            identifyMap.infoWindow.setContent(graphic.getContent());
            identifyMap.infoWindow.show(anchorPoint);
            */

            var infoTemplate = new esri.InfoTemplate();
            infoTemplate.setTitle("");
            infoTemplate.setContent("${*}");
            //            graphic.setInfoTemplate(infoTemplate);
            //增加GraphicLayer到Map实现高亮
            var imap = dist.desktop.currentScreen.loader.distTasksHelper.imap;
            dist.desktop.distMapHelper.addGraphicLayerHighLight(graphic.geometry, true, imap); //属性查询
            identifyMap.infoWindow.setTitle("属性");
            identifyMap.infoWindow.setContent(graphic.getContent());
            //            identifyMap.infoWindow.show(anchorPoint);
            dist.desktop.onMapClick(graphic.attributes, graphic.geometry);
        }
        else {
            identifyTaskExecute(identifyMap, identifyParameters);
        }
    }
    function errorHandler(error) {
        alert(error.message);
    }

    ///<summary>开启指定图层识别查询</summary>
    ///<param name="map" type="DistMapHelper">DistMapHelper</param>
    ///<param name="layersPara" type="Array">需要查询的各个地图服务下的图层id，例如[{layer:dynamicLayer1,layerIds:[3,5]},...]</param>
    ///<returns>没有返回值</returns>
    this.identifyHandlerByLayerIds = function (map, layersPara, options) {
        identifyMap2 = map;
        taskOptions2 = options;
        layersArray = layersPara;
        identifyListener2 = dojo.connect(identifyMap2, "onClick", doIdentify2);
    }

    ///<summary>关闭识别查询</summary>
    ///<returns>没有返回值</returns>
    this.closeIdentifyHandlerByLayerIds = function () {
        if (identifyListener2) {
            dojo.disconnect(identifyListener2);
        }
    }

    function doIdentify2(evt) {
        /*
        if (identifyMap.graphics) {
        if (identifyMap.graphics.graphics.length > 0) {
        identifyMap.graphics.clear();
        identifyMap.infoWindow.hide();
        return;
        }
        } else {
        return;
        }*/
        identifyMap2.graphics.clear();
        identifyMap2.infoWindow.hide();
        identifyParameters2 = new esri.tasks.IdentifyParameters();
        anchorPoint2 = evt.mapPoint;

        identifyParameters2.tolerance = 3;
        identifyParameters2.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_VISIBLE;
        identifyParameters2.width = identifyMap2.width;
        identifyParameters2.height = identifyMap2.height;
        identifyParameters2.mapExtent = identifyMap2.extent;
        identifyParameters2.geometry = (evt.mapPoint);
        identifyParameters2.returnGeometry = true;
        // var spatialReference = identifyParameters2.spatialReference = identifyMap2.spatialReference;
        /*
        var tolerace = new identifyParameters2.tolerance(3);
        var layerOption = new identifyParameters2.layerOption(esri.tasks.IdentifyParameters.LAYER_OPTION_VISIBLE);
        var width = new identifyParameters2.width(identifyMap2.width);
        var height = new identifyParameters2.height(identifyMap2.height);
        var mapExtent = new identifyParameters2.mapExtent(identifyMap2.extent);
        var geometry = new identifyParameters2.geometry(evt.mapPoint);
        var returnGeometry = new identifyParameters2.returnGeometry(true);
          */
        identifyTimes2 = layersArray.length;

        identifyTaskExecute2(identifyMap2, identifyParameters2);
    }

    function identifyTaskExecute2(map, ip) {
        identifyTimes2--;
        if (identifyTimes2 >= 0) {
            var layerItem = layersArray[identifyTimes2];
            var layer = layerItem.layer;
            if (layer instanceof esri.layers.ArcGISDynamicMapServiceLayer
            || layer instanceof esri.layers.ArcGISTiledMapServiceLayer) {
                var url = layer.url;
                var layerIds = [];
                if (layer.visible == false || layer.opacity <= 0) {
                    identifyTaskExecute2(identifyMap2, identifyParameters2);
                    return;
                }

                layerIds = layerItem.layerIds;

                var copyLayerIds = layerIds.concat();
                ip.layerIds = copyLayerIds.reverse();
                identifyTask2 = new esri.tasks.IdentifyTask(url);
                identifyTask2.execute(ip, identifyCompleteHandler2, errorHandler);
            }
        }
    }

    function identifyCompleteHandler2(identifyResults) {
        if (identifyResults && identifyResults.length > 0) {
            var identifyResult = identifyResults[0];
            var graphic = identifyResult.feature;

            if (!check(graphic.attributes)) {
                dist.desktop.onMapClick(null, null);
                return;
            }

            if (graphic.geometry instanceof esri.geometry.Point) {
                var sms = new esri.symbol.SimpleMarkerSymbol().setStyle(esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE).setColor(new dojo.Color([255, 0, 0, 0.5]));
                graphic.setSymbol(sms);
            }
            else if (graphic.geometry instanceof esri.geometry.Polyline) {
                var sls = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0, 0.5]), 5);
                graphic.setSymbol(sls);
            }
            else if (graphic.geometry instanceof esri.geometry.Polygon) {
                var sfs = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0, 0.7]), 5), new dojo.Color([151, 219, 20, .7]));
                graphic.setSymbol(sfs);
            }

            var infoTemplate = new esri.InfoTemplate();
            infoTemplate.setTitle("");
            infoTemplate.setContent("${*}");
            graphic.setInfoTemplate(infoTemplate);
            identifyMap2.graphics.add(graphic);
            var iw = identifyMap2.infoWindow;
            dist.desktop.onMapClick(graphic.attributes, graphic.geometry);
        }
        else {
            identifyTaskExecute2(identifyMap2, identifyParameters2);
        }
    }

    ///<summary>开启查找查询</summary>
    ///<param name="map" type="Map">Map</param>
    ///<param name="findText" type="String">查找关键字</param>
    ///<returns>没有返回值</returns>
    this.findHandler = function (map, findText, resultFunction) {
        callbackFindResults = [];
        findTaskResultFunction = resultFunction;
        findMap = map;
        findMap.graphics.clear();
        findParameters = new esri.tasks.FindParameters(); //new dist.gis.findParametersHelper();
        /*
        var contains = new findParameters.contains(true);
        var searchText = new findParameters.searchText(findText);
        var returnGeometry = new findParameters.returnGeometry(true);
        */

        findParameters.contains = true;
        findParameters.searchText = findText;
        findParameters.returnGeometry = true;

        var layerIds = findMap.layerIds;
        var layerLength = layerIds.length;
        findTimes = layerLength;
        findVisibleLayerCount = getVisibleLayerCount(findMap);
        if (findVisibleLayerCount == 0) {
            findTaskResultFunction([]);
            return;
        }
        findVisibleLayerTimes = 0;
        findTaskExecute(findMap, findParameters);
    }

    function findTaskExecute(map, ip) {
        findTimes--;
        if (findTimes >= 0) {
            var layer = map.getLayer(map.layerIds[findTimes]);
            if (layer instanceof esri.layers.ArcGISDynamicMapServiceLayer
            || layer instanceof esri.layers.ArcGISTiledMapServiceLayer) {
                if (layer.visible == false || layer.opacity <= 0) {
                    findTaskExecute(findMap, findParameters);
                    return;
                }
                findVisibleLayerTimes++;
                var url = layer.url;
                var layerHeper = new dist.gis.layerHelper(layer);
                var layerIds = [];
                layerIds = layerHeper.getLayerIds();
                var copyLayerIds = layerIds.concat();
                ip.layerIds = copyLayerIds.reverse();
                findTask = new esri.tasks.FindTask(url); //new dist.gis.findTaskHelper(url);
                findTask.execute(ip, findCompleteHandler, errorHandler);
            }
        }
    }

    function findCompleteHandler(findResults) {

        if (findResults && findResults.length > 0) {
            callbackFindResults.push(findResults);
        }
        if (findTimes > 0) {
            findTaskExecute(findMap, findParameters);
        }
        if (findTimes == 0 && findVisibleLayerTimes == findVisibleLayerCount) {
            findTaskResultFunction(callbackFindResults);
        }
    }

    function getVisibleLayerCount(map) {
        var layerIds = map.layerIds;
        if (layerIds == null || layerIds.length == 0) return 0;
        var visibleLayerCount = 0;
        for (var i = 0; i < layerIds.length; i++) {
            var layer = map.getLayer(map.layerIds[i]);
            if (layer instanceof esri.layers.ArcGISDynamicMapServiceLayer
            || layer instanceof esri.layers.ArcGISTiledMapServiceLayer) {
                if (layer.visible == true && layer.opacity > 0) visibleLayerCount++;
            }
        }

        return visibleLayerCount;

    }

    function check(obj) {
        if (!taskOptions)
            return true;

        if (!taskOptions.layerException) {
            return true;
        }

        var le = taskOptions.layerException;
        for (var i = 0; i < le.length; i++) {
            if (obj[le[i].name] == le[i].value)
                return false;
        }
        return true;
    }
}