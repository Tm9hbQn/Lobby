<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
        <link rel="shortcut icon" href="Images/site_icon.ico" />
    <title>מבואת המזכירות</title>
    <link href="Style/RecordsStyle.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <nav>
        <table id="menu">
           <tr><td>
               <a href="Home.html"> <img id="homeIcon" src="Images/home.ico" class="linkIcon" /></a>
           </td></tr>
            <tr><td><a href="Records.aspx">
                <img src="Images/back.ico" class="linkIcon" /> </a>
           </td></tr>
                        <tr><td><a href="comments.html">
                <img src="Images/comments.ico" class="linkIcon" /> </a>
           </td></tr>
            <tr><td><a href="http://www.hamahanot-haolim.org.il/">
                <img src="Images/site_icon.ico" class="linkIcon" /> </a>
           </td></tr>
        </table>
            </nav>
        <section>
    <div id="main_wrapper">
        <h1>התחברות ללוח ניהול המבואה</h1>
        <asp:Label ID="status" runat="server" Text=""></asp:Label>
        <table id="login">
          <tr>
               <td>קוד זיהוי מנהל</td>
              <td> <asp:TextBox ID="passwordBox" runat="server" TextMode="Password"></asp:TextBox></td>              
          </tr>
            <tr> 
                <td style="text-align: center;"><asp:Button ID="Button1" runat="server" Text="אמת זהות" OnClick="Button1_Click" /></td>
            </tr>
        </table>
    </div>
        </section>
    </form>
        <footer>נבנה ע"י נועם לויאן</footer>
</body>
</html>
