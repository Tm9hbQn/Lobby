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
        // טעינת נתונים ממסמכים XML
        string lobbyPath = MapPath("~/LobbyFiles.xml");
        string categoriesPath = MapPath("~/Categories.xml");
        XmlNodeList nodes = OpXML.GetXmlDataFromFile(lobbyPath, "link");

        // טעינת נתוני הסיווגים השונים למבואה
        XmlNodeList categories = OpXML.GetXmlDataFromFile(categoriesPath, "category");
        Dictionary<string, string> clientCategories = new Dictionary<string, string>();
        int x = 0;
        foreach (XmlNode category in categories)
        {
            if (category.Attributes["enabled"].Value != "false")
            {
                /*
                 *            <div id="formalPaper" class="section_wrapper" runat="server">
               <h2>מסמכים רשמיים</h2>
           </div>*/
                string openingTags = string.Format(@"<div id={0}, class=""section_wrapper""><h2>{1}</h2>", category.InnerText, category.Attributes["name"].Value);
                //string openingTags = string.Format(@"<div id={0}, class=""section_wrapper"">", category.InnerText);
                
                clientCategories.Add(category.InnerText, openingTags);
              if (x == 0)
                  categories_wrapper.InnerHtml += string.Format(@"<li id=""{0}"" style=""font-size:20px; border-bottom: 2px solid #0094ff;"" class=""rec_nav"">{1}</h4><br />", x, category.Attributes["name"].Value);
                else
                    categories_wrapper.InnerHtml += string.Format(@"<li id=""{0}"" class=""rec_nav"">{1}</h4><br />", x, category.Attributes["name"].Value);
                
                ++x;
            }
        }



        // טעינת פרטי כל מסמך - וצירופו לסיווג המתאים
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

            // אם המפתח לא נמצא - סימן שמדובר על קטגוריה שלא מעוניינים להציג, כיוון שהסיווג הוגדר כ
            // enabled = false;
            try
            {
                clientCategories[type] += info;
            }
            catch
            {
                // ...
            }
        }
        List<string> allCategories = new List<string>();
        foreach (var item in clientCategories)
        {
            allCategories.Add(item.Value + "</div>");
        }
        foreach (string item in allCategories)
        {
            records_wrapper.InnerHtml += item;
        }
    }
}