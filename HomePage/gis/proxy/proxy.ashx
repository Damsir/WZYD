<%@ WebHandler Language="C#" Class="proxy" %>

using System;
using System.Web;
using System.IO;

public class proxy : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        string url = context.Request["url"];

        System.Net.HttpWebRequest req = (System.Net.HttpWebRequest)System.Net.HttpWebRequest.Create(url);

        System.Net.WebResponse serverResponse = req.GetResponse(); ;

        using (Stream byteStream = serverResponse.GetResponseStream())
        {

            using (StreamReader sr = new StreamReader(byteStream))
            {
                string strResponse = sr.ReadToEnd();
                context.Response.Write(strResponse);
            }

            serverResponse.Close();
        }

        context.Response.End();
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}