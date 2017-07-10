(function () {
    dist.gis.graphicAttributeWidgetHelper = function (attribute) {
        if (!attribute) return;
        this.setAttributeList = function (ul) {

            ul.innerHTML = '';
            var fields = [];
            for (var field in attribute) {
                fields.push(field);
            }
            fields.sort();
            fields.reverse();

            //显示i查询信息
            for (var i = 0; i < fields.length; i++) {
                var fieldName = fields[i];
                if (fieldName.toUpperCase() == 'OBJECTID' || fieldName.toUpperCase() == 'SHAPE'
                 || fieldName.toUpperCase() == 'SHAPE_AREA' || fieldName.toUpperCase() == 'SHAPE_LENGTH'
                 || fieldName.toUpperCase() == 'SHAPE.AREA' || fieldName.toUpperCase() == 'SHAPE.LEN')
                    continue;

                var fieldDiv = document.createElement('DIV');
                var nameSpan = document.createElement('SPAN');
                nameSpan.innerText = fieldName;
                var val = attribute[fields[i]];
                if (val == 'Null')
                    val = '';
                fieldDiv.innerText = val;

                fieldDiv.appendChild(nameSpan);
                ul.appendChild(fieldDiv);
            }
        }
    }

})()