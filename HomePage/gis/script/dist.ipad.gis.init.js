serverAddress = "58.246.138.178:8040"; //58.246.138.178:8040  192.168.1.239
currentMapIndex = 0;
currentServiceId = 'ghsjtj';


//配置MAP数量，以及每个MAP下的背景地图服务
//baseLayers、themeLayers的配置顺序即在MAP中的顺序
//visible：控制图层是否在地图上显示
//display：控制图层在图层列表中是否显示
baseMapConfigData =
					    [
					        {
					            mapId:'generalMap',
					            mapName:'常规地图',
					            baseLayers:[
					                        {
					                            id: "basemap1",
					                            name: "框架图",
					                            label: "框架图",
					                            type: "Tile",
					                            url: "http://" + serverAddress + "/ArcGIS/rest/services/lzBaseMap2/MapServer",
					                            visible: true,
					                            alpha: 1,
					                            layerInfos:[]
					                        }
					                    ],
					            themeLayers:[
	                                            {
		                                            id: "ghsjtj",
		                                            name: "规划设计条件",
		                                            label: "规划设计条件",
		                                            type: "Tile",
		                                            url:"http://" + serverAddress + "/ArcGIS/rest/services/lzThemeMapTile/MapServer",
		                                            visible: true,
					                                alpha: 1,
		                                            layerInfos:[],
		                                            featurelayers:[]
	                                            }
                                            ]
					        }
//					        {
//					            mapId:'oneMap',
//					            mapName:'一张图',
//					            baseLayers:[
//					                        {
//					                            id: "basemap1",
//					                            name: "框架图",
//					                            label: "框架图",
//					                            type: "Tile",
//					                            url: "http://" + serverAddress + "/ArcGIS/rest/services/lzBaseMap2/MapServer",
//					                            visible: true,
//					                            alpha: 1,
//					                            layerInfos:[]
//					                        }
//					                    ],
//					            themeLayers:[
//	                                            {
//		                                            id: "ghsjtj",
//		                                            name: "规划设计条件",
//		                                            label: "规划设计条件",
//		                                            type: "Dynamic",
//		                                            url: "http://" + serverAddress + "/ArcGIS/rest/services/lzThemeMap/MapServer",
//		                                            visible: true,
//					                                alpha: 1,
//		                                            layerInfos:[],
//		                                            featurelayers:[]
//	                                            }
//                                            ]
//					        }
					    ];
defaultExtentObj = { xmin: 74966.01773804738, xmax: 78725.99901418303, ymin: 80935.77866422356, ymax: 82970.16466870275 };

//仅使用FeatureLayer,提高加载性能和使用效果

addMapDiv();
addLayerDiv();

function addMapDiv(){
    if(baseMapConfigData && baseMapConfigData.length>0){
        for(var i=0;i<baseMapConfigData.length;i++){
            var mapDiv = document.createElement('DIV');
            mapDiv.id = 'mapDiv'+i;
            mapDiv.className = 'border wh floatLeft';
            $('#mapPage').append(mapDiv);
        }
    }
}

function addLayerDiv(){
    if(baseMapConfigData && baseMapConfigData.length>0){
        for(var i=0;i<5;i++){
            var layerViewerUL = document.createElement('UL');
            layerViewerUL.id = 'layerViewer'+i;
            layerViewerUL.style.margin = '0px';
            layerViewerUL.style.padding = '0px';
            layerViewerUL.style.listStyle = 'none';
            
            var layerViewerMarginDiv = document.createElement('DIV');
            layerViewerMarginDiv.style.margin = '5px';
            layerViewerMarginDiv.appendChild(layerViewerUL);
            
            var layerViewerContainerDiv = document.createElement('DIV');
            layerViewerContainerDiv.id = 'layerViewerContainer'+i;
            layerViewerContainerDiv.style.width = '350px';
            layerViewerContainerDiv.style.display = 'none';
            layerViewerContainerDiv.title = '图层管理';
            layerViewerContainerDiv.appendChild(layerViewerMarginDiv);
            $('#nav').append(layerViewerContainerDiv);
        }
    }
}

