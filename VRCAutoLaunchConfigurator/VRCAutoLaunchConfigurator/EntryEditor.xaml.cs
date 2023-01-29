using System.IO;
using System.Windows;
using System.Windows.Controls;

namespace VRCAutoLaunchConfigurator
{
    /// <summary>
    /// Interaction logic for EntryEditor.xaml
    /// </summary>
    public partial class EntryEditor : Window
    {
        public ProgramListEntry ProgramListEntry { get; set; }
        public int Listindex { get; set; }
        public bool Saved { get; set; }

        public EntryEditor(double Left, double Top)
        {
            this.Left = Left;
            this.Top = Top;
            InitializeComponent();
            Lbl_Header.Content = "ADD NEW ENTRY";
            this.Saved = false;
            this.ProgramListEntry = new ProgramListEntry();
            this.Listindex = -1;
        }

        public EntryEditor(double Left, double Top, ProgramListEntry ProgramListEntry, int Listindex)
        {
            this.Left = Left;
            this.Top = Top;
            InitializeComponent();
            Lbl_Header.Content = "EDIT ENTRY";
            this.Saved = false;
            this.ProgramListEntry = ProgramListEntry;
            this.Listindex = Listindex;
            Tbx_Filename.Text = ProgramListEntry.FileName;
            Tbx_WorkingDir.Text = ProgramListEntry.WorkingDir;
            Tbx_Arguments.Text = ProgramListEntry.Arguments;
            Cbx_CloseOnQuit.IsChecked = ProgramListEntry.CloseOnQuit == 1;
            Cbx_MinimizeLegacy.IsChecked = ProgramListEntry.StartMinimized == 2;
            Cbx_StartMinimized.IsChecked = ProgramListEntry.StartMinimized >= 1;
            Cbx_VROnly.IsChecked = ProgramListEntry.VrOnly == 1;
            check_entries();
        }

        private void Save_Click(object sender, RoutedEventArgs e)
        {
            int minimize = 0;
            if ((bool)Cbx_StartMinimized.IsChecked && (bool)Cbx_MinimizeLegacy.IsChecked)
            {
                minimize = 2;
            }
            else if ((bool)Cbx_StartMinimized.IsChecked && !(bool)Cbx_MinimizeLegacy.IsChecked)
            {
                minimize = 1;
            }
            this.Saved = true;
            ProgramListEntry = new ProgramListEntry(Tbx_Filename.Text.Replace('\\', '/'), Tbx_WorkingDir.Text.Replace('\\', '/'), Tbx_Arguments.Text, minimize, (bool)Cbx_CloseOnQuit.IsChecked ? 1 : 0, (bool)Cbx_VROnly.IsChecked ? 1 : 0);
            Close();
        }

        private void check_entries()
        {
            if (Directory.Exists(Tbx_WorkingDir.Text) && File.Exists(Path.Combine(Tbx_WorkingDir.Text, Tbx_Filename.Text)))
            {
                Btn_Save.IsEnabled = true;
            }
            else
            {
                Btn_Save.IsEnabled = false;
            }
        }

        private void Tbx_Filename_TextChanged(object sender, TextChangedEventArgs e) => check_entries();

        private void Tbx_WorkingDir_TextChanged(object sender, TextChangedEventArgs e) => check_entries();
    }
}
