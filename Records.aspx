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
            $("#comments_btn").mouseover(function () {
                ShutAllUp();
                $("#comments_text").fadeIn(1000);
            });
            $("#cp_btn").mouseover(function () {
                ShutAllUp();
                $("#cp_text").fadeIn(1000);
            });


            $('#records_wrapper').cycle({
                fx: 'fade',
                speed: '1500',
                timeout: 0,
                next: '#next',
                prev: '#prev',
            });
            $("#next").click(function () {
                CycleCategories(1);
            });
            $("#prev").click(function () {
                CycleCategories(-1);
            });

            // הערך של פלוס מסמל +1 או -1 
            function CycleCategories(plus) {
                found = -1;
                // מציאת האיידי הנוכחי המוגדל
                $("#categories_wrapper").children().each(function () {
                    size = $(this).css("font-size");
                    if (size == "20px") {
                        found = $(this).prop("id");
                        $(this).css("font-size", "13px");
                        $(this).css("border", "none");
                    }
                });
                nowId = parseInt(found);
                lastId = $("#categories_wrapper").children().last().prop("id");
                if (nowId == 0 && plus == -1)
                {
                    nowId = lastId;
                }
                else
                {
                    nowId += plus;
                    if (nowId > $("#categories_wrapper").children().last().prop("id"))
                        nowId = 0;
                }
                $("#" + nowId).animate({ fontSize: '20px' }, 300);
                $("#" + nowId).css("border-bottom", "2px solid #0094ff");
            }

            $(document).keyup(function (e) {
                if (e.keyCode == 37) {
                    $('#records_wrapper').cycle('next');
                    CycleCategories(1);
                }
                else if (e.keyCode == 39) {
                    $('#records_wrapper').cycle('prev');
                    CycleCategories(-1);
                }
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
                           <tr><td><a href="ControlPanel.aspx">
                <img src="Images/start_here_kubuntu.ico" class="ToCP linkIcon" id="cp_btn"/> </a>
           </td>
                    <td id="cp_text" class="icon_text">לוח בקרה</td>
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
         <h1>מבואת המזכירות</h1><br />
                <div id="arrows_wrapper">
         <img src="Images/Right.ico" id="prev" />   <img src="Images/Left.ico" id="next"/>
        </div>
                    <div id="categories_wrapper" runat="server">

            </div>
        <div id="records_wrapper" runat="server">
         </div>
        </div> 
            </section>
    </form>
        <footer>נבנה ע"י נועם לויאן</footer>
</body>
</html>
