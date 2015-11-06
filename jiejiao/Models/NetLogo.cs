using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace jiejiao.Models
{
    public class NetLogo
    {
        public int Id { set; get; }
        public string Name { set; get; }
        public string FileName { set; get; }
        public string ExperimentModel { set; get; }
        public string Experiments { set; get; }
        public string Content { set; get; }
    }
}