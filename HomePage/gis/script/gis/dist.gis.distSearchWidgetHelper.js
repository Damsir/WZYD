(function() {
    DistSearchWidgetHelper = function() {
        var helper = this;
        var catalogBtn;
        var keyWordInput;
        var searchBtn;
        var maxRecords = 1000;
        var results = [];

        //用关键字查询地名
        this.searchAddressByKeyWord = function(keyWord) {
            $.ajax({
                type: 'POST',
                url: 'proxy/AddressQueryHandler.ashx',
                data: { keyWord: keyWord, maxRecords: maxRecords, type: "text" },
                success: function(rs) {
                    results = eval(rs);
                    var resultDiv = document.getElementById('searchResultContainer');
                    helper.setSearchResultList(resultDiv);
                    dist.desktop.controlPanel.show('searchResultContainer');

                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    alert(r);
                }
            });
        }

        //用geometry坐标串查询地名
        this.searchAddressByGeometry = function(coords) {
            $.ajax({
                type: 'POST',
                url: 'proxy/AddressQueryHandler.ashx',
                data: { coords: coords, maxRecords: maxRecords, type: "geometry" },
                success: function(rs) {

                },
                error: function(r, s, t) {

                }
            });
        }

        //展示结果列表
        this.setSearchResultList = function(div) {
            div.innerHTML = '';
            var esrimap = dist.desktop.currentScreen.map.esrimap;
            var distMapHelper = new DistMapHelper(esrimap);

            var countDiv = document.createElement('DIV');
            countDiv.style.height = '40px';
            countDiv.style.lineHeight = '40px';
            countDiv.style.fontWeight = 'bold';
            countDiv.style.fontSize = '20px';
            var countStr = '为您查到 ';
            countStr += results.length;
            countStr += ' 个结果。';
            countDiv.innerText = countStr;

            var resultUl = document.createElement('UL');
            resultUl.style.listStyle = 'none';
            resultUl.style.margin = '5px';
            resultUl.style.padding = '0px';
            if (results && results.length > 0) {
                for (var i = 0; i < results.length; i++) {
                    var lnl = document.createElement('LABEL');
                    lnl.style.display = 'block';
                    lnl.style.fontWeight = 'bold';
                    lnl.style.fontSize = '20px';
                    lnl.style.padding = '0px';
                    lnl.style.margin = '0px';
                    lnl.innerText = results[i].locateName;
                    var lal = document.createElement('LABEL');
                    lal.style.display = 'block';
                    lal.style.color = 'gray';
                    lal.style.fontSize = '14px';
                    lal.style.padding = '0px';
                    lal.style.margin = '0px';
                    lal.innerText = results[i].locateAddress;

                    var li = document.createElement('LI');
                    li.location = results[i];
                    li.style.borderBottom = 'solid 1px #cccccc';
                    li.style.height = '50px';
                    li.style.margin = '2px';
                    li.appendChild(lnl);
                    li.appendChild(lal);
                    resultUl.appendChild(li);

                    li.onclick = function(evt) {
                        var location = evt.currentTarget.location;
                        var lyType = location.lyType;
                        if (lyType == "Polygon") {
                            var pXY = "";
                            var point;
                            var points = location.locateCoordinate.split(' ');
                            var polygon = new esri.geometry.Polygon(esrimap.spatialReference);

                            for (var i = 0; i < points.length; i++) {
                                pXY += "[" + points[i] + "]";
                                if (i < points.length - 1) {
                                    pXY += ",";
                                }
                            }
                            var polygonJson = eval("[" + pXY + "]");
                            polygon.addRing(polygonJson);
                            point = polygon.getExtent().getCenter();
                            alert(point.x+","+point.y);
                        }
                        else {
                            Number(location.locateCoordinate);
                            point = new esri.geometry.Point(Number(location.locateCoordinate), Number(location.locateCoordinateY), esrimap.spatialReference);
                        }
                        //  point=new esri.geometry.Point([495155.353523094, 325674.1954126558])
                        var sms = new esri.symbol.PictureMarkerSymbol('images/dtz2.png', 17, 30);
                        distMapHelper.zoomToGeometry(point);
                        distMapHelper.highLightOnGeometry(point, sms);
                    }
                }
            }

            div.appendChild(countDiv);
            div.appendChild(resultUl);

        }

        //设置查询容器
        this.setSearchDiv = function(div) {
            div.style.borderBottom = 'solid 2px #cccccc';
            div.style.width = '70%';
            div.style.height = '40px';
            div.style.lineHeight = '40px';
            div.style.position = 'absolute';
            div.style.paddingLeft = '80px';
            div.style.paddingBottom = '2px';
            div.style.top = '20px';
            div.style.left = '10%';
            div.style.opacity = '0.8';

            catalogBtn = document.createElement('DIV');
            catalogBtn.style.position = 'absolute';
            catalogBtn.style.bottom = '0px';
            catalogBtn.style.left = '10px';
            catalogBtn.style.color = '#cccccc';
            catalogBtn.style.fontWeight = 'bold';
            catalogBtn.style.width = '40px';
            catalogBtn.style.height = '40px';
            catalogBtn.style.lineHeight = '40px';
            catalogBtn.innerText = '地名';

            var shutiaoBtn = document.createElement('DIV');
            shutiaoBtn.style.background = 'url("images/shutiao_36.png") no-repeat ';
            shutiaoBtn.style.position = 'absolute';
            shutiaoBtn.style.bottom = '0px';
            shutiaoBtn.style.left = '30px';
            shutiaoBtn.style.width = '40px';
            shutiaoBtn.style.height = '40px';

            keyWordInput = document.createElement('INPUT');
            keyWordInput.type = 'text';
            keyWordInput.placeholder = '请输入地名';
            keyWordInput.style.position = 'absolute';
            keyWordInput.style.border = '0px';
            keyWordInput.style.backgroundColor = 'transparent';
            keyWordInput.style.bottom = '0px';
            keyWordInput.style.left = '80px';
            keyWordInput.style.width = '87%';
            keyWordInput.style.height = '40px';
            keyWordInput.style.lineHeight = '40px';
            keyWordInput.style.fontSize = '16px';

            searchBtn = document.createElement('DIV');
            searchBtn.style.background = 'url("images/find_32.png") no-repeat ';
            searchBtn.style.position = 'absolute';
            searchBtn.style.bottom = '0px';
            searchBtn.style.right = '2px';
            searchBtn.style.width = '40px';
            searchBtn.style.height = '40px';

            div.appendChild(catalogBtn);
            div.appendChild(shutiaoBtn);
            div.appendChild(keyWordInput);
            div.appendChild(searchBtn);

            searchBtn.onclick = function(evt) {
                var kw = keyWordInput.value;
                if (kw && kw != '') {
                    helper.searchAddressByKeyWord(kw);
                }
            }

        }

    }

})()