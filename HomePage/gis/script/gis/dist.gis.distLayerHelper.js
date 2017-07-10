/******************************************
////////////////////////////////////////////////////////////////////////////////
//
//
//Copyright(C) 2012 上海数慧系统技术有限公司
//版权所有。
//文件名：DistLayerHelper
//文件功能描述：辅助帮助基本管理Layer
//
//创建标识：Chen Youqing
//创建时间：2012-3-31
////////////////////////////////////////////////////////////////////////////////
******************************************/

///<imports>各种引用</imports>


///<summary>Layer基本管理辅助帮手</summary>
///<param name="layer" type="Layer">需要辅助基本管理的Layer</param>
///<returns>没有返回值</returns>
function DistLayerHelper(layer) {
    var targetLayer = layer;
    var gradualShowTimer;
    var gradualHideTimer;

    ///<summary>layer</summary>
    ///<returns>Layer</returns>
    this.layer = targetLayer;

    ///<summary>layer的id</summary>
    ///<returns>String</returns>
    this.id = targetLayer.id;

    ///<summary>透明度，0.0-1.0</summary>
    ///<readAndWrite>只读</readAndWrite>
    ///<returns>Number</returns>
    this.opacity = targetLayer.opacity;

    ///<summary>url</summary>
    ///<readAndWrite>只读</readAndWrite>
    ///<returns>String</returns>
    this.url = targetLayer.url;

    ///<summary>可视性</summary>
    ///<readAndWrite>只读</readAndWrite>
    ///<returns>Boolean</returns>
    this.visible = targetLayer.visible;
    
     ///<summary>可视图层</summary>
    ///<readAndWrite>只读</readAndWrite>
    ///<returns>Boolean</returns>
    this.visibleLayers = targetLayer.visibleLayers;

    ///<summary>隐藏Layer，即将visible设置为false</summary>
    ///<returns>没有返回值</returns>
    this.hide = function () {
        targetLayer.hide();
    }

    ///<summary>隐藏Layer，减小opacity</summary>
    ///<returns>没有返回值</returns>
    this.gradualHide = function () {
        gradualHideTimer = setTimeout(gradualHideLayer, 10);
    }

    function gradualHideLayer() {
        if (targetLayer.opacity > 0) {
            targetLayer.setOpacity(targetLayer.opacity - 0.1);
            targetLayer.refresh();
            gradualHideTimer = setTimeout(gradualHideLayer, 10);
        }
        else if (targetLayer.opacity <= 0 ) {
            clearTimeout(gradualHideTimer);
        }
    }

    ///<summary>设置透明度</summary>
    ///<param name="opacity" type="Number" range="0.0-1.0">透明度</param>
    ///<returns>没有返回值</returns>
    this.setOpacity = function (opacity) {
        targetLayer.setOpacity(opacity);
    }

    ///<summary>设置可视性</summary>
    ///<param name="visible" type="Boolean">可视性</param>
    ///<returns>没有返回值</returns>
    this.setVisibility = function (visible) {
        targetLayer.setVisibility(visible);
    }

    ///<summary>显示Layer，即将visible设置为true</summary>
    ///<returns>没有返回值</returns>
    this.show = function () {
        targetLayer.show();
    }

    ///<summary>显示Layer，增加opacity</summary>
    ///<returns>没有返回值</returns>
    this.gradualShow = function () {
        gradualShowTimer = setTimeout(gradualShowLayer, 100);
    }

    function gradualShowLayer() {
        if (targetLayer.opacity < 1) {
            targetLayer.setOpacity(targetLayer.opacity + 0.1);
            targetLayer.refresh();
            gradualShowTimer = setTimeout(gradualShowLayer, 100);
        }
        else if (targetLayer.opacity >= 1) {
            clearTimeout(gradualShowTimer);
        }
    }

    ///<summary>获取地图服务下的layerIds</summary>
    ///<returns>数组</returns>
    this.getLayerIds = function () {
        if (targetLayer instanceof esri.layers.ArcGISDynamicMapServiceLayer
        || targetLayer instanceof esri.layers.ArcGISTiledMapServiceLayer) {

            var layerInfos = targetLayer.layerInfos;
            if (layerInfos == null || layerInfos.length == 0) return [];
            var layerIds = [];
            for (var i = 0; i < layerInfos.length; i++) {
                var layerInfo = layerInfos[i];
                layerIds.push(layerInfo.id);
            }

            return layerIds;

        }
        else {
            return null;
        }
    }

    ///<summary>获取地图服务下的layerIds</summary>
    ///<returns>数组</returns>
    this.getLayerIdByName = function (layerName) {
        if (targetLayer instanceof esri.layers.ArcGISDynamicMapServiceLayer
        || targetLayer instanceof esri.layers.ArcGISTiledMapServiceLayer) {

            var layerInfos = targetLayer.layerInfos;
            if (layerInfos == null || layerInfos.length == 0) return null;
            for (var i = 0; i < layerInfos.length; i++) {
                var layerInfo = layerInfos[i];
                if (layerInfo.name == layerName) {
                    return layerInfo.id;
                }
            }
        }
        else {
            return null;
        }
    }
    
    ///<summary>设置地图服务下的可视图层</summary>
    ///<param name="ids" type="Number[]" >可视图层layerIds</param>
    ///<param name="doNotRefresh" type="Boolean" >是否刷新</param>
    ///<returns></returns>
    this.setVisibleLayers = function(ids, doNotRefresh) {
        if (targetLayer instanceof esri.layers.ArcGISDynamicMapServiceLayer
        || targetLayer instanceof esri.layers.ArcGISTiledMapServiceLayer) {
            if (arguments.length == 1){
                targetLayer.setVisibleLayers(ids);
            }else{
                targetLayer.setVisibleLayers(ids,doNotRefresh);
            }
        }
        else {
            return null;
        }
    }
    
    ///<summary>设置地图服务下的可视图层</summary>
    ///<param name="layerName" type="String" >可视图层</param>
    ///<param name="doNotRefresh" type="Boolean" >是否刷新</param>
    ///<returns></returns>
    this.addVisibleLayer = function(layerName, doNotRefresh) {
        if (targetLayer instanceof esri.layers.ArcGISDynamicMapServiceLayer
        || targetLayer instanceof esri.layers.ArcGISTiledMapServiceLayer) {
            var lid = this.getLayerIdByName(layerName);
            var visiLyrs = targetLayer.visibleLayers;
            visiLyrs.push(lid);
            
            if (arguments.length == 1){
                targetLayer.setVisibleLayers(visiLyrs);
            }else{
                targetLayer.setVisibleLayers(visiLyrs,doNotRefresh);
            }
        }
        else {
            return null;
        }
    }
    
    ///<summary>获取地图服务下的layerIds</summary>
    ///<param name="layerName" type="String" >可视图层</param>
    ///<param name="doNotRefresh" type="Boolean" >是否刷新</param>
    ///<returns>数组</returns>
    this.removeVisibleLayer = function(layerName, doNotRefresh) {
        if (targetLayer instanceof esri.layers.ArcGISDynamicMapServiceLayer
        || targetLayer instanceof esri.layers.ArcGISTiledMapServiceLayer) {
            var lid = this.getLayerIdByName(layerName);
            var lidx = -1;
            var visiLyrs = targetLayer.visibleLayers;
            for(var i=0;i<visiLyrs.length;i++){
                if(visiLyrs[i]==lid){
                    lidx = i;
                    break;
                }
            
            }
            visiLyrs.splice(lidx);
            if(visiLyrs.length==0){
                visiLyrs.push(-1);
            }
            if (arguments.length == 1){
                targetLayer.setVisibleLayers(visiLyrs);
            }else{
                targetLayer.setVisibleLayers(visiLyrs,doNotRefresh);
            }
        }
        else {
            return null;
        }
    }
    
    
    
}