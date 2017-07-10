//地址查询、项目查询
(function () {
    dist.gis.searchWidgetHelper = function () {
        var helper = this;
        var catalogBtn;
        var keyWordInput;
        var searchBtn;
        var maxRecords = 1000;
        var results = [];
        var map = dist.desktop.currentScreen.map.esrimap;
        var distMapHelper = new dist.gis.mapHelper(map); //new DistMapHelper(esrimap);

        this.sMap = map;
        this.findChoice = 'project'; //默认三证查询

        this.isAddressResult = false;
        this.currentCircleGraphic=null;
        this.queryParams = [];
        this.queryCount = 0;
        this.sumCount = 0;
        this.zoomPolygon = null;

        //展示结果列表
        this.setSearchResultList = function (div) {
            div.innerHTML = '';

            var countDiv = document.createElement('DIV');
            countDiv.style.height = '30px';
            countDiv.style.lineHeight = '30px';
            countDiv.style.fontWeight = 'bold';
            countDiv.style.fontSize = '14px';
            var countStr = '为您查到 ';
            countStr += results.length;
            countStr += ' 个结果。';
            countDiv.innerText = countStr;

            var resultDiv = document.createElement('DIV');
            resultDiv.id = 'addressList';
            resultDiv.style.height = '450px';
            resultDiv.style.width = '97%';
            resultDiv.style.position = 'relative';
            resultDiv.style.overflow = 'auto';

            var resultUl = document.createElement('UL');
            resultUl.style.listStyle = 'none';
            resultUl.style.margin = '5px';
            resultUl.style.padding = '0px';
            resultUl.id = 'searchRresultList';


            if (results && results.length > 0) {
                for (var i = 0; i < results.length; i++) {
                    var lnl = document.createElement('LABEL');
                    lnl.style.display = 'block';
                    lnl.className = 'pp-place-title';
                    if (helper.findChoice == 'address') {
                        lnl.innerText = results[i].displayName;
                    }
                    else {
                        lnl.innerText = results[i].displayName;
                    }


                    var lal = document.createElement('LABEL');
                    lal.style.display = 'block';
                    lal.className = 'pp-headline-address';
                    if (helper.findChoice == 'address')
                    { lal.innerText = results[i].displayName; }
                    else
                    { lal.innerText = results[i].displayName; }

                    var li = document.createElement('LI');
                    li.className = 'rsLi';
                    li.graphic = results[i].graphic;
                    li.style.lineHeight = '20px';
                    li.style.borderBottom = 'solid 1px #cccccc';
                    li.style.minHeight = '40px';
                    li.style.margin = '2px';
                    li.appendChild(lnl);
                    li.appendChild(lal);
                    resultUl.appendChild(li);

                    li.onclick = function (evt) {
                        if (helper.findChoice == 'address') {//地址查询
                            helper.zoomToAddress(this, evt);
                        }

                        if (helper.findChoice == 'project') {//项目查询
                            helper.zoomToProject(this, evt);
                        }
                    }

                }
            }

            div.appendChild(countDiv);
            div.appendChild(resultDiv);
            resultDiv.appendChild(resultUl);

 

            if (dist.isIphone() || dist.isIpad() || dist.isAndroid()) {
                new iScroll(resultUl);
            } else {
                new vScroller(resultUl);
            }


        };

        //地址地位
        this.zoomToAddress = function (obj, evt) {
            var graphic = evt.currentTarget.graphic;

            $('.rsLi').css('background', 'white');
            obj.style.background = '#5eb2cb';

            var cPoint = graphic.geometry;

            helper.isAddressResult = false;
            distMapHelper.zoomToGeometry(cPoint, 0); //定位到所选收藏地址   
            map.infoWindow.hide();
            map.graphics.add(graphic); //高亮显示项目点
            //面板缩回
            dist.desktop.controlPanel.goback();
        };


        //项目、地址定位
        this.zoomToProject = function (obj, evt) {
            var graphic = evt.currentTarget.graphic;

            $('.rsLi').css('background', 'white');
            obj.style.background = '#5eb2cb';
            
            var cPoint = graphic.geometry;

            helper.isAddressResult = false;
            distMapHelper.zoomToGeometry(cPoint, 0); //定位到项目点
            map.infoWindow.hide();
            map.graphics.add(graphic); //高亮显示项目点
            //面板缩回
            dist.desktop.controlPanel.goback();
        };

        //设置项目、地址查询参数
        this.setProjectSearchParm = function (kw, type,center) {
            results = [];
            //初始化全局定位范围
            helper.zoomPolygon = new esri.geometry.Polygon(map.spatialReference);
            //根据类型，设置查询参数
            if (type == 'project') {
                helper.queryParams.url = dist.desktop.projectQueryParam.url;
                helper.queryParams.queryFields = dist.desktop.projectQueryParam.fields;
                helper.queryParams.layerIds = dist.desktop.projectQueryParam.layers;
                helper.queryParams.queryContent = kw;

                if(helper.isAddressResult){
                    helper.queryParams.rangeCircle = new esri.geometry.Circle(center);
                    helper.queryParams.rangeCircle.radius = 1000;
                }

            }
            else if (type == 'address') {
                helper.queryParams.url = dist.desktop.addressQueryParam.url;
                helper.queryParams.queryFields = dist.desktop.addressQueryParam.fields;
                helper.queryParams.layerIds = dist.desktop.addressQueryParam.layers;
                helper.queryParams.queryContent = kw;
            }
            //重置为0
            helper.queryCount = 0;
            //设置查询次数
            helper.sumCount = helper.queryParams.layerIds.length;
            //开始查询
            helper.doQueryTask(helper.queryParams);
        };


        //项目查询和定位查询
        this.doQueryTask = function (queryParams) {
            if (helper.queryCount >= helper.sumCount) {
                //查询完成
                helper.queryCompleted();
            } else {
                //拼接查询字断，模糊查询
                var where = "";
                var split = "";

                for (var i = 0; i < queryParams.queryFields.length; i++) {
                    var queryField = queryParams.queryFields[i];
                    var queryContent = queryParams.queryContent;
                    where += split + queryField + " like " + "'%" + queryContent + "%'";
                    split = " or ";
                }
                //拼接url
                var queryUrl = queryParams.url + "/" + queryParams.layerIds[helper.queryCount];

                var queryTask = new esri.tasks.QueryTask(queryUrl);
                var query = new esri.tasks.Query();
                query.outSpatialReference = map.spatialReference;
                if(helper.isAddressResult){
                    query.where = helper.queryParams.queryContent;
                    query.geometry = helper.queryParams.rangeCircle;
                    query.spatialRelationship = esri.tasks.Query.SPATIAL_REL_INTERSECTS;
                }else
                    query.where = where;
                query.returnGeometry = true;
                query.outFields = ["*"];

                //Execute task and call showResults on completion
                queryTask.execute(query, helper.showQueryResults, helper.queryErrorHandler);
            }
            helper.queryCount++;
        };

        //查询成功
        this.showQueryResults = function (featureSet) {
            var point, pExtent;
            var symbol;
            //获取展示字段名称
            var displayFieldName = helper.queryParams.queryFields[0];

            //循环处理查询结果 featureSet.features.length
            for (var i = 0; i < featureSet.features.length; i++) {
                var obj = [];
                var graphic = featureSet.features[i];
                var attributes = graphic.attributes;
                var displayFieldValue = attributes[displayFieldName];

                var InfoTemplate = null;
                if(helper.findChoice=="project"){
                    //构建信息属性框
                    InfoTemplate = helper.initInfoTemplate(featureSet, graphic, displayFieldValue);
                }else {
                    //构建信息属性框
                    InfoTemplate = helper.initInfoTemplate(featureSet, graphic, displayFieldValue);
                }

                var cPoint;
                if (graphic.geometry.type == "point") {
                    cPoint = new esri.geometry.Point();
                    cPoint.x = graphic.geometry.x;
                    cPoint.y = graphic.geometry.y;
                    cPoint.spatialReference = map.spatialReference;
                } else {
                    cPoint = graphic.geometry.getExtent().getCenter();
                    //添加当前geometry边界
                    helper.zoomPolygon.addRing(graphic.geometry.rings[0]);
                }

                //创建气泡图标
                var pictureSymbol = null;
                var pictureGraphic = null;

                if (helper.findChoice == 'address') {
                    pictureSymbol = new esri.symbol.PictureMarkerSymbol("images/location1.png", 30, 34);
                    pictureGraphic = new esri.Graphic(cPoint, pictureSymbol, attributes, InfoTemplate);
                    map.graphics.add(pictureGraphic);
                }else {
                    pictureSymbol = new esri.symbol.PictureMarkerSymbol("images/location0.png", 30, 34);
                    pictureGraphic = new esri.Graphic(cPoint, pictureSymbol, attributes, InfoTemplate);
                }

                obj.displayName = displayFieldValue;
                obj.graphic = pictureGraphic;
                results.push(obj);
            }
            //继续查询
            helper.doQueryTask(helper.queryParams);
        };

        //查询失败
        this.queryErrorHandler = function (error) {
            console.log(error.message);
            //继续查询
            helper.doQueryTask(helper.queryParams);
        };

        //查询完成
        this.queryCompleted = function () {
            if (helper.findChoice == 'project') {
                if(helper.isAddressResult){
                    if(helper.currentCircleGraphic!=null){
                        map.graphics.remove(helper.currentCircleGraphic);
                    }

                    var sfs = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0, 0.7]), 1), new dojo.Color([151, 219, 20, .7]));
                    helper.currentCircleGraphic = new esri.Graphic(helper.queryParams.rangeCircle, sfs);
                    map.graphics.add(helper.currentCircleGraphic);

                    helper.findChoice ='address';
                }
                var resultDiv = document.getElementById('searchResultContainer');
                helper.setSearchResultList(resultDiv);
                dist.desktop.controlPanel.show('searchResultContainer');
            }else if(helper.findChoice == 'address'){
                //if(results.length>0){
                //    helper.isAddressResult = true;
                //}else {
                //    helper.isAddressResult = false;
                //}
            }
            //重置查询参数
            helper.queryParams = [];
        };

        //设置查询容器
        this.setSearchDiv = function (div) {
            div.style.width = '100%';
            div.style.height = '30px';
            div.style.position = 'absolute';
            div.style.textAlign = 'center';
            div.style.top = '10px';


            catalogProBtn = document.createElement('DIV');
            catalogProBtn.style.border = "solid 1px #99CCCC";
            catalogProBtn.style.cursor = 'pointer';
            catalogProBtn.style.display = 'inline-block';
            catalogProBtn.style.color = 'white';
            catalogProBtn.style.width = '30px';
            catalogProBtn.style.height = '22px';
            catalogProBtn.style.lineHeight = '22px';
            catalogProBtn.style.fontSize = '13px';
            catalogProBtn.style.backgroundColor = 'rgba(60,196,75,1)';
            catalogProBtn.style.padding = '2px 5px';
            catalogProBtn.innerText = '项目';

            catalogBtn = document.createElement('DIV');
            catalogBtn.style.cursor = 'pointer';
            catalogBtn.style.border = "solid 1px #99CCCC";
            catalogBtn.style.display = 'inline-block';
            catalogBtn.style.color = "gray";
            catalogBtn.style.width = '30px';
            catalogBtn.style.height = '22px';
            catalogBtn.style.lineHeight = '22px';
            catalogBtn.style.fontSize = '13px';
            catalogBtn.style.backgroundColor = 'white';
            catalogBtn.style.padding = '2px 5px';
            catalogBtn.style.marginLeft = '-1px';
            catalogBtn.style.marginRight = '2px';
            catalogBtn.innerText = '定位';

            catalogBtn.onclick = function () {
                catalogBtn.style.backgroundColor = 'rgba(60,196,75,1)';
                catalogBtn.style.color = "white";
                catalogProBtn.style.backgroundColor = 'white';
                catalogProBtn.style.color = "gray";
                helper.findChoice = 'address';
                keyWordInput.placeholder = '请输入地址名称';
                map.infoWindow.hide();
                map.graphics.clear();
                helper.isAddressResult = false;
                //面板缩回
                dist.desktop.controlPanel.goback();
            }

            catalogProBtn.onclick = function () {
                catalogProBtn.style.backgroundColor = 'rgba(60,196,75,1)';
                catalogProBtn.style.color = "white"
                catalogBtn.style.backgroundColor = 'white';
                catalogBtn.style.color = 'gray';
                helper.findChoice = 'project';
                keyWordInput.placeholder = '请输入项目名称';
                map.infoWindow.hide();
                map.graphics.clear();
                helper.isAddressResult = false;
                //面板缩回
                dist.desktop.controlPanel.goback();
            }

            //var shutiaoBtn = document.createElement('DIV');
            //shutiaoBtn.style.background = 'url("images/shutiao_36.png") no-repeat ';
            //shutiaoBtn.style.display = 'inline-block';
            //shutiaoBtn.style.verticalAlign = 'middle';
            //shutiaoBtn.style.width = '35px';
            //shutiaoBtn.style.height = '35px';
            //shutiaoBtn.style.margin = '0 0 4px -22px';

            var shutiaoBtn = document.createElement('DIV');
            shutiaoBtn.style.display = 'inline-block'
            shutiaoBtn.style.borderLeft = 'dashed 2px #99CCCC';
            shutiaoBtn.style.verticalAlign = 'middle';
            shutiaoBtn.style.marginLeft = '2px';
            shutiaoBtn.style.width = '2px';
            shutiaoBtn.style.height = '25px';

            keyWordInput = document.createElement('INPUT');
            keyWordInput.type = 'text';
            keyWordInput.placeholder = '请输入项目名称';
            keyWordInput.style.border = 'solid 1px #99CCCC';
            keyWordInput.style.backgroundColor = "white";
            keyWordInput.style.bottom = '0px';
            keyWordInput.style.width = '50%';
            keyWordInput.style.height = '24px';
            keyWordInput.style.lineHeight = '24px';
            keyWordInput.style.color = 'gray';
            keyWordInput.style.fontSize = '13px';

            searchBtn = document.createElement('DIV');
            searchBtn.style.background = 'url("images/find.png") no-repeat center';
            searchBtn.style.backgroundSize = '25px 25px';
            searchBtn.style.cursor = 'pointer';
            searchBtn.style.display = 'inline-block';
            searchBtn.style.verticalAlign = 'middle';
            searchBtn.style.marginLeft = '5px';
            searchBtn.style.width = '25px';
            searchBtn.style.height = '25px';
            //searchBtn.style.marginBottom = '4px';

            div.appendChild(catalogProBtn);
            div.appendChild(catalogBtn);
            //div.appendChild(shutiaoBtn);
            div.appendChild(keyWordInput);
            div.appendChild(searchBtn);

            searchBtn.onclick = function (evt) {
                var kw = keyWordInput.value;
                if (kw && kw != '') {
                    helper.isAddressResult = false;
                    dist.desktop.currentScreen.map.esrimap.graphics.clear();
                    //三证查询、地名查询
                    helper.setProjectSearchParm(kw, helper.findChoice); //初始化项目查询参数
                }
            }

        };


        //设置属性信息模板
        this.initInfoTemplate = function (results, graphic, key) {
            var content = "";
            var infoTemplate = new esri.InfoTemplate();

            //初始化窗体样式
            helper.initInfoTemplateStyle();

            var title = "<b>" + key + "</b>";
            infoTemplate.setTitle(title);
            {
                //开始构建一个table liuxb
                content += "<table class='imagetable'><tr><th>名称</th><th>属性</th></tr>";
                for (var i = 0; i < results.fields.length; i++) {
                    var fieldName = results.fields[i].name;
                    if (fieldName.indexOf("OBJECTID") != -1 || fieldName.indexOf("SHAPE") != -1) {
                        continue;
                    }
                    var fieldAlias = results.fields[i].alias;
                    var value = graphic.attributes[fieldName];
                    //构建一行tr liuxb
                    content += "<tr><td>" + fieldAlias + "</td><td>${" + fieldName + "}</td></tr>";
                }
                //结束一个table liuxb
                content += "</table>";
                infoTemplate.setContent(content)
            }
            return infoTemplate;
        };

        //设置属性信心模板样式
        this.initInfoTemplateStyle = function () {
            //修改InfoWindow的Title背景色
            var infoWindowTitle = $(".titlePane")[0];
            infoWindowTitle.style.backgroundColor = "#0099FF";
            infoWindowTitle.style.lineHeight = "35px";
            //隐藏InfoWindow的最大化按钮
            var maxBtn = $(".maximize")[0];
            maxBtn.hidden = true;
            //调整InfoWindow的关闭按钮位置
            var closeBtn = $(".close")[0];
            closeBtn.style.top = "6px";
            closeBtn.style.right = "6px";


            //helper.showPopup();
        };
        //属性信息框关闭
        this.showPopup = function () {
            var popup = $(".esriPopup")[0];
            if (popup)
                popup.hidden = false;
        };

    }

})()

