using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.IO;

public partial class ControlPanel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["connected"] == null)
            Response.Redirect("login.aspx");
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

    /// <summary>
    /// מחזיר 1 אם הצלחה, 0 אם כישלון
    /// </summary>
    /// <param name="docName"></param>
    /// <param name="authorName"></param>
    /// <returns></returns>
    public int InsertNewNodeToXmlFile(string docName, string author, string date, string place, string type, string url, int id)
    {
        
        try
        {
            // קבלת הערכים הקיימים
            XmlNodeList nodes = GetXmlDataFromFile();
            int i = nodes.Count;
            if (nodes.Count < 1)
                return 0;
            if (id != 0)
            {
                nodes[id - 1].InnerText = docName;
                nodes[id - 1].Attributes["type"].Value = type;
                nodes[id - 1].Attributes["author"].Value = author;
                nodes[id - 1].Attributes["date"].Value = date;
                nodes[id - 1].Attributes["place"].Value = place;
                nodes[id - 1].Attributes["url"].Value = url;
            }
            XmlWriterSettings settings = new XmlWriterSettings();
            settings.Indent = true;
            settings.NewLineChars = "\r\n";

            string path = MapPath("~/LobbyFiles.xml");

            // מחיקת נתוני הקובץ הקיים לאחר שאוחזרו לתכנית
            using (FileStream fileStream = new FileStream(path, FileMode.Truncate, FileAccess.Write, FileShare.Read))
            {
                fileStream.SetLength(0);
            }

            // הכנסת הנתונים המאוחזרים בנוסף לנתונים החדשים
            using (FileStream fileStream = new FileStream(path, FileMode.Append, FileAccess.Write, FileShare.Read))
            {
                XmlWriter writer = XmlWriter.Create(fileStream, settings);
                writer.WriteStartDocument();

                writer.WriteStartElement("links");


                // הוספת הערכים הקיימים מחדש לקובץ ה-XML
                foreach (XmlNode node in nodes)
                {
                        writer.WriteStartElement("link");
                        writer.WriteAttributeString("id", node.Attributes["id"].Value);
                        writer.WriteAttributeString("type", node.Attributes["type"].Value);
                        writer.WriteAttributeString("author", node.Attributes["author"].Value);
                        writer.WriteAttributeString("date", node.Attributes["date"].Value);
                        writer.WriteAttributeString("place", node.Attributes["place"].Value);
                        writer.WriteAttributeString("url", node.Attributes["url"].Value);
                        writer.WriteString(node.InnerText);
                        writer.WriteEndElement();
                }
                if (id == 0)
                {
                    // הוספת הערך החדש לקובץ
                    writer.WriteStartElement("link");
                    writer.WriteAttributeString("id", (i+1).ToString());
                    writer.WriteAttributeString("type", type);
                    writer.WriteAttributeString("author", author);
                    writer.WriteAttributeString("date", date);
                    writer.WriteAttributeString("place", place);
                    writer.WriteAttributeString("url", url);
                    writer.WriteString(docName);                  
                }
                writer.WriteEndDocument();
                writer.Flush();
                writer.Close();
            }
        }
        catch (Exception ex)
        {
            status.Text += ex.Message;
            return 0;
        }
        return 1;
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        status.Text = "";
        //קבלת הנתונים מהטופס
        int id = -1;
        try
        {
            id = int.Parse(idBox.Text);
        }
        catch
        {
        }
        if ((id >= 0) && id < GetXmlDataFromFile().Count + 1)
        {
            string name = DocNameBox.Text;
            string author = authorNameBox.Text;
            string place = placeBox.Text;
            string url = urlBox.Text;
            string type = typeList.SelectedValue;
            string date = dateBox.Text;

            // בדיקה האם מדובר ברשומה חדשה או בעדכון רשומה קיימת
            int i = InsertNewNodeToXmlFile(name, author, date, place, type, url, id);


            if (i == 0)
                status.Text += "עדכון רשומה חדשה נכשל!";
            else
            {
                idBox.Text = "0";
                DocNameBox.Text = string.Empty;
                authorNameBox.Text = string.Empty;
                placeBox.Text = string.Empty;
                urlBox.Text = string.Empty;
                typeList.SelectedIndex = 0;
                dateBox.Text = DateTime.Now.ToString();
                status.Text += "עדכון רשומה חדשה הצליח!";
            }
        }
        else
            status.Text = "עדכון הרשומה נכשל - מספר רשומה שגוי!";

    }
}
