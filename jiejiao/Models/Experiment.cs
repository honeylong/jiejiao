using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace jiejiao.Models
{
    public class Experiment
    {
        public string name { set; get; }
        public string repetitions { set; get; }
        public string runMetricsEveryStep { set; get; }
        public string timeLimit { set; get; }
        public string exitCondition { set; get; }
        public string metric { set; get; }
        public string enumeratedValueSet { set; get; }
    }
}