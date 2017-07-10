/******************************************
////////////////////////////////////////////////////////////////////////////////
//
//
//Copyright(C) 2012 上海数慧系统技术有限公司
//版权所有。
//文件名：DistFindParametersHelper
//文件功能描述：查找查询参数辅助帮手
//
//创建标识：Chen Youqing
//创建时间：2012-4-26
////////////////////////////////////////////////////////////////////////////////
******************************************/

///<imports>各种引用</imports>
dojo.require("esri.tasks.find");

///<summary>查找查询参数辅助帮手</summary>
///<returns>FindParameters</returns>
function DistFindParametersHelper() {
    var targetFindParameters = new esri.tasks.FindParameters();

    ///<summary>识别查询参数</summary>
    ///<returns>FindParameters</returns>
    this.findParameters = targetFindParameters;

    ///<summary>是否模糊查询</summary>
    ///<returns>Boolean</returns>
    this.contains = function (myContains) {
        if (arguments.length == 0) {
            return targetFindParameters.contains;
        }
        else {
            targetFindParameters.contains = myContains;
        }
    }

    ///<summary></summary>
    ///<returns>DynamicLayerInfos[]</returns>
    this.dynamicLayerInfos = function (value) {
        if (arguments.length == 0) {
            return targetFindParameters.dynamicLayerInfos;
        }
        else {
            targetFindParameters.dynamicLayerInfos = value;
        }
    }


    ///<summary>设置过滤图层条件</summary>
    ///<returns>String[]</returns>
    this.layerDefinitions = function (value) {
        if (arguments.length == 0) {
            return targetFindParameters.layerDefinitions;
        }
        else {
            targetFindParameters.layerDefinitions = value;
        }
    }

    ///<summary>指定要查找的图层id数组</summary>
    ///<returns>Number[]</returns>
    this.layerIds = function (value) {
        if (arguments.length == 0) {
            return targetFindParameters.layerIds;
        }
        else {
            targetFindParameters.layerIds = value;
        }
    }

    ///<summary>最大允许偏移量</summary>
    ///<returns>Number</returns>
    this.maxAllowableOffset = function (value) {
        if (arguments.length == 0) {
            return targetFindParameters.maxAllowableOffset;
        }
        else {
            targetFindParameters.maxAllowableOffset = value;
        }
    }

    ///<summary>输出几何的空间参考</summary>
    ///<returns>SpatialReference</returns>
    this.outSpatialReference = function (value) {
        if (arguments.length == 0) {
            return targetFindParameters.outSpatialReference;
        }
        else {
            targetFindParameters.outSpatialReference = value;
        }
    }

    ///<summary>是否返回几何</summary>
    ///<returns>Boolean</returns>
    this.returnGeometry = function (value) {
        if (arguments.length == 0) {
            return targetFindParameters.returnGeometry;
        }
        else {
            targetFindParameters.returnGeometry = value;
        }
    }

    ///<summary>指定查找字段</summary>
    ///<returns>String[]</returns>
    this.searchFields = function (value) {
        if (arguments.length == 0) {
            return targetFindParameters.searchFields;
        }
        else {
            targetFindParameters.searchFields = value;
        }
    }

    ///<summary>查找关键字</summary>
    ///<returns>String</returns>
    this.searchText = function (value) {
        if (arguments.length == 0) {
            return targetFindParameters.searchText;
        }
        else {
            targetFindParameters.searchText = value;
        }
    }

}