function getLayerInfos(mapId,themeServiceId){
    if(baseMapConfigData && baseMapConfigData.length>0){
        var mapIdx = getMapIndex(mapId);
        var themeLayers = baseMapConfigData[mapIdx].themeLayers;
        if(themeLayers && themeLayers.length>0){
            for(var i=0;i<themeLayers.length;i++){
                if(themeLayers[i].id==themeServiceId){
                    return themeLayers[i].layerInfos;
                }
            }
        }
    }
}

function setLayerList(layerInfos,layerGroupData,targetUlId){
    $('#'+targetUlId).html('');
    if(layerGroupData){
        var subLayerIds = layerGroupData.subLayerIds;
        if(subLayerIds && subLayerIds.length>0){
            for(var i=0;i<subLayerIds.length;i++){
                var layerLi = document.createElement('LI');
                layerLi.id = 'layerLi'+i;
                layerLi.idx = i;
                layerLi.innerText = layerInfos[subLayerIds[i]].name;
                layerLi.layerInfo = layerInfos[subLayerIds[i]];
                layerLi.style.lineHeight = layerLi.style.height = '60px';
                layerLi.style.borderBottom = 'solid 1px #cccccc';
                layerLi.style.fontSize = '18px';
                
                var layerSetDiv = document.createElement('DIV');
                layerSetDiv.id = 'layerSetDiv'+i;
                layerSetDiv.idx = i;
                layerSetDiv.style.float = 'right';
                layerSetDiv.style.height = '100%';
                
                var opacityImg = document.createElement('IMG');
                opacityImg.id = 'opacityImg'+i;
                opacityImg.src = 'images/light_24.png';
                opacityImg.style.float = 'right';
                opacityImg.style.marginTop = '18px';
                var visibleImg = document.createElement('IMG');
                visibleImg.id = 'visibleImg'+i;
                visibleImg.src = 'images/tick2_close_24.png';
                visibleImg.style.float = 'right';
                visibleImg.style.marginTop = '18px';
                
                var nextImg = document.createElement('IMG');
                nextImg.id = 'nextImg'+i;
                nextImg.src = 'images/go_next.png';
                nextImg.style.float = 'right';
                nextImg.style.marginTop = '18px';
                
                var editImg = document.createElement('IMG');
                editImg.id = 'editImg'+i;
                editImg.src = 'images/edit_24.png';
                editImg.style.float = 'right';
                editImg.style.marginTop = '18px';
                
                if(layerLi.layerInfo.subLayerIds && layerLi.layerInfo.subLayerIds.length>0){
                    layerSetDiv.appendChild(nextImg);
                }
                else{
                    layerSetDiv.appendChild(editImg);
                }
                
                layerSetDiv.appendChild(opacityImg);
                layerSetDiv.appendChild(visibleImg);
                
                layerLi.appendChild(layerSetDiv);
                $('#'+targetUlId).append(layerLi);
                
                $(visibleImg).bind('touchend click',function(evt){
                    var layerInfo = evt.currentTarget.parentElement.parentElement.layerInfo;
                    if(layerInfo.visible){
                        this.src = 'images/tick2_close_24.png';
                    }
                    else{
                        this.src = 'images/tick2_open_24.png';
                    }
                    
                    var layerInfos = getLayerInfos(baseMapConfigData[currentMapIndex].mapId,currentServiceId);
                    
                    if(layerInfo.visible){
                        setFeatureLayerVisible(layerInfo,layerInfos,currentServiceId,false);
                        layerInfo.visible = false;
                    }
                    else{
                        setFeatureLayerVisible(layerInfo,layerInfos,currentServiceId,true);
                        layerInfo.visible = true;
                    }
                    
                });
                
                $(opacityImg).bind('touchend click',function(evt){
                    var layerInfo = evt.currentTarget.parentElement.parentElement.layerInfo;
                    
                    var layerInfos = getLayerInfos(baseMapConfigData[currentMapIndex].mapId,currentServiceId);
                    
                });
            }
            
        }
    }
}

