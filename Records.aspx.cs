using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.IO;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        XmlNodeList nodes = GetXmlDataFromFile();
        for (int i = nodes.Count - 1; i >= 0; i--)
        {
            string value = nodes[i].InnerText;
            string author = nodes[i].Attributes["author"].Value;
            string date;
            try
            {
                date = DateTime.Parse(nodes[i].Attributes["date"].Value).ToShortDateString();
            }
            catch
            {
                date = string.Empty;
            }
            string place = nodes[i].Attributes["place"].Value;
            string url = nodes[i].Attributes["url"].Value;
            string id = nodes[i].Attributes["id"].Value;

            string info = string.Empty;
                info = string.Format(@"<br /><br /><a target=""_blank"" href=""{0}"">{1}</a>, {2}, {3}, ע""י {4} ({5})", url, value, place, date, author, id);

            // בדיקה לאיזו רשימה יש לשייך - לפי סוג מסמך
                string type = nodes[i].Attributes["type"].Value;
            switch (type)
            {
                case "protocol":
                    protocol.InnerHtml += info;
                    break;
                case "schedule":
                    schedule.InnerHtml += info;
                    break;
                case "olympus":
                    olympus.InnerHtml += info;
                    break;
                case "formalPaper":
                    formalPaper.InnerHtml += info;
                    break;
                case "projects":
                    projects.InnerHtml += info;
                    break;
            }
        }

    }
    public XmlNodeList GetXmlDataFromFile()
    {
        // הצגת המידע מתוך קובץ ה-XML
        string path = MapPath("~/LobbyFiles.xml");
        XmlDocument doc = new XmlDocument();
        try
        {
            using (FileStream fileStream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
            {
                doc = new XmlDocument();
                doc.Load(fileStream);
            }
        }
        catch
        {
            return null;
        }

        XmlNodeList nodes = doc.GetElementsByTagName("link");
        return nodes;
    }
}