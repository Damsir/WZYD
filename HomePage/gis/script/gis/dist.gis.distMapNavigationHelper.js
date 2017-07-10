/******************************************
////////////////////////////////////////////////////////////////////////////////
//
//
//Copyright(C) 2012 上海数慧系统技术有限公司
//版权所有。
//文件名：DistMapNavigationHelper
//文件功能描述：辅助帮助和控制map移动范围、前进后退视图；但是当需要用到前进后退视图时，new DistMapNavigationHelper(map)操作需要紧随在new Map("mapDiv")之后，以便注册监听onExtentHistoryChange事件。
//
//创建标识：Chen Youqing
//创建时间：2012-3-28
////////////////////////////////////////////////////////////////////////////////
******************************************/

///<imports>各种引用</imports>
dojo.require("esri.toolbars.navigation");

///<summary>导航辅助帮手</summary>
///<param name="map" type="Map">需要导航辅助的Map</param>
///<returns>没有返回值</returns>
function DistMapNavigationHelper(map) {

    var targetMap = map;
    var targetNavigation = new esri.toolbars.Navigation(targetMap);
    dojo.connect(targetNavigation, "onExtentHistoryChange", extentHistoryChangeHandler);
    ///<summary>Navigation的onExtentHistoryChange事件监听返回处理函数，需要进行注册监听onExtentHistoryChange事件zoomToPrevExtent、zoomToNextExtent函数才会生效</summary>
    ///<returns>没有返回值</returns>
    function extentHistoryChangeHandler() {
        //no code
    }

    ///<summary>缩放到全图状态</summary>
    ///<returns>没有返回值</returns>
    this.zoomToFullExtent = function () {
        targetNavigation.zoomToFullExtent();
    }

    ///<summary>后退到上一次地图范围视图</summary>
    ///<returns>没有返回值</returns>
    this.zoomToPrevExtent = function () {
        targetNavigation.zoomToPrevExtent();
    }

    ///<summary>前进到下一次地图范围视图</summary>
    ///<returns>没有返回值</returns>
    this.zoomToNextExtent = function () {
        targetNavigation.zoomToNextExtent();
    }

    ///<summary>使缩放方式失效</summary>
    ///<returns>没有返回值</returns>
    this.deactivate = function () {
        targetNavigation.deactivate();
    }

    ///<summary>激活缩放方式</summary>
    ///<param name="navType">缩放方式：放大（Navigation.ZOOM_IN）、缩小（Navigation.ZOOM_OUT）、拖动（Navigation.PAN）</param>
    ///<returns>没有返回值</returns>
    this.activate = function (navType) {
        targetNavigation.activate(navType);
    }

}