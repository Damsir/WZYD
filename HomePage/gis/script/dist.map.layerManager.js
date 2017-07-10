(function(distmap) {
    //图层管理
    distmap.layerManager = function(sc) {
        var helper = this;
        //this.curLryId = '';
        this.curLi = null;
        this.ele = document.createElement('DIV');
        this.ele.setAttribute('i', sc.index);
        this.ele.style.display = 'none';
        this.eleFlag = Math.random();
        this.ele.innerHTML = '<div class="layer-titlebar" id="layer-titlebar-' + this.eleFlag + '"><div class="layer-address" id="layer-address-' + this.eleFlag + '"><div>根目录</div><div></div></div></div><div class="layer-listbox"><div class="layer-list-scroll"><ul id="layerlist-' + this.eleFlag + '"></ul></div></div>' +
                                '<div id="opacityBox' + this.eleFlag + '" class="opacityBox" style="display:none">' +
                                    '<div style="float:left; margin:10px;">透明度</div>' +
                                    '<div id="layersOpacityline' + this.eleFlag + '" class="layersOpacityline">' +
                                        '<div id="layersOpacitylineButton' + this.eleFlag + '" class="layersOpacitylineButton"></div>' +
                                    '</div>' +
                                    '<div style="float:left;display:none;">' +
                                        '<span id="lblOpacityValue' + this.eleFlag + '">100%</span>' +
                                    '</div>' +
                                '</div>' +
                            '<div id="layerStyle' + this.eleFlag + '" class="widget-button">图层样式</div>';
        this.ele.className = 'layer-container';
        document.body.appendChild(this.ele);
        this.titleBar = document.getElementById('layer-titlebar-' + this.eleFlag);

        //this.mapSeleceter = document.getElementById('layer-map-sel-' + this.eleFlag);

        this.addressBar = document.getElementById('layer-address-' + this.eleFlag);
        this.address0 = this.addressBar.children[0];
        this.address1 = this.addressBar.children[1];
        var $s = this;
        this.opacityLine = dist.$g('layersOpacityline' + this.eleFlag);
        this.layersOpacitylineButton = $(document.getElementById('layersOpacitylineButton' + this.eleFlag));
        this.lblOpacityValue = document.getElementById('lblOpacityValue' + this.eleFlag);
        this.opacityBox = dist.$g('opacityBox' + this.eleFlag);
        $(this.address0).touchlink().bind('touchend click', function() { $s.addressBarClickHandler(this); });
        $(this.address1).touchlink().bind('touchend click', function() { $s.addressBarClickHandler(this); });

        //this.mapSeleceter.addEventListener('change', function(event) { $s.changeMap(event); }, false);

        this.layerStyle = $(document.getElementById('layerStyle' + this.eleFlag)).touchlink().bind('touchend click', function() { $s.setLayerStyle(); });
        if (!dist.map.config.layerStyle)
            this.layerStyle.hide();
        this.owner = sc;
        //滚动条
        this.scroller = null;
        this.currentLayerId = -1;

        this.listUL = null;

        this.layerStack = new Array();
        this.layerStack.push({ id: '-1', name: '根目录' });

        var $s = this;
        this.lmVisibleLayers = [];

        //显示某一图层目录下的子图层
        this.show = function(layerId) {
            this.ele.style.display = 'block';
            if (undefined == layerId)
                layerId = this.currentLayerId;
            
            var themes = this.owner.map.theme;
            
            var ul = this.getListUL();
            ul.innerHTML = '';
            ul.style.top = '0px';
            this.currentLayerId = layerId;
            this.opacityBox.style.display = 'none';
            if (themes.length == 0)
                return false;
            var df = document.createDocumentFragment();

            //计算
            for (var j = 0; j < themes.length; j++) {
                var layers = themes[j].getChildLayers(layerId);
                for (var i = 0; i < layers.length; i++) {
                    var theLayer = layers[i];
                    var li = this.createLayerLi(theLayer,j,theLayer.subLayerIds != null);
                    if (!li)
                        continue;
                    if (theLayer.subLayerIds != null)
                        li.className = 'category';
                    df.appendChild(li);
                }
            }
            ul.appendChild(df);
            return true;
        };

        this.createLayerLi = function(lay,themeID,isCategory) {
            var li = document.createElement('li');
            li.setAttribute('layerid', lay.id);
            li.setAttribute('layername', lay.name);
            li.setAttribute('themeid', themeID);
            var eyeEle = document.createElement('DIV');
            var layerInfo = this.owner.map.theme[themeID].layers[lay.id];
            var visible = false;
            if (isCategory) {
                if (!layerInfo)
                    return;
                var layObj = this.owner.map.theme[themeID].layerObj;
                var visibleLayers = layObj.visibleLayers;

                var subLays = layerInfo.subLayerIds;
                if (null != subLays && subLays.length > 0) {
                    for (var i = 0; i < subLays.length; i++) {
                        var subLay = subLays[i];
                        if (visibleLayers.contains(subLay)) {
                            visible = true;
                            break;
                        }
                    }
                }
            }
            else {
                if (!layerInfo)
                    return;
                var layObj = this.owner.map.theme[themeID].layerObj;
                var visibleLayers = layObj.visibleLayers;
                if (visibleLayers.contains(lay.id))
                    visible = true;
                else
                    visible = false;
            }
            //根据已知添加可见属性
            layerInfo.visible = visible;

            if (visible) {
                eyeEle.className = 'layer-eye eye-selected';
            }
            else {
                eyeEle.className = 'layer-eye';
            }

            eyeEle.btnFlag = true;
            eyeEle.layerId = lay.id;
            eyeEle.themeId = themeID;
            if (dist.isIphone() || dist.isIpad() || dist.isAndroid()) {
                $(eyeEle).touchlink().bind('touchend', function() {
                    $s.eyeEleClickHandler(this);
                });
            }
            else {
                $(eyeEle).touchlink().bind('click', function() {
                    $s.eyeEleClickHandler(this);
                });
            }
            

            var layerText = document.createElement('DIV');
            var ln = lay.name;
            if (ln.length > 15)
                ln = ln.substring(0, 15) + '...';
            layerText.innerText = ln;

            layerText.className = 'layer-list-text';

            li.appendChild(eyeEle);

            if (isCategory) {
                var nextIcon = document.createElement('DIV');
                layerText.className = 'layer-list-text-category';
                nextIcon.className = 'layer-list-next';
                nextIcon.setAttribute('layerId', lay.id);
                nextIcon.setAttribute('layerName', lay.name);
                
                if (dist.isIphone() || dist.isIpad() || dist.isAndroid()) {
                    $(nextIcon).touchlink().bind('touchend', function() {
                        $s.nextEleClickHandler(this);
                    });
                }
                else {
                    $(nextIcon).touchlink().bind('click', function() {
                        $s.nextEleClickHandler(this);
                    });
                }
                li.appendChild(nextIcon);
            }
            li.appendChild(layerText);
            return li;
        };
        this.getListUL = function() {
            if (this.listUL)
                return this.listUL;
            this.listUL = document.getElementById('layerlist-' + this.eleFlag);
            var $s = this;
            $(this.listUL).dragList({ enableDrag: false, selectEnable: true, itemClick: function(sender) { $s.onListItemClick(sender); } });

            if (dist.isIphone() || dist.isIpad() || dist.isAndroid()) {
                this.scroller = new iScroll('layerlist-' + this.eleFlag);
            } else {
                this.scroller = new vScroller('layerlist-' + this.eleFlag);
            }
           
            return this.listUL;
        };

        this.updateSelector = function() {
            //this.mapSeleceter.innerHTML = '';
            //-1，最后一个是资源目录的配置，在这里不显示
            for (var i = 0; i < distmap.config.maps.length; i++) {
                if (distmap.config.maps[i].hidden)
                    continue;
                var n = distmap.config.maps[i].name;
                var op = new Option(n, i);
                op.selected = this.owner.map.name == n;
                //this.mapSeleceter.options[i] = op;
            }
            this.opacityBox.style.display = 'none';
        };

        this.updateSelector();

        this.selectedLayerId = -1;
        this.selectedThemeId = -1;

        //图层列表点击事件

        this.onListItemClick = function(sender) {

            var layerId = parseInt(sender[0].getAttribute('layerid'));
            var themeId = parseInt(sender[0].getAttribute('themeid'));
            this.selectedLayerId = layerId;
            this.selectedThemeId = themeId;

            var curLi = sender[0].firstChild;  //当前选择的图层

            var layerInfos = this.owner.map.theme[themeId].layers;
            var layerInfo = layerInfos[layerId];
            if (null == layerInfo.subLayerIds) {
                //this.layerStyle.show();
            }
            else {
                this.layerStyle.hide();
            }

            if (layerInfo.visible) {

                var opacity = 1;
                if (null == layerInfo.subLayerIds) {
                    var themeName = this.owner.map.theme[themeId].name;
                    var theLayer = this.owner.map.esrimap.getLayer(themeName);
                    opacity = theLayer.opacity;
                    //helper.curLryId = layerId;
                }
                else {
                    // helper.curLryId = layerInfo.subLayerIds;
                    var themeName = this.owner.map.theme[themeId].name;
                    var theLayer = this.owner.map.esrimap.getLayer(themeName);
                    opacity = theLayer.opacity;
                }


                this.layersOpacitylineButton.css({ left: opacity * 170 });
                this.lblOpacityValue.innerText = (opacity * 100) + '%';
                this.opacityBox.style.display = 'block';
            } else
                this.opacityBox.style.display = 'none';

        };

        this.nextEleClickHandler = function(sender) {
            var layerId = parseInt(sender.getAttribute('layerId'));
            var layerName = sender.getAttribute('layerName');
            this.selectedLayerId = layerId;

            if (this.show(layerId)) {
                this.layerStack.push({ id: layerId, name: layerName });
                this.updateAddressBar();
            }
            else {

            }
        };


        this.updateAddressBar = function() {
            var as = [this.address0, this.address1];
            for (var i = 0; i < as.length; i++) {
                as[i].style.display = 'none';
            }
            var j = as.length - 1;

            for (var i = this.layerStack.length - 1; i >= 0 && j >= 0; i--, j--) {
                var ag = as[j];
                ag.style.display = 'block';
                var ln = this.layerStack[i].name;
                if (ln.length > 8)
                    ln = ln.substring(0, 8) + '...';
                ag.innerText = ln;
                ag.setAttribute('i', i);
            }
        };

        this.addressBarClickHandler = function(sender) {
            var lsIndex = parseInt(sender.getAttribute('i'));
            if (lsIndex == this.layerStack.length - 1)
                return;
            else {
                var theLay = this.layerStack.pop();
                this.show(this.layerStack[this.layerStack.length - 1].id);
                this.layerStyle.hide();
                this.updateAddressBar();
            }
        };

        this.showRootCategory = function() {
            this.layerStack = [];
            this.layerStack.push({ id: '-1', name: '根目录' });
            this.show(-1);
            this.layerStyle.hide();
            this.address1.style.display = 'none';
        };

        this.eyeEleClickHandler = function(sender) {
            var layerId = sender.layerId;
            var themeId = sender.themeId;
            var layerInfos = this.owner.map.theme[themeId].layers;
            var layerInfo = layerInfos[layerId];
            var layerObj = this.owner.map.theme[themeId].layerObj;
            if (layerInfo && layerObj) {
                this.lmVisibleLayers = layerObj.visibleLayers;
                layerInfo.themeId = themeId;
                this.setLayerInfoVisible(layerObj, layerInfo,layerInfo.visible);
                sender.className = layerInfo.visible ? 'layer-eye eye-selected' : 'layer-eye';
            }
        };

        //设置图层的显示
        this.setLayerInfoVisible = function (layerObj, layerInfo,visible) {
            if (!layerInfo)
                return;
            layerInfo.visible = !visible;
            var subLayerIds = layerInfo.subLayerIds;
            if (layerObj) {
                if (subLayerIds && subLayerIds.length > 0) {
                    for (var i = 0; i < subLayerIds.length; i++) {
                        var subLayerId = subLayerIds[i];
                        var subLayerInfo = layerObj.layerInfos[subLayerId];
                        $s.setLayerInfoVisible(layerObj, subLayerInfo,visible);
                    }
                }

                if (visible) {
                    if (this.lmVisibleLayers.contains(layerInfo.id)) {
                        this.lmVisibleLayers = $s.removeObjArray(this.lmVisibleLayers, layerInfo.id);
                    }
                }
                else {
                    this.lmVisibleLayers.push(layerInfo.id);
                }

                layerObj.setVisibleLayers(this.lmVisibleLayers);
            }
        };

        this.changeMap = function(e) {
            var v = this.mapSeleceter.value;
            var mp = distmap.cloneMap(parseInt(v));
            dist.desktop.currentScreen.setMap(mp);
        };

        this.setCureentLayerOpacity = function(o) {
            if (this.selectedLayerId != -1) {
                var layerInfo = this.owner.map.theme[this.selectedThemeId].layers[this.selectedLayerId];
                //首先获得当前服务名称
                var themeName = this.owner.map.theme[this.selectedThemeId].name;
                //先获得图层
                var theLayer = this.owner.map.esrimap.getLayer(themeName);
                if (theLayer)
                    theLayer.setOpacity(o);
                //if (null == layerInfo.subLayerIds) {
                //    //首先获得当前服务名称
                //    var themeName = this.owner.map.theme[this.selectedThemeId].name;
                //    //先获得图层
                //    var theLayer = this.owner.map.esrimap.getLayer(themeName);
                //    if (theLayer)
                //        theLayer.setOpacity(o);
                //} else {
                //    for (var i = 0; i < layerInfo.subLayerIds.length; i++) {
                //        var theLayer = this.owner.map.esrimap.getLayer("layer" + layerInfo.subLayerIds[i]);
                //        theLayer.setOpacity(o);
                //    }
                //}
            }
        }

        this.startX = 0;
        this.oldLeft = 0;

        this.touchIsDown = false;

        this.opacityLine.addEventListener('touchstart', function(e) {
            var touch = e.touches[0];
            var px = touch.pageX;
            $s.opacityLineTapStartHandler(px, e);
        });

        this.opacityLine.addEventListener('mousedown', function(e) {
            $s.opacityLineTapStartHandler(e.pageX, e);
        });

        this.opacityLineTapStartHandler = function(px, e) {
            var toX = e.offsetX;

            this.startX = px
            this.touchIsDown = true;
            if (e.srcElement.id != 'layersOpacitylineButton' + this.eleFlag) {
                this.layersOpacitylineButton[0].style.left = toX + "px"; ;
                this.lblOpacityValue.innerText = parseInt(toX / 170 * 100) + "%";
            }
            this.layersOpacitylineButton[0].style.backgroundColor = '#97db14';
            this.oldLeft = this.layersOpacitylineButton.position().left;
        }

        this.opacityLine.addEventListener('touchmove', function(e) {
            $s.opacityLineMouseMoveHandler(e.touches[0].pageX);
        });
        this.opacityLine.addEventListener('mousemove', function(e) {
            $s.opacityLineMouseMoveHandler(e.pageX);
        });

        this.opacityLineMouseMoveHandler = function(px) {
            if (this.touchIsDown) {
                var toX = (this.oldLeft + (px - this.startX));
                if (toX < 0)
                    toX = 0;
                else if (toX > 170)
                    toX = 170;
                this.lblOpacityValue.innerText = parseInt(toX / 170 * 100) + "%";
                this.layersOpacitylineButton[0].style.left = toX + "px";
            }
        }

        $(this.opacityLine).bind('touchend mouseup mouseout', function(e) {
            $s.opacityLineMouseEndHanlder();
        });

        this.opacityLineMouseEndHanlder = function() {
            if (!this.touchIsDown)
                return;
            this.touchIsDown = false;
            this.layersOpacitylineButton[0].style.backgroundColor = 'green';
            this.setCureentLayerOpacity(this.layersOpacitylineButton.position().left / 170);
        };

        this.setLayerStyle = function () {
            if (this.selectedThemeId != -1) {
                //首先获得当前服务名称
                var themeName = this.owner.map.theme[this.selectedThemeId].name;
                //先获得图层
                var layer = this.owner.map.esrimap.getLayer(themeName);
                if (layer)
                    layer.setVisibility(false);
                else {
                    return;
                }
                var featureLayer = this.owner.map.esrimap.getLayer("style_" + this.selectedThemeId + "_" + this.selectedLayerId);
                if (featureLayer) {
                    this.styleLayerAdded(featureLayer);
                } else {
                    var newLayer = {};
                    newLayer.url = layer.url + '/' + this.selectedLayerId;
                    newLayer.id = 'style_' + this.selectedThemeId + '_' + this.selectedLayerId;
                    newLayer.type = 'FeatureLayer';
                    newLayer.visible = true;
                    newLayer.alpha = 1;
                    featurelayer = this.owner.loader.addLayerByLayerData(newLayer, this.owner.map.esrimap);
                }
            }
        };

        this.styleLayerAdded = function (lay) {
            var geometryType = lay.geometryType;
            var featurelayerHelper = new dist.gis.featureLayerHelper(lay);
            if (geometryType == 'esriGeometryPoint') {
                var size = featurelayerHelper.getPointSymbolSize();
                size = Math.ceil(size);
                $('#pointSize').html(size);
                var pointDiv = document.getElementById('pointSymbolContainer');
                pointDiv.setAttribute('layerId', lay.id);
                dist.desktop.controlPanel.show('pointSymbolContainer');
            }
            else if (geometryType == 'esriGeometryPolyline') {
                var size = featurelayerHelper.getPolylineSymbolWidth();
                size = Math.ceil(size);
                $('#polylineSize').html(size);
                var polylineDiv = document.getElementById('polylineSymbolContainer');
                polylineDiv.setAttribute('layerId', lay.id);
                dist.desktop.controlPanel.show('polylineSymbolContainer');
            }
            else if (geometryType == 'esriGeometryPolygon') {
                if(!featurelayerHelper.initSymbol)
                    return;
                var polygonDiv = document.getElementById('polygonSymbolContainer');
                polygonDiv.setAttribute('layerId', lay.id);
                dist.desktop.controlPanel.show('polygonSymbolContainer');
            }
        };

        //移除不可见图层
        this.removeObjArray = function (objList, item) {
            var showLayerID = [];
            for (var i = 0; i < objList.length; i++) {
                if (objList[i] != item)
                    showLayerID.push(objList[i]);
            }
            return showLayerID;
        };

        //重写contains函数
        Array.prototype.contains = function (obj) {
            var i = this.length;
            while (i--) {
                if (this[i] === obj) {
                    return true;
                }
            }
            return false;
        };
    }

})(dist.map);