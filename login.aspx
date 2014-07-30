<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
        <link rel="shortcut icon" href="Images/site_icon.ico" />
    <title>מבואת המזכירות</title>
    <link href="Style/RecordsStyle.css" rel="stylesheet" />
    <script src="Scripts/Jquery.js"></script>
    <script>
        $(document).ready(function () {
            // ניהול תפריט
            function ShutAllUp() {
                $(".icon_text").fadeOut();
            }
            $("#mainSite_btn").mouseover(function () {
                ShutAllUp();
                $("#mainSite_text").fadeIn(1000);
            });
            $("#home_btn").mouseover(function () {
                ShutAllUp();
                $("#home_text").fadeIn(1000);
            });
            $("#records_btn").mouseover(function () {
                ShutAllUp();
                $("#records_text").fadeIn(1000);
            });
            $("#comments_btn").mouseover(function () {
                ShutAllUp();
                $("#comments_text").fadeIn(1000);
            });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <nav>
        <table id="menu">
           <tr><td>
               <a href="Home.html"> <img id="home_btn" src="Images/home.ico" class="linkIcon homeIcon" /></a>
           </td>
               <td id="home_text" class="icon_text">עמוד הבית</td>
           </tr>
            <tr><td><a href="Records.aspx">
                <img src="Images/back.ico" class="linkIcon" id="records_btn" /> </a>
           </td>
                <td id="records_text" class="icon_text">מבואת המזכירות</td>
            </tr>
            <tr>                    
                <td><a href="comments.html">
                <img src="Images/comments.ico" class="linkIcon" id="comments_btn" /> </a>
           </td>
           <td id="comments_text" class="icon_text">לוח מודעות</td>
                </tr>
            <tr><td><a href="http://www.hamahanot-haolim.org.il/">
                <img src="Images/site_icon.ico" class="linkIcon" id="mainSite_btn" /> </a>
           </td>
                <td id="mainSite_text" class="icon_text">לאתר המחנות העולים</td>
            </tr>
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
