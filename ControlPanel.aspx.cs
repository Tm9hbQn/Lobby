using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.IO;

public partial class ControlPanel : System.Web.UI.Page
{
    protected void ReloadPage(bool allControls)
    {
        // ניקוי הרשימה לקראת מילוי מחדש
        for (int i = 1; i < typesList.Items.Count; i++)
        {
            typesList.Items.RemoveAt(1);
        }
        // ניקוי הרשימה לקראת מילוי מחדש
        for (int i = 1; i < typeList.Items.Count; i++)
        {
            typeList.Items.RemoveAt(1);
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["connected"] == null)
            Response.Redirect("login.aspx");

        // טעינת רשימת הסיווגים לטופס השני
        XmlNodeList nodes = OpXML.GetXmlDataFromFile(MapPath("~/Categories.xml"), "category");
        for (int i = 0; i < nodes.Count; ++i)
        {
            string text = nodes[i].Attributes["name"].Value;
            string name = nodes[i].InnerText;
            ListItem item = new ListItem(text, name, true);
            typesList.Items.Add(item);
            typeList.Items.Add(item);
        }
    }


    /// <summary>
    /// מחזיר 1 אם הצלחה, 0 אם כישלון
    /// </summary>
    /// <param name="docName"></param>
    /// <param name="authorName"></param>
    /// <returns></returns>

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
        if ((id >= 0) && id < OpXML.GetXmlDataFromFile(MapPath("~/LobbyFiles.xml"), "link").Count + 1)
        {
            string name = DocNameBox.Text;
            string author = authorNameBox.Text;
            string place = placeBox.Text;
            string url = urlBox.Text;
            string type = typeList.SelectedValue;
            string date = dateBox.Text;

            // בדיקה האם מדובר ברשומה חדשה או בעדכון רשומה קיימת
            int i = OpXML.InsertNewNodeToXmlFile(MapPath("~/LobbyFiles.xml"), name, author, date, place, type, url, id);


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
                ReloadPage(true);
            }
        }
        else
            status.Text = "עדכון הרשומה נכשל - מספר רשומה שגוי!";


    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        status2.Text = "";
        string path = MapPath("~/Categories.xml");
        string xmlName = nameBox.Text;
        string name = typeBox.Text;
        string enabled = checkBox.Checked.ToString().ToLower();
        bool isNew = false;
        if (typesList.SelectedIndex == 0)
        {
            isNew = true;
        }
        else
        {
            nameBox.ReadOnly = true;
        }

        int success = OpXML.InsertNewCategoryToXmlFile(path, xmlName, name, enabled, isNew);
        if (success == 1)
            status2.Text += "עדכון הסיווג הצליח!";
        else
            status2.Text += "עדכון הסיווג נכשל!";

        ReloadPage(true);
        // ניקוי הטופס
        nameBox.Text = string.Empty;
        typeBox.Text = string.Empty;
            
    }
}
