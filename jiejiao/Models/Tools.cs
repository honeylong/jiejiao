using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;

namespace jiejiao.Models
{
    public class Tools
    {
        public static string Run(string url, string model, string experiment, string result)
        {
            Process p = new Process();
            StringBuilder Sb = new StringBuilder();
            Sb.Append("java -Xmx1024m -Dfile.encoding=UTF-8 -cp NetLogo.jar   org.nlogo.headless.Main");
            Sb.Append("   --model " + model);
            Sb.Append("   --experiment " + experiment);
            Sb.Append("   --" + result);
            string address = "cd " + url;
            p.StartInfo.FileName = "sh";
            p.StartInfo.UseShellExecute = false;
            p.StartInfo.RedirectStandardInput = true;
            p.StartInfo.RedirectStandardOutput = true;
            p.StartInfo.RedirectStandardError = true;
            p.StartInfo.CreateNoWindow = true;
            p.Start();
            p.StandardInput.WriteLine(address);
            p.StandardInput.WriteLine(Sb.ToString());
            //p.StandardInput.WriteLine("ls"); 
            //Thread.Sleep(10000);
            p.StandardInput.WriteLine("exit");
            string strResult = p.StandardOutput.ReadToEnd();
            p.Close();
            //Thread.Sleep(10000);
            return address;
        }
        public static string MakeExperiments(NetLogo netLogo)
        {
            string content = netLogo.Content;
            string experiments = netLogo.Experiments;
            string tmpstr1 = content.Substring(0, content.IndexOf("@#$#@#$#@\r\n@#$#@#$#@") + "@#$#@#$#@\r\n@#$#@#$#@".Length);
            string tmpstr2 = content.Substring((content.IndexOf("@#$#@#$#@\r\n@#$#@#$#@") + "@#$#@#$#@\r\n@#$#@#$#@".Length), (content.Length - content.IndexOf("@#$#@#$#@\r\n@#$#@#$#@") - "@#$#@#$#@\r\n@#$#@#$#@".Length));
            //JArray ja = (JArray)JsonConvert.DeserializeObject(experiments);
            StringBuilder sb = new StringBuilder();
            sb.Append("\r\n<experiments>");
            JArray ja = JArray.Parse(experiments);
            foreach (JObject jo in ja)
            {
                string experiment = "";
                experiment += "\r\n  <experiment name=\"" + jo["name"].ToString() + "\" repetitions=\"" + jo["repetitions"].ToString() + "\" runMetricsEveryStep=\"" + jo["runMetricsEveryStep"] + "\">";
                experiment += "\r\n    <setup>" + jo["setup"].ToString() + "</setup>";
                experiment += "\r\n    <go>" + jo["go"].ToString() + "</go>";
                if (!jo["timeLimit"].ToString().Equals("") && jo["timeLimit"].ToString() != null)
                {
                    experiment += "\r\n    <timeLimit steps=\"" + jo["timeLimit"].ToString() + "\" />";
                }
                if (!jo["exitCondition"].ToString().Equals("") && jo["exitCondition"].ToString() != null)
                {
                    experiment += "\r\n    <exitCondition>" + jo["exitCondition"].ToString() + "</exitCondition>";
                }
                string[] metrics = jo["metric"].ToString().Split('\n');
                foreach (string metric in metrics)
                {
                    experiment += "\r\n    <metric>" + Regex.Replace(metric, @"[\r]", "") + "</metric>";
                }

                string[] enumeratedValueSets = jo["enumeratedValueSet"].ToString().Split('\n');
                foreach (string evs in enumeratedValueSets)
                {
                    string e = evs.Substring(evs.IndexOf("\"") + 1, evs.LastIndexOf("\"") - evs.IndexOf("\"") - 1);
                    experiment += "\r\n    <enumeratedValueSet variable=\"" + e + "\" >";
                    string[] values = evs.Substring(evs.LastIndexOf("\"") + 2, evs.Length - evs.LastIndexOf("\"") - 3).Split(' ');
                    foreach (var value in values)
                    {
                        experiment += "\r\n      <value value=\"" + Regex.Replace(value, @"]", "") + "\" />";
                    }
                    experiment += "\r\n    </enumeratedValueSet>";
                }
                experiment += "\r\n  </experiment>";
                sb.Append(experiment);
            }
            sb.Append("\r\n</experiments>");

            return tmpstr1 + "\r\n@#$#@#$#@" + sb.ToString() + "\r\n@#$#@#$#@\r\n@#$#@#$#@" + tmpstr2;
        }
        public static string MakeExperimentsModel(NetLogo netLogo)
        {
            string[] content = netLogo.Content.Split('\n');
            string json = "[";
            int count = content.Length;
            for (int i = 0; i < count; i++)
            {
                if (content[i].IndexOf("INPUT") != -1)
                {
                    json += Regex.Replace(content[i + 5], @"[\r]", "") + ",";
                }
                if (content[i].IndexOf("BUTTON") != -1)
                {
                    json += Regex.Replace(content[i + 5], @"[\r]", "") + ",";
                }
                if (content[i].IndexOf("CHOOSER") != -1)
                {
                    json += Regex.Replace(content[i + 5], @"[\r]", "") + ",";
                }
                if (content[i].IndexOf("SLIDER") != -1)
                {
                    json += Regex.Replace(content[i + 5], @"[\r]", "") + ",";
                }
                if (content[i].IndexOf("SWITCH") != -1)
                {
                    json += Regex.Replace(content[i + 5], @"[\r]", "") + ",";
                }
            }
            int jl = json.Length;
            if (jl > 0)
            {
                json.Substring(0, jl - 1);
            }
            json += "]";
            return json;
        }
        public static class JsonHelper
        {
            public static string Create(string jsonList, string jsonEntity)
            {
                if (jsonList == null || jsonList.Equals(""))
                {
                    JArray ja = new JArray();
                    JToken jt = JObject.Parse(jsonEntity);
                    ja.Add(jt);
                    jsonList = ja.ToString();
                }
                else
                {
                    JArray ja = JArray.Parse(jsonList);
                    JToken jt = JObject.Parse(jsonEntity);
                    ja.Add(jt);
                    jsonList = ja.ToString();
                }
                return jsonList;
            }
            public static string Edit(string jsonList, string jsonEntity)
            {
                return jsonList;
            }
            public static string Delete(string jsonList, string jsonEntity)
            {
                return jsonList;
            }
        }
    }
}