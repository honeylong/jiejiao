using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace jiejiao.Models
{
    public class jiejiaoDbContext : DbContext
    {
        public DbSet<NetLogo> NetLogoes { get; set; }
        //public DbSet<Experiment> Experiments { get; set; }
    }
}
