//项目定位
dist.gis.locateProject = function(name, key, callback) {
    this.name = name;
    this.key = key;
    this.resultCallback = callback;
    this.canceled = false;
    this.queryIndex = 0;
    this.locateConfig = null;
    this.result = null;
    this.esrimap = dist.desktop.currentScreen.map.esrimap;
    this.distMapHelper = new dist.gis.mapHelper(this.esrimap);
    this.cancel = function() {
        this.canceled = true;
    }

    this.locate = function() {

        var locateConfigs = dist.map.config.locate;

        if (!locateConfigs) {
            this.resultCallback(false, []);
            return;
        }

        var locateObj = null;
        for (var i = 0; i < locateConfigs.length; i++) {
            var c = locateConfigs[i];
            if (c.name == this.name) {
                locateObj = c;
                break;
            }
        }

        if (!locateObj) {
            this.resultCallback(false, []);
            return;
        }

        this.locateConfig = locateObj;
        this.queryIndex = 0;
        this.result = [];
        this.executeQuery();


    }

    this.executeQuery = function() {
        var qt = this.locateConfig.config[this.queryIndex];
        if (qt) {
            var queryTask = new esri.tasks.FindTask(qt.services);

            var params = new esri.tasks.FindParameters();
            params.layerIds = qt.layers;
            params.searchFields = [qt.identify];
            params.returnGeometry = true;
            params.searchText = this.key;

            var $s = this;
            queryTask.execute(params, function(findResult) { $s.queryResultsHanlder(findResult); }, function(er) { $s.queryFaulthanlder(er); });

            this.queryIndex++;
        } else {
            this.resultCallback(true, this.result);
        }
    }

    this.queryResultsHanlder = function(findResult) {
        //var resultFeatures = featureSet.features;
        //var infoTemplate = new esri.InfoTemplate("${CITY_NAME}", "Name : ${CITY_NAME}<br/> State : ${STATE_NAME}<br />Population : ${POP1990}");
        //for (var i = 0; i < resultFeatures.length; i++) {
        //var graphic = resultFeatures[i];
        //this.highlightGraphic(graphic, false);
        //var symbol = new esri.symbol.SimpleMarkerSymbol();
        //symbol.setStyle(esri.symbol.SimpleMarkerSymbol.STYLE_SQUARE);
        //symbol.setSize(10);
        //symbol.setColor(new dojo.Color([255, 0, 0, 0.5]));
        //graphic.setSymbol(symbol);
        //graphic.setInfoTemplate(infoTemplate);
        //}
        this.result.push(findResult);
        if (this.result.length < 0)
            this.executeQuery();
        else {
            if(findResult[0]){
                this.zoomToProject(findResult[0]);
            }else {
                alert("无匹配项目!");
            }
        }
    }

    this.queryFaulthanlder = function(er) {
        //        this.executeQuery();
    }
    //项目定位
    this.zoomToProject = function(location) {
        var lyType = location.feature.geometry.type;
        var graphic = location.feature;
        var pExtent;
        //dist.desktop.currentScreen.map.esrimap.graphics.clear();
        if (lyType == "point") {
            var locationX = location.feature.geometry.x;
            var locationY = location.feature.geometry.y;
            point = new esri.geometry.Point(Number(locationX), Number(locationY), this.esrimap.spatialReference);
            pExtent = point.getExtent();
            var sms = new esri.symbol.PictureMarkerSymbol('images/dtz2.png', 17, 30);
            sms.setOffset(0, 15);
            graphic.setSymbol(sms);

        }
        else if (lyType == "polygon") {
            var polygon = new esri.geometry.Polygon(this.esrimap.spatialReference);
            polygon.addRing(location.feature.geometry.rings[0]);
            //            point = polygon.getExtent().getCenter();
            pExtent = polygon.getExtent();
            var sfs = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID,
            new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
            new dojo.Color([255, 0, 0, 0.7]), 5), new dojo.Color([151, 219, 20, .7]));
            graphic.setSymbol(sfs);
        }
        else if (lyType == 'polyline') {
            var polyline = new esri.geometry.Polyline(this.esrimap.spatialReference);
            polyline.addPath(location.feature.geometry.paths[0]);
            pExtent = polyline.getExtent();
            var sls = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0, 0.5]), 5);
            graphic.setSymbol(sls);
        }
        //this.esrimap.setExtent(pExtent.expand(2.0));
        this.distMapHelper.zoomToGeometry(pExtent); //定位到项目点
        dist.desktop.currentScreen.map.esrimap.graphics.add(graphic); //高亮显示项目点

    }
}