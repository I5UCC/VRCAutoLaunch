using System;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using Newtonsoft.Json;

namespace VRCAutoLaunchConfigurator
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private Config config;
        private EntryEditor EditorWindow;
        private string ConfigPath;

        public MainWindow()
        {
            InitializeComponent();
            ConfigPath = AppDomain.CurrentDomain.BaseDirectory + "config.json";
            if (File.Exists(ConfigPath))
            {
                config = JsonConvert.DeserializeObject<Config>(File.ReadAllText(ConfigPath));
                if (config != null && config.ProgramList != null && config.ProgramList[0].FileName == String.Empty)
                    config.ProgramList.RemoveAt(0);
            }
            config ??= new Config();
            Listbox.ItemsSource = config.ProgramList;
            Closed += MainWindow_Closed;
        }

        private void MainWindow_Closed(object? sender, EventArgs e)
        {
            if (EditorWindow != null)
                EditorWindow.Close();
        }

        private void SaveConfig()
        {
            File.WriteAllText(ConfigPath, JsonConvert.SerializeObject(config, Formatting.Indented));
            Listbox.Items.Refresh();
        }

        private void CreateEditorWindow(ProgramListEntry entry = null, int Listindex = -1)
        {
            double left = Left + Width / 4;
            double top = Top;

            if (entry == null)
            {
                EditorWindow = new EntryEditor(left, top);
            }
            else
            {
                EditorWindow = new EntryEditor(left, top, entry, Listindex);
            }
            EditorWindow.Closed += Editor_Closed;
            EditorWindow.Show();
        }

        private void Editor_Closed(object? sender, EventArgs e)
        {
            if (EditorWindow != null && EditorWindow.ProgramListEntry != null && EditorWindow.Saved)
            {
                if (EditorWindow.Listindex != -1)
                {
                    config.ProgramList[EditorWindow.Listindex] = EditorWindow.ProgramListEntry;
                }
                else
                {
                    config.ProgramList.Add(EditorWindow.ProgramListEntry);
                }
                SaveConfig();
            }
        }

        private void Listbox_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            if (Listbox.SelectedItem != null)
            {
                CreateEditorWindow((ProgramListEntry)Listbox.SelectedItem, Listbox.SelectedIndex);
            }
        }

        private void Listbox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (Listbox.SelectedItem != null)
            {
                Btn_Edit.IsEnabled = true;
                Btn_Delete.IsEnabled = true;
            }
            else
            {
                Btn_Edit.IsEnabled = false;
                Btn_Delete.IsEnabled = false;
            }
        }

        private void Btn_Add_Click(object sender, RoutedEventArgs e) => CreateEditorWindow();

        private void Btn_Edit_Click(object sender, RoutedEventArgs e) => CreateEditorWindow((ProgramListEntry)Listbox.SelectedItem, Listbox.SelectedIndex);

        private void Btn_Delete_Click(object sender, RoutedEventArgs e)
        {
            config.ProgramList.RemoveAt(Listbox.SelectedIndex);
            SaveConfig();
        }
    }
}
