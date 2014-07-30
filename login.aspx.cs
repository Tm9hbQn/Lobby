using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.IO;

public partial class login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        // משתמש מחובר יועבר ללוח הניהול
        if (Session["connected"] != null)
            Response.Redirect("controlpanel.aspx");

        // משתמש שניסה להתחבר 4 פעמים לא יוכל לנסות שוב עד סיום הסשן
        if (Request.Cookies["attempts"] == null)
        {
            passwordBox.Enabled = true;
            Button1.Enabled = true;
        }
        else
        {
            status.Text = "נכשלת בניסיון ההתחברות 4 פעמים! נסי/ה שוב בעוד זמן קצר.";
            passwordBox.Enabled = false;
            Button1.Enabled = false;
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        // קלט משתמש
        string password = passwordBox.Text;

        string path = MapPath("~/AdminData.xml");

        bool connect = OpXML.ConfirmIdentity(password, path);

        if (connect)
        {
            Session["connected"] = "true";
            Response.Redirect("ControlPanel.aspx");
        }
        else
        {
            status.Text = "ההתחברות נכשלה! קוד זיהוי שגוי";

            if (Session["trial"] == null)
            {
                Session["trial"] = "1";
                status.Text += " נשארו לך עוד 3 נסיונות התחברות";
            }
            else
            {
                switch (Session["trial"].ToString())
                {
                    case "1":
                        Session["trial"] = "2";
                        status.Text += " נשארו לך עוד 2 נסיונות התחברות";

                        break;
                    case "2":
                        Session["trial"] = "3";
                        status.Text += " נשארו לך עוד 1 נסיונות התחברות";
                        break;
                    case "3":
                        HttpCookie cookie = new HttpCookie("attempts");
                        cookie["number"] = "too much";
                        cookie.Expires = DateTime.Now.AddMinutes(10);
                        Response.Cookies.Add(cookie);
                        status.Text = "נכשלת בניסיון ההתחברות 4 פעמים! נסי/ה שוב בעוד זמן קצר.";
                        passwordBox.Enabled = false;
                        Button1.Enabled = false;
                        break;
                    default:
                        status.Text = "שגיאה לא ידועה. המערכת חוסמת את עצמה עד שהשגיאה תיפתר. אנא פנה למנהל המערכת";
                        break;

                }

            }
        }
    }
}
