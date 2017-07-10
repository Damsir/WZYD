var sumArea = 0;
(function() {
    GraphicAttributeWidgetHelper = function(attribute) {
        if (!attribute) return;

        this.setAttributeList = function(ul) {
           
            ul.innerHTML = '';
            var fields = [];
            for (var field in attribute) {
                fields.push(field);
            }

            fields.sort();
            fields.reverse();


            if (lotFlag == true) { //地块面积分析显示查询的地块面积
                for (var i = 0; i < fields.length; i++) {
                    var fieldName = fields[i];
                    if (fieldName.toUpperCase() != 'SHAPE_AREA')
                        continue;
                    // var fieldDiv = document.createElement('DIV');
                    //fieldDiv.id = 'areaId';
                    var fieldDiv = document.getElementById('areaValue');
                    // var nameSpan = document.createElement('SPAN');
                    if (fieldName.toUpperCase() == 'SHAPE_AREA')
                    { fieldName = '面积' }
                    //   nameSpan.innerText = fieldName;

                    var area = parseFloat(attribute[fields[i]]);
                    sumArea = parseFloat(sumArea) + area;
                    sumArea = Math.abs(sumArea).toFixed(2); //取小数两位
                    var resultArea;
                    if (sumArea > 1000000) {
                        resultArea = Math.round(sumArea / 1000000);
                        fieldDiv.innerText = fieldName + ":" + resultArea + ' 平方千米';
                    }
                    else {
                        fieldDiv.innerText = fieldName + ":" + sumArea + ' 平方米';
                    }
                    //fieldDiv.appendChild(nameSpan);
                    //ul.appendChild(fieldDiv);

                }
            }

            if (lotFlag == false) {//显示i查询信息
                for (var i = 0; i < fields.length; i++) {
                    var fieldName = fields[i];
                    if (fieldName.toUpperCase() == 'OBJECTID' || fieldName.toUpperCase() == 'SHAPE'
                     || fieldName.toUpperCase() == 'SHAPE_AREA' || fieldName.toUpperCase() == 'SHAPE_LENGTH')
                        continue;
                    var fieldDiv = document.createElement('DIV');
                    var nameSpan = document.createElement('SPAN');
                    nameSpan.innerText = fieldName;
                    fieldDiv.innerText = attribute[fields[i]];
                    fieldDiv.appendChild(nameSpan);
                    ul.appendChild(fieldDiv);
                }
            }


        }
    }

})()