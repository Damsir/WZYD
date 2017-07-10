/******************************************
////////////////////////////////////////////////////////////////////////////////
//
//
//Copyright(C) 2012 上海数慧系统技术有限公司
//版权所有。
//文件名：DistIdentifyTaskHelper
//文件功能描述：识别查询任务辅助帮手
//
//创建标识：Chen Youqing
//创建时间：2012-4-1
////////////////////////////////////////////////////////////////////////////////
******************************************/

///<imports>各种引用</imports>
dojo.require("esri.tasks.identify");

///<summary>识别查询辅助帮手</summary>
///<param name="url" type="String">需要识别的地图服务url</param>
///<param name="options" type="Object">参数，可不填
///<childParam key="gdbVersion" type="String">指定geodatabase版本</childParam>
///</param>
///<returns>没有返回值</returns>
function DistIdentifyTaskHelper(url, options) {
    var targetIdentifyTask;
    if (arguments.length == 1) {
        targetIdentifyTask = new esri.tasks.IdentifyTask(url);
    }
    else {
        targetIdentifyTask = new esri.tasks.IdentifyTask(url, options);
    }

    ///<summary>identifyTask</summary>
    ///<returns>IdentifyTask</returns>
    this.identifyTask = targetIdentifyTask;

    ///<summary>执行识别查询</summary>
    ///<param name="idPa" type="IdentifyParameters">IdentifyParameters识别查询参数</param>
    ///<param name="callBack" type="function">查询成功返回函数</param>
    ///<param name="errBack" type="function">查询出错返回函数</param>
    ///<returns>layer</returns>
    this.execute = function(idPa, callBack, errBack) {
        targetIdentifyTask.execute(idPa, callBack, errBack);
    }

}