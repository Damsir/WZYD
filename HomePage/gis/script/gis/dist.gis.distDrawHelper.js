/******************************************
////////////////////////////////////////////////////////////////////////////////
//
//
//Copyright(C) 2012 上海数慧系统技术有限公司
//版权所有。
//文件名：DistDrawHelper
//文件功能描述：辅助帮助绘制点、线、面等
//
//创建标识：Chen Youqing
//创建时间：2012-3-31
////////////////////////////////////////////////////////////////////////////////
******************************************/

///<imports>各种引用</imports>
dojo.require("esri.toolbars.draw");

///<summary>绘制辅助帮手</summary>
///<param name="map" type="Map">将要绘制于此Map</param>
///<param name="options" type="Object">json格式对象，可不填
///<childParam key="drawTime" type="Number" >绘制时间</childParam>
///<childParam key="showTooltips" type="Boolean">是否显示提示</childParam>
///<childParam key="tolerance" type="Number" default="8">公差</childParam>
///<childParam key="tooltipOffset" type="Number" default="15">提示偏差距离</childParam>
///</param>
///<returns>没有返回值</returns>
function DistDrawHelper(map,options) {
    var targetDraw;
    if (arguments.length == 1) {
        targetDraw = new esri.toolbars.Draw(map);
    }
    else { 
       targetDraw = new esri.toolbars.Draw(map,options);
    }

    ///<summary>获取绘制工具draw</summary>
    ///<returns>Draw</returns>
    this.draw = targetDraw;

    ///<summary>激活绘制类型（点线面等）</summary>
    ///<param name="geometryTpye" type="String">绘制类型，例如Draw.CIRCLE、Draw.RECTANGLE、Draw.TRIANGLE、Draw.POINT、Draw.POLYLINE、Draw.POLYGON、Draw.ELLIPSE ...</param>
    ///<param name="options" type="Object">json格式对象，可不填
    ///<childParam key="drawTime" type="Number" >绘制时间</childParam>
    ///<childParam key="showTooltips" type="Boolean">是否显示提示</childParam>
    ///<childParam key="tolerance" type="Number" default="8">公差</childParam>
    ///<childParam key="tooltipOffset" type="Number" default="15">提示偏差距离</childParam>
    ///</param>
    ///<returns>没有返回值</returns>
    this.activate = function (geometryTpye, options) {
        if (arguments.length == 1) {
            targetDraw.activate(geometryTpye);
        }
        else {
            targetDraw.activate(geometryTpye,options);
        }
    }

    ///<summary>使绘制失效</summary>
    ///<returns>没有返回值</returns>
    this.deactivate = function () {
        targetDraw.deactivate();
    }

}