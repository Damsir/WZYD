<%@ WebHandler Language="C#" Class="AddressQueryHandler" %>

using System;
using System.Web;
using System.Net;
using System.Xml;

public class AddressQueryHandler : IHttpHandler
{
    private int maxRecords = 20;
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        HttpResponse response = context.Response;
        try
        {
            string type = context.Request["type"];
            string length = context.Request["maxRecords"];
            if (length != null)
            {
                maxRecords = Convert.ToInt16(length);
                if (maxRecords <= 0)
                {
                    maxRecords = 1;
                }
            }

            switch (type)
            {
                case "text":
                    string address = context.Request["keyWord"];
                    if (address == null)
                    {
                        context.Response.Write("");
                        return;
                    }
                    context.Response.Write(queryAddress(address, true));
                    break;
                case "geometry":
                    string coords = context.Request["coords"];
                    if (coords == null)
                    {
                        context.Response.Write("");
                        return;
                    }
                    context.Response.Write(queryAddress(coords, false));
                    break;
                default:
                    context.Response.Write("");
                    break;
            }



        }
        catch (Exception e)
        {
            context.Response.Write(e.Message);
        }


    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    /// <summary>
    /// 地名查询
    /// </summary>
    /// <param name="queryFilter">查询内容</param>
    /// <param name="isNameQuery">是否根据地名名称查询</param>
    /// <returns></returns>
    /// 
    
    private string queryAddress(string queryFilter, bool isNameQuery)
    {
        string url = "http://119.163.121.38/wfs-gservice/service/wfsg";
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);