function setFeatureLayerVisible(layerInfo,layerInfos,themeServiceId,visible){
    var subLayerIds = layerInfo.subLayerIds;
    if(subLayerIds && subLayerIds.length>0){
        for(var i=0;i<subLayerIds.length;i++){
            setFeatureLayerVisible(layerInfos[subLayerIds[i]],layerInfos,themeServiceId,visible);
        }
    }
    else{
        var featurelayer = getFeatureLayer(baseMapConfigData[currentMapIndex].mapId,themeServiceId,themeServiceId+layerInfo.id);
        featurelayer.setVisibility(visible);
    }
}

function getFeatureLayer(mapId,themeServiceId,featurelayerId){
    if(baseMapConfigData && baseMapConfigData.length>0){
        var mapIdx = getMapIndex(mapId);
        var themeLayers = baseMapConfigData[mapIdx].themeLayers;
        if(themeLayers && themeLayers.length>0){
            for(var i=0;i<themeLayers.length;i++){
                if(themeLayers[i].id==themeServiceId){
                    var featurelayers = themeLayers[i].featurelayers;
                    for(var j=0;j<featurelayers.length;j++){
                        if(featurelayers[j].id==featurelayerId){
                            return featurelayers[j];
                        }
                    }
                }
            }
        }
    }
}

function getMapIndex(mapId){
    if(maps && maps.length>0){
        for(var i=0;i<maps.length;i++){
            if(maps[i].id==mapId){
                return i;
            }
        }
    }
}

function updateThemeLayerInfos(themeLayers,themeServices){
    if (themeLayers && themeLayers.length > 0 && themeServices && themeServices.length > 0) {
        for(var i=0;i<themeLayers.length;i++){
            themeLayers[i].layerInfos = themeServices[i].layerInfos;
        }
    }
}
//(j!=0) && (j!=1) && (j!=4) && (j!=5) && (j!=6) && (j!=7) && (j!=20) && (j!=21)
function addLayersByConfigData(themeLayer,map) {
    if (themeLayer) {
        var layerData = themeLayer;
        var url = layerData.url;
        var layerId = layerData.id;
        var featurelayers = layerData.featurelayers;
        var layerInfos = layerData.layerInfos;
        if (layerInfos && layerInfos.length > 0) {
            for (var j = layerInfos.length - 1; j >= 0; j--) {
                var subLayerIds = layerInfos[j].subLayerIds;
                layerInfos[j].visible = false; //layerInfos[j].defaultVisibility
                layerInfos[j].opacity = 1;
                if(subLayerIds && subLayerIds.length>0){
                    //no code
                }
                else{
                    var featureLayerData={};
                    featureLayerData.id = layerId + layerInfos[j].id;
                    featureLayerData.url = url + '/' + layerInfos[j].id;
                    featureLayerData.type = 'FeatureLayer';
                    featureLayerData.visible = layerInfos[j].visible; 
                    var fl = addLayerByLayerData(featureLayerData,map);
                    featurelayers.push(fl);
                }
            }
        }
        
    }
}

function calcOffset(map) {
  return (map.extent.getWidth() / map.width);
}

//新建layer并添加到map
function addLayerByLayerData(layerData,map) {
    if (!layerData.url || layerData.url == '') return;
    var layer = null;
    switch (layerData.type) {
        case "Tile":
            layer = new esri.layers.ArcGISTiledMapServiceLayer(layerData.url, { id: layerData.id, opacity: layerData.alpha, visible: layerData.visible });
            break;
        case "FeatureLayer":
            layer = new esri.layers.FeatureLayer(layerData.url, { id: layerData.id, opacity: layerData.alpha, visible: layerData.visible,maxAllowableOffset: calcOffset(map) }); //,maxAllowableOffset: calcOffset(map)
            layer.visibleAtMapScale = true;
            break;
        case "Dynamic":
            layer = new esri.layers.ArcGISDynamicMapServiceLayer(layerData.url, { id: layerData.id, opacity: layerData.alpha, visible: layerData.visible });
            break;
        default:
            return null;
            break;
    }
    map.addLayer(layer);
    return layer;
}

