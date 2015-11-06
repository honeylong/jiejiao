using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using jiejiao.Models;
using Newtonsoft.Json.Linq;
using System.IO;
using System.Text.RegularExpressions;

namespace jiejiao.Controllers
{
    public class ExperimentsController : Controller
    {
        private jiejiaoDbContext db = new jiejiaoDbContext();

        // GET: Experiments
        public ActionResult Index(int? id)
        {
            NetLogo ng = db.NetLogoes.Find(id);
            string experiments = ng.Experiments;
            List<Experiment> experimentl = new List<Experiment>();
            if (experiments != null || !experiments.Equals(""))
            {
                JArray ja = JArray.Parse(experiments);
                foreach (JObject jo in ja)
                {
                    Experiment e = new Experiment();
                    e.name = jo["name"].ToString();
                    e.repetitions = jo["repetitions"].ToString();
                    e.exitCondition = jo["exitCondition"].ToString();
                    e.metric = jo["metric"].ToString();
                    e.runMetricsEveryStep = jo["runMetricsEveryStep"].ToString();
                    e.timeLimit = jo["timeLimit"].ToString();
                    e.enumeratedValueSet = jo["enumeratedValueSet"].ToString();
                    experimentl.Add(e);
                }
                return View(experimentl);
            }
            return View(experimentl);
        }

        // GET: NetLogoes/Create
        public ActionResult Create(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            NetLogo netLogo = db.NetLogoes.Find(id);
            if (netLogo == null)
            {
                return HttpNotFound();
            }
            return View(netLogo);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,Experiments")] NetLogo netLogo)
        {
            string a = "";
            NetLogo ng = db.NetLogoes.Find(netLogo.Id);
            string experimentsOld = ng.Experiments;
            string experimentsNew = netLogo.Experiments;
            a = Tools.JsonHelper.Create(experimentsOld, experimentsNew);
            ng.Experiments = a;
            if (ModelState.IsValid)
            {
                db.Entry(ng).State = EntityState.Modified;
                db.SaveChanges();
                //return RedirectToAction("Index");
            }
            return RedirectToAction("Index", "Experiments", new { id = ng.Id });
        }

        public ActionResult Run(int? id, string name)
        {
            NetLogo ng = db.NetLogoes.Find(id);
            //StreamWriter sw = new StreamWriter(ng.FileName, false, new System.Text.UTF8Encoding(false));
            //sw.Write(Tools.MakeExperiments(ng));
            //sw.Close();
            //string file = System.IO.Path.GetDirectoryName(ng.FileName) + @"/";
            //string filename = System.IO.Path.GetFileName(ng.FileName);
            //Tools.Run(file, filename, name, "table " + filename + ".csv");

            StreamReader sr = new StreamReader(ng.FileName + ".csv", System.Text.Encoding.GetEncoding("utf-8"));
            for (int i = 0; i < 6; i++) { sr.ReadLine(); }
            List<string[]> ls = new List<string[]>();
            while (!sr.EndOfStream)
            {
                string[] str = sr.ReadLine().Replace("\"", "").Split(',');
                ls.Add(str);
            }
            int step = 0;
            int runnum = 0;
            for (int i = 0; i < ls[0].Length; i++)
            {
                if (ls[0][i].IndexOf("step") > -1) { step = i; }
                if (ls[0][i].IndexOf("run number") > -1) { runnum = i; }
            }
            int stepmax = 0;
            int runnummax = 0;
            for (int i = 1; i < ls.Count; i++)
            {
                if (int.Parse(ls[i][step]) > stepmax) { stepmax = int.Parse(ls[i][step]); }
                if (int.Parse(ls[i][runnum]) > runnummax) { runnummax = int.Parse(ls[i][runnum]); }
            }
            string[] stepv = { step.ToString(), stepmax.ToString(), runnum.ToString(), runnummax.ToString() };
            ls.Add(stepv);
            return View(ls);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
