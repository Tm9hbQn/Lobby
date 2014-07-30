using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.IO;
/// <summary>
/// Summary description for OpXML
/// </summary>
public static class OpXML
{
    public static XmlNodeList GetXmlDataFromFile(string pagePath, string selector)
    {
        // הצגת המידע מתוך קובץ ה-XML
        string path = pagePath;
        XmlDocument doc = new XmlDocument();
        try
        {
            using (FileStream fileStream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
            {
                doc = new XmlDocument();
                doc.Load(fileStream);
            }
        }
        catch(Exception ex)
        {
            throw new Exception(ex.Message);
        }

        XmlNodeList nodes = doc.GetElementsByTagName(selector);
        return nodes;
    }

    public static bool ConfirmIdentity(string password, string pagePath)
    {        // מציאת הסיסמה המוצפנת
        string path = pagePath;
        string selector = "password";
        bool connect = false;
        try
        {


            XmlNodeList nodes = OpXML.GetXmlDataFromFile(path, selector);
            string hashed = nodes[0].InnerText;

            connect = BCrypt.CheckPassword(password, hashed);
        }
        catch
        {
            throw new Exception("ניסיון אימות זהות מנהל כשל! חזור לדף הקודם ונסה מאוחר יותר");
        }
        return connect;
    }
    public static int InsertNewNodeToXmlFile(string path, string docName, string author, string date, string place, string type, string url, int id)
    {

        try
        {
            // קבלת הערכים הקיימים
            XmlNodeList nodes = GetXmlDataFromFile(path, "link");
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
                    writer.WriteAttributeString("id", (i + 1).ToString());
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
        catch
        {
            return 0;
        }
        return 1;
    }

    public static int InsertNewCategoryToXmlFile(string path, string xmlName, string text, string enabled, bool isNew)
    {
      //  try
      //  {
            // קבלת הערכים הקיימים
            XmlNodeList nodes = GetXmlDataFromFile(path, "category");
            int i = nodes.Count;
            if (nodes.Count < 1)
                return 0;
            // אם מדובר בעדכון סיווג מסוים - יעדכן על גבי הרשימה הקיימת.

            XmlWriterSettings settings = new XmlWriterSettings();
            settings.Indent = true;
            settings.NewLineChars = "\r\n";

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

                writer.WriteStartElement("categories");


                // הוספת הערכים הקיימים מחדש לקובץ ה-XML
                foreach (XmlNode node in nodes)
                {
                    writer.WriteStartElement("category");

                    // מזהה ייחודי - שם. אם שווה, אז יעדכן את הנוד הספציפי עם המידע החדש
                    if (node.InnerText == xmlName)
                    {

                        writer.WriteAttributeString("enabled", enabled);
                        writer.WriteAttributeString("name", text);
                    }
                    else
                    {
                        writer.WriteAttributeString("enabled", node.Attributes["enabled"].Value);
                        writer.WriteAttributeString("name", node.Attributes["name"].Value);
                    }
                    writer.WriteString(node.InnerText);
                    writer.WriteEndElement();
                }
                if (isNew)
                {
                    // הוספת הערך החדש לקובץ
                    writer.WriteStartElement("category");
                    writer.WriteAttributeString("enabled", enabled);
                    writer.WriteAttributeString("name", text);
                    writer.WriteString(xmlName);
                    writer.WriteEndElement();
                }
                writer.WriteEndDocument();
                writer.Flush();
                writer.Close();
            }
        //}
/*        catch (Exception ex)
        {
            string msg = "השגיאה הבאה התרחשה: " + ex.Message + "\n\n\n" + "הטקסט הוא: " + text;
            throw new Exception(msg);
        }
 * */
        return 1;
    }
}