//新建layer，但是不添加到map
function newLayerByLayerData(layerData) {
    if (!layerData.url || layerData.url == '') return;
    var layer = null;
    switch (layerData.type) {
        case "Tile":
            layer = new esri.layers.ArcGISTiledMapServiceLayer(layerData.url, { id: layerData.id, opacity: layerData.alpha, visible: layerData.visible });
            break;
        case "Dynamic":
            layer = new esri.layers.ArcGISDynamicMapServiceLayer(layerData.url, { id: layerData.id, opacity: layerData.alpha, visible: layerData.visible });
            break;
        default:
            return null;
            break;
    }
    return layer;
}

function setLayerList1ByConfigData() {
}

function queryGraphicById(graphicId,map) {
    map.graphics.clear();
    var layer = map.getLayer('sjjmd0');
    var query = new esri.tasks.Query();
    var intGraphicId = Number(graphicId);
    query.where = 'OBJECTID=' + intGraphicId;
    layer.queryFeatures(query, xcxlResultHandler, errorHandler)
}

function xcxlResultHandler(featureSet) {
    var features = featureSet.features;
    if (features && features.length > 0) {
        dojo.disconnect(mapGraphicsListener);
        dojo.connect(map.graphics, "onClick", mapGraphicsClickHandler);
    }

}

function errorHandler(evt) {
    alert(evt.message);
}


