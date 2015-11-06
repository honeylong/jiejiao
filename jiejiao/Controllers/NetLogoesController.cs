using System;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using jiejiao.Models;
using System.Text;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.IO;
using System.Text.RegularExpressions;
using System.Collections.Generic;

namespace jiejiao.Controllers
{
    public class NetLogoesController : Controller
    {
        private jiejiaoDbContext db = new jiejiaoDbContext();

        // GET: NetLogoes/Create
        public ActionResult CreateExperiment(int? id)
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
        public string CreateExperiment([Bind(Include = "Id,Experiments")] NetLogo netLogo)
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
            return a;
        }

        public ActionResult Experiment(int? id)
        {
            NetLogo ng = db.NetLogoes.Find(id);
            string experiments = ng.Experiments;
            JArray ja = JArray.Parse(experiments);
            List<Experiment> experimentl = new List<Experiment>();
            foreach (JObject jo in ja)
            {
                JArray jaa = JArray.Parse(jo["电影"].ToString());
                foreach (JObject joo in jaa) {
                    jo["调性"].ToString();
                    jo["剧情"].ToString();
                    jo["类型"].ToString();
                    jo["场景"].ToString();
                }
            }
            return View(experimentl);
        }

        public ActionResult Create()
        {
            return View();
        }
        // GET: NetLogoes/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(FormCollection form)
        {
            NetLogo netLogo = new NetLogo();
            StringBuilder info = new StringBuilder();
            foreach (string file in Request.Files)
            {

                HttpPostedFileBase postFile = Request.Files[file];//get post file
                string filename = postFile.FileName;
                string LastName = filename.Substring(filename.LastIndexOf(".") + 1, (filename.Length - filename.LastIndexOf(".") - 1));   //扩展名

                if (postFile.ContentLength != 0 && LastName.Equals("nlogo"))
                {
                    string newFilePath = Server.MapPath("~/uploads/");//save path
                    Guid tempCartId = Guid.NewGuid();
                    postFile.SaveAs(newFilePath + tempCartId.ToString() + ".nlogo");//save file
                    StreamReader sr = new StreamReader(newFilePath + tempCartId.ToString() + ".nlogo", System.Text.Encoding.GetEncoding("utf-8"));
                    string content = sr.ReadToEnd().ToString();
                    sr.Close();
                    netLogo.Content = content;
                    netLogo.FileName = newFilePath + tempCartId.ToString() + ".nlogo";
                    netLogo.ExperimentModel = Tools.MakeExperimentsModel(netLogo);
                    netLogo.Experiments = "[]";
                    if (ModelState.IsValid)
                    {
                        db.NetLogoes.Add(netLogo);
                        db.SaveChanges();
                    }
                    return RedirectToAction("Index");
                }
            }
            return RedirectToAction("Index");   
        }


        // GET: NetLogoes
        public ActionResult Index()
        {
            return View(db.NetLogoes.ToList());
        }

        // GET: NetLogoes/Details/5
        public ActionResult Details(int? id)
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


        public string MakeExperimentsModel(int? id)
        {
            NetLogo netLogo = db.NetLogoes.Find(id);
            return Tools.MakeExperimentsModel(netLogo);
        }
        // GET: NetLogoes/Details/5
        public string RunNetLogos(int? id)
        {
            if (id == null)
            {
                //return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
                return "0";
            }
            NetLogo netLogo = db.NetLogoes.Find(id);
            if (netLogo == null)
            {
                //return HttpNotFound();
                return "1";
            }
            return Tools.MakeExperiments(netLogo);
        }

        // GET: NetLogoes/Edit/5
        public ActionResult Edit(int? id)
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

        // POST: NetLogoes/Edit/5
        // 为了防止“过多发布”攻击，请启用要绑定到的特定属性，有关 
        // 详细信息，请参阅 http://go.microsoft.com/fwlink/?LinkId=317598。
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,Name,Content,FileName,Experiments")] NetLogo netLogo)
        {
            if (ModelState.IsValid)
            {
                db.Entry(netLogo).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(netLogo);
        }

        // GET: NetLogoes/Delete/5
        public ActionResult Delete(int? id)
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

        // POST: NetLogoes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            NetLogo netLogo = db.NetLogoes.Find(id);
            db.NetLogoes.Remove(netLogo);
            db.SaveChanges();
            return RedirectToAction("Index");
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
