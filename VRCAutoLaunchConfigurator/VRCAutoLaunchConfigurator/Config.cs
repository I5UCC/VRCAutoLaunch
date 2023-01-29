using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.Collections.Generic;
using System.IO;

namespace VRCAutoLaunchConfigurator
{
    public partial class Config
    {
        public Config()
        {
            ProgramList = new List<ProgramListEntry>();
        }

        [JsonProperty("ProgramList")]
        public List<ProgramListEntry> ProgramList { get; set; }
    }

    public partial class ProgramListEntry
    {
        public ProgramListEntry()
        {
            this.FileName = "";
            this.WorkingDir = "";
            this.Arguments = "";
            this.StartMinimized = 0;
            this.CloseOnQuit = 0;
            this.VrOnly = 0;
        }

        public ProgramListEntry(string FileName, string WorkingDir, string Arguments, int StartMinimized, int CloseOnQuit, int VrOnly)
        {
            this.FileName = FileName;
            this.WorkingDir = WorkingDir;
            this.Arguments = Arguments;
            this.StartMinimized = StartMinimized;
            this.CloseOnQuit = CloseOnQuit;
            this.VrOnly = VrOnly;
        }

        [JsonProperty("FileName")]
        public string FileName { get; set; }

        [JsonProperty("WorkingDir")]
        public string WorkingDir { get; set; }

        [JsonProperty("Arguments")]
        public string Arguments { get; set; }

        [JsonProperty("StartMinimized")]
        public int StartMinimized { get; set; }

        [JsonProperty("CloseOnQuit")]
        public int CloseOnQuit { get; set; }

        [JsonProperty("VROnly")]
        public int VrOnly { get; set; }

        public override string ToString()
        {
            return Path.Combine(WorkingDir, FileName).Replace('\\', '/');
        }
    }
}