        System.Text.StringBuilder pas = new System.Text.StringBuilder();
        pas.Append("<wfs:GetFeature service=\"WFS\" version=\"1.0.0\" maxFeatures=\"" + maxRecords + "\"");
        pas.Append(" xmlns:wfs=\"http://www.opengis.net/wfs\"");
        pas.Append(" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"");
        pas.Append(" xsi:schemaLocation=\"http://www.opengis.net/wfs http://schemas.opengis.net/wfs/1.0.0/WFS-transaction.xsd\">");
        pas.Append(" <wfs:Query typeName=\"__500地名\">");//查询图层
        pas.Append(" <ogc:Filter xmlns:ogc=\"http://www.opengis.net/ogc\">");
        if (isNameQuery)
        {
            pas.Append(" <ogc:OR>");
            pas.Append(" <ogc:PropertyIsLike wildCard=\"*\" singleChar=\".\" escape=\"!\">");
            pas.Append(" <ogc:PropertyName>NR</ogc:PropertyName>");//查询字段
            pas.Append(" <ogc:Literal>*" + queryFilter + "*</ogc:Literal>");
            pas.Append(" </ogc:PropertyIsLike>");
            pas.Append(" <ogc:PropertyIsLike wildCard=\"*\" singleChar=\".\" escape=\"!\">");
            pas.Append(" <ogc:PropertyName>NR</ogc:PropertyName>");//查询字段
            pas.Append(" <ogc:Literal>*" + queryFilter + "*</ogc:Literal>");
            pas.Append(" </ogc:PropertyIsLike>");
            pas.Append(" </ogc:OR>");
        }
        else
        {
            pas.Append("<ogc:Intersects>");
            pas.Append("<ogc:PropertyName>the_geom</ogc:PropertyName>");
            pas.Append("<gml:Polygon xmlns:gml=\"http://www.opengis.net/gml\" srsName=\"EPSG:4326\">");
            pas.Append("<gml:outerBoundaryIs>");
            pas.Append("<gml:LinearRing>");
            pas.Append("<gml:coordinates decimal=\".\" cs=\",\" ts=\" \">");
            pas.Append(queryFilter);
            pas.Append("</gml:coordinates>");
            pas.Append("</gml:LinearRing>");
            pas.Append("</gml:outerBoundaryIs>");
            pas.Append("</gml:Polygon>");
            pas.Append("</ogc:Intersects>");
        }





        pas.Append(" </ogc:Filter>");
        pas.Append(" </wfs:Query>");
        pas.Append(" </wfs:GetFeature>");


        string s = pas.ToString();


        byte[] requestBytes = System.Text.Encoding.UTF8.GetBytes(s);
        req.Method = "POST";
        req.ContentType = "application/x-www-form-urlencoded";
        req.ContentLength = requestBytes.Length;

        System.IO.Stream requestStream = req.GetRequestStream();
        requestStream.Write(requestBytes, 0, requestBytes.Length);
        requestStream.Close();

        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        System.IO.StreamReader sr = new System.IO.StreamReader(res.GetResponseStream(), System.Text.Encoding.UTF8);
        string backstr = sr.ReadToEnd();

        System.IO.StringReader Reader = new System.IO.StringReader(backstr);
        System.Xml.XmlDocument xmlDoc = new System.Xml.XmlDocument();
        xmlDoc.Load(Reader);

        XmlNodeList nodes = xmlDoc.GetElementsByTagName("gml:featureMember");

        System.Text.StringBuilder xml = new System.Text.StringBuilder();
        System.Collections.Generic.List<string> addressNames = new System.Collections.Generic.List<string>();

        string josnStr = "[";
        if (nodes != null)
        {
            for (int i = 0; i < nodes.Count; i++)
            {
                System.Xml.XmlElement xnt = (XmlElement)nodes[i];

                XmlNodeList xnl = xnt.GetElementsByTagName("zzAddressWfs:__500地名");//图层名
                XmlElement xe = (XmlElement)xnl[0];
                XmlNodeList dkbhXnl = xe.GetElementsByTagName("zzAddressWfs:NR");//显示字段
                XmlElement dkbhXe = (XmlElement)dkbhXnl[0];
                XmlNodeList oidXnl = xe.GetElementsByTagName("zzAddressWfs:NR");//显示字段
                XmlElement oidXe = (XmlElement)oidXnl[0];
                XmlNodeList lyTypeXnl = xe.GetElementsByTagName("gml:Polygon");

                string addressName = dkbhXe.InnerText;
                string addressAddress = oidXe.InnerText;

                if (addressNames.Contains(addressName))
                    continue;

                addressNames.Add(addressName);
                //XmlNodeList corXnl = xe.GetElementsByTagName("gml:coordinates");
                //XmlElement corXe = (XmlElement)corXnl[0];
                //string locate = corXe.InnerText;
                //locate = locate.Trim();
                //获得地名地址X和Y坐标
                XmlNodeList corXnlX = xe.GetElementsByTagName("zzAddressWfs:X");//获得X坐标(服务名:X)
                XmlNodeList corXnlY = xe.GetElementsByTagName("zzAddressWfs:Y");//获得Y坐标(服务名:Y)

                XmlElement corXeX = (XmlElement)corXnlX[0];
                XmlElement corXeY = (XmlElement)corXnlY[0];
                
                string locateX = corXeX.InnerText.Trim();
                string locateY = corXeY.InnerText.Trim();
                string locate = string.Format("{0},{1}", locateX, locateY);
                string[] coordinates = null;
                string[] coordinate = null;
                char[] chars = null;
                //if (lyTypeXnl.Count > 0)
                //{
                //    chars = new char[] { ' ' };
                //    coordinates = locate.Split(chars);
                //}
                //else
                //{
                //chars = new char[] { ',' };
                //coordinates = locate.Split(chars);
                //}
                string geo = "";
                geo += "{";
                geo += "locateName:\"" + addressName + "\",";
                //判断地名定位是点还是面
                if (lyTypeXnl.Count > 0)
                    geo += "lyType:\"Polygon\",";
                else
                    geo += "lyType:\"Point\",";

                geo += "locateAddress:\"" + addressAddress + "\",";
                geo += "locateCoordinate:\"";
                geo += locate;
                geo += "\"}";

                if (i != nodes.Count - 1)
                {
                    geo += ",";
                }

                josnStr += geo;
            }

        }

        josnStr += "]";



        sr.Close();
        res.Close();
        return josnStr;//xml.ToString()

    }

}