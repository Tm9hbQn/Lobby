<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Records.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta property="og:title" content="מבואת המזכירות - המחנות העולים"/>
<meta property="og:image" content="Images/open_graph_logo.png" />
<meta property="og:site_name" content="מבואת המזכירות - המחנות העולים"/>
<meta property="og:description" content="מבואת המזכירות משמשת ארכיון ולוח מודעות. דרך המבואה ניתן לעיין ולהגיע לכל מסמכי המוסדות החניכים של תנועת המחנות העולים - פרוטוקולים, לוחות זמנים, מסמכים רשמיים ועוד." />
  
    <link rel="shortcut icon" href="Images/site_icon.ico" />
    <title>מבואת המזכירות</title>
    <script src="Scripts/Jquery.js"></script>
    <script src="Scripts/CyclePlugin.js"></script>
    <link href="Style/RecordsStyle.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            $('#cycle_wrapper').cycle({
                fx: 'fade',
                speed: '1500',
                timeout: 0,
                next: '#next',
                prev: '#prev'
            });
            $(document).keyup(function (e) {
                if (e.keyCode == 39)
                    $('#cycle_wrapper').cycle('next');
                else if (e.keyCode == 37)
                    $('#cycle_wrapper').cycle('prev');
            });
            
        });
    </script>
</head>
<body>
    <form id="form1" runat="server"> 
        <nav>
        <table id="menu">
            <tr><td><a href="ControlPanel.aspx">
                <img id="ToCP" src="Images/start_here_kubuntu.ico" class="linkIcon" /> </a>
           </td></tr>
           <tr><td>
               <a href="Home.html"> <img id="homeIcon" src="Images/home.ico" class="linkIcon" /></a>
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
        <div id="arrows_wrapper">
         <h1>מבואת המזכירות</h1><br />
         <img src="Images/Right.ico" id="next" />   <img src="Images/Left.ico" id="prev"/>
        </div>
        <div id="cycle_wrapper">
           <div id="formalPaper" class="section_wrapper" runat="server">
               <h2>מסמכים רשמיים</h2>
           </div>
           <div id="projects" class="section_wrapper" runat="server">
               <h2>פרויקטים אחרים</h2>
           </div>
           <div id="protocol" class="section_wrapper" runat="server">
               <h2>פרוטוקולים וסיכומי ישיבות</h2>
           </div>
           <div id="schedule" class="section_wrapper" runat="server">
               <h2>לוחות זמנים</h2>
           </div>
           <div id="olympus" class="section_wrapper" runat="server">
               <h2>מרכז תנועה / כנס עולימפוס</h2>
           </div>

         </div>
    </div>
            </section>
    </form>
        <footer>נבנה ע"י נועם לויאן</footer>
</body>
</html>
