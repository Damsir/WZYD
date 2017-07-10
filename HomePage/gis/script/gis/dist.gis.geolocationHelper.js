/******************************************
////////////////////////////////////////////////////////////////////////////////
//
//
//Copyright(C) 2012 上海数慧系统技术有限公司
//版权所有。
//文件名：DistGeolactionHelper
//文件功能描述：辅助帮助设备几何定位
//
//创建标识：Chen Youqing
//创建时间：2012-4-26
////////////////////////////////////////////////////////////////////////////////
******************************************/

///<summary>设备几何定位辅助帮手</summary>
///<param name="map" type="Map">需要辅助设备几何定位的Map</param>
///<returns>没有返回值</returns>
dist.gis.geolocationHelper = function(map) {

    var targetMap = map;
    var watchPositionHandler;
    var localGraphic;
    var mapHelper = new dist.gis.mapHelper(map);
    var gpsLayer;
    var positonToCenterOnce = false;
    var watchPositionFlag = false;
    var arrowImgUrl = 'images/arrow_up_33.png';


    ///<summary>map</summary>
    ///<returns>Map</returns>
    this.map = map;

    ///<summary>Geolaction</summary>
    ///<returns>Geolaction</returns>
    this.geolaction = navigator.geolocation;

    ///<summary>打开默认GPS</summary>
    ///<returns>没有返回值</returns>
    this.openDefaultGPS = function () {
        if (this.geolaction) {
            positonToCenterOnce = false;
            if (watchPositionFlag) {
                this.geolaction.clearWatch(watchPositionHandler);
                watchPositionFlag = false;
            }
            watchPositionHandler = this.geolaction.watchPosition(updateLocation, handleLocationError);
            watchPositionFlag = true;
        }
    }

    ///<summary>关闭默认GPS</summary>
    ///<returns>没有返回值</returns>
    this.closeDefaultGPS = function () {
        if (watchPositionFlag) this.geolaction.clearWatch(watchPositionHandler);
        watchPositionFlag = false;
        gpsLayer = mapHelper.getGraphicsLayer("gpsLayer");
        gpsLayer.clear();
        positonToCenterOnce = false;
    }

    function updateLocation(position) {
        gpsLayer = mapHelper.getGraphicsLayer("gpsLayer");
        gpsLayer.clear();
        var latitude = position.coords.latitude;
        var longitude = position.coords.longitude;
 
//        var heading = position.coords.heading;
//        var accuracy = position.coords.accuracy;
        
//        alert('latitude:'+latitude+'----longitude:'+longitude+'----accuracy:'+accuracy);

        // sanity test... don't calculate distance if accuracy
        // value too large
//        if (accuracy >= 500) {
//            alert("误差："+accuracy + "米，误差过大,超过500米。");
//            //openDefaultGPS
//            if (this.geolaction) {
//                positonToCenterOnce = false;
//                if (watchPositionFlag) {
//                    this.geolaction.clearWatch(watchPositionHandler);
//                    watchPositionFlag = false;
//                }
//                watchPositionHandler = this.geolaction.watchPosition(updateLocation, handleLocationError);
//                watchPositionFlag = true;
//            }
//            return;
//        }

        var geoPoint = new esri.geometry.Point(longitude,latitude,map.spatialReference);        
        var mocatoPoint = map.toMap(geoPoint);//esri.geometry.geographicToWebMercator(geoPoint);
//        var mocatoPoint = map.toMap(geoPoint);
//        var p1 = map.toScreen(geoPoint);
//        var p1 = map.toMap(mocatoPoint);
        var pms = new esri.symbol.PictureMarkerSymbol({
            "url": arrowImgUrl,
            "height": 33,
            "width": 24,
            "type": "esriPMS"
        });

        var sms = new esri.symbol.SimpleMarkerSymbol().setStyle(esri.symbol.SimpleMarkerSymbol.STYLE_X).setColor(new dojo.Color([255, 0, 0, 0.5]));
        localGraphic = new esri.Graphic(mocatoPoint, pms);
        gpsLayer.add(localGraphic);
        if (!positonToCenterOnce) {
            positonToCenterOnce = true;
            map.centerAt(mocatoPoint,15);
            //map.centerAndZoom(mocatoPoint,0.1);
        }
        openOrientation();
    }

    function handleLocationError(error) {
        if(error) alert(error.message);
    }

    function openOrientation() {
        window.removeEventListener("deviceorientation", handleOrientation, true);
        window.addEventListener("deviceorientation", handleOrientation, true);
    }
    function handleOrientation(orientData) {
        var absolute = orientData.absolute;
        var alpha = orientData.alpha;
        var beta = orientData.beta;
        var gamma = orientData.gamma;
        if (alpha < 0) {
            alpha = alpha * (-1) + 180;
        }
        else {
            alpha = 180 - alpha;
        }

        var pms = new esri.symbol.PictureMarkerSymbol({
            "url": arrowImgUrl,
            "height": 33,
            "width": 24,
            "type": "esriPMS",
            "angle": alpha
        });
        localGraphic.setSymbol(pms);
    }
}