$(document).ready(function() {
    $('#btn-layers').touchlink().bind('touchend click', function() {
        var layerInfos = getLayerInfos(baseMapConfigData[currentMapIndex].mapId,currentServiceId);
        setLayerList(layerInfos,layerInfos[0],'layerViewer0');
        dist.desktop.nav.show('layerViewerContainer0');
    });

    $('#btn-pointsymbol').touchlink().bind('touchend click', function() {
        var fid = '21';
        var featurelayer = getFeatureLayer(baseMapConfigData[currentMapIndex].mapId,currentServiceId,currentServiceId+fid);
        var featurelayerHelper = new FeatureLayerHelper(featurelayer);
        var size = featurelayerHelper.getPointSymbolSize();
        size = Math.ceil(size);
        $('#pointSize').html(size);
        dist.desktop.nav.show('pointSymbolContainer');
    });
    
    $('#pointSizeDown').touchlink().bind('touchend click', function() {
        var size = $('#pointSize').html();
        size--;
        $('#pointSize').html(size);
        
        var fid = '21';
        var featurelayer = getFeatureLayer(baseMapConfigData[currentMapIndex].mapId,currentServiceId,currentServiceId+fid);
        var featurelayerHelper = new FeatureLayerHelper(featurelayer);
        featurelayerHelper.setSize(size);
    });
    
    $('#pointSizeUp').touchlink().bind('touchend click', function() {
        var size = $('#pointSize').html();
        size++;
        $('#pointSize').html(size);
        
        var fid = '21';
        var featurelayer = getFeatureLayer(baseMapConfigData[currentMapIndex].mapId,currentServiceId,currentServiceId+fid);
        var featurelayerHelper = new FeatureLayerHelper(featurelayer);
        featurelayerHelper.setSize(size);
    });
    
    $('#btnPolylineSymbol').touchlink().bind('touchend click', function() {
        var fid = 2;
        var featurelayer = getFeatureLayer(baseMapConfigData[currentMapIndex].mapId,currentServiceId,currentServiceId+fid);
        var featurelayerHelper = new FeatureLayerHelper(featurelayer);
        var size = featurelayerHelper.getPolylineSymbolWidth();
        size = Math.ceil(size);
        $('#polylineSize').html(size);
        dist.desktop.nav.show('polylineSymbolContainer');
    });
    
     $('#polylineSizeDown').touchlink().bind('touchend click', function() {
        var size = $('#polylineSize').html();
        size--;
        $('#polylineSize').html(size);
        
        var fid = '2';
        var featurelayer = getFeatureLayer(baseMapConfigData[currentMapIndex].mapId,currentServiceId,currentServiceId+fid);
        var featurelayerHelper = new FeatureLayerHelper(featurelayer);
        featurelayerHelper.setPolylineSymbolWidth(size);
    });
    
    $('#polylineSizeUp').touchlink().bind('touchend click', function() {
        var size = $('#polylineSize').html();
        size++;
        $('#polylineSize').html(size);
        
        var fid = '2';
        var featurelayer = getFeatureLayer(baseMapConfigData[currentMapIndex].mapId,currentServiceId,currentServiceId+fid);
        var featurelayerHelper = new FeatureLayerHelper(featurelayer);
        featurelayerHelper.setPolylineSymbolWidth(size);
    });
    
    $('#polylineStyleSolid').touchlink().bind('touchend click', function() {
        var fid = '2';
        var featurelayer = getFeatureLayer(baseMapConfigData[currentMapIndex].mapId,currentServiceId,currentServiceId+fid);
        var featurelayerHelper = new FeatureLayerHelper(featurelayer);
        featurelayerHelper.setSymbolStyle(esri.symbol.SimpleLineSymbol.STYLE_SOLID);
    });
    
    $('#polylineStyleDash').touchlink().bind('touchend click', function() {
        var fid = '2';
        var featurelayer = getFeatureLayer(baseMapConfigData[currentMapIndex].mapId,currentServiceId,currentServiceId+fid);
        var featurelayerHelper = new FeatureLayerHelper(featurelayer);
        featurelayerHelper.setSymbolStyle(esri.symbol.SimpleLineSymbol.STYLE_DASH);
    });
    
    $('#polylineStyleRail').touchlink().bind('touchend click', function() {
        var fid = '2';
        var featurelayer = getFeatureLayer(baseMapConfigData[currentMapIndex].mapId,currentServiceId,currentServiceId+fid);
        var featurelayerHelper = new FeatureLayerHelper(featurelayer);
        featurelayerHelper.setSymbolStyle(esri.symbol.SimpleLineSymbol.STYLE_SHORTDASHDOTDOT);
    });
    
    $('#btnPolygonSymbol').touchlink().bind('touchend click', function() {
        dist.desktop.nav.show('polygonSymbolContainer');
    });
    
    $('#polygonStyleSolid').touchlink().bind('touchend click', function() {
        var fid = '4';
        var featurelayer = getFeatureLayer(baseMapConfigData[currentMapIndex].mapId,currentServiceId,currentServiceId+fid);
        var featurelayerHelper = new FeatureLayerHelper(featurelayer);
        featurelayerHelper.setSymbolStyle(esri.symbol.SimpleFillSymbol.STYLE_SOLID);
    });
    
    $('#polygonStyleDash').touchlink().bind('touchend click', function() {
        var fid = '4';
        var featurelayer = getFeatureLayer(baseMapConfigData[currentMapIndex].mapId,currentServiceId,currentServiceId+fid);
        var featurelayerHelper = new FeatureLayerHelper(featurelayer);
        featurelayerHelper.setSymbolStyle(esri.symbol.SimpleFillSymbol.STYLE_NULL);
    });
    
    $('#polygonStyleRail').touchlink().bind('touchend click', function() {
        var fid = '4';
        var featurelayer = getFeatureLayer(baseMapConfigData[currentMapIndex].mapId,currentServiceId,currentServiceId+fid);
        var featurelayerHelper = new FeatureLayerHelper(featurelayer);
        featurelayerHelper.setSymbolStyle(esri.symbol.SimpleFillSymbol.STYLE_FORWARD_DIAGONAL);
    });
    
});
    
