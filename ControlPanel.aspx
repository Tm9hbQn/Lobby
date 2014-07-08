<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ControlPanel.aspx.cs" Inherits="ControlPanel" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="shortcut icon" href="Images/site_icon.ico" />
    <title>מבואת המזכירות</title>
    <link href="Style/RecordsStyle.css" rel="stylesheet" />
    <script src="Scripts/Jquery.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            // הצגת הוראות עבור סיווג מסמכים חדשים
            $("#furtherInstructions").click(function () {
                $("#instructions").fadeIn(700);
            });
            $("#instructions").click(function () {
                $("#instructions").fadeOut(700);
            });
            $(document).keyup(function (e) {
                $("#instructions").fadeOut(700);
            });


            // הצגת מידע מעודכן עבור רשומה מבוקשת
            $("#idBox").change(function () {

                    // מציאת נתוני הרשומה המבוקשת באמצעות אג'קס
                    $.ajax({
                        type: "GET",
                        url: "LobbyFiles.xml",
                        dataType: "xml",
                        success: xmlParser
                    });
            });
            function formatDateForInput(date) {
                var year = date.getFullYear();
                var month = ("0" + (date.getMonth() + 1)).slice(-2);
                var day = ("0" + date.getDate()).slice(-2);
                return String.format("{0}-{1}-{2}", year, month, day);
            }
            function xmlParser(xml) {
                // מציאת מספר רשומה מבוקש
                $docId = $('#idBox').val();
                // אתחול משתנים
                $docName = "";
                $docType = "";
                $docDate = "";
                $docLink = "";
                $docAuthor = "";
                $docPlce = "";

                foundNode = false;
                // מציאת הרשומה בעלת מספר רשומה המבוקש
                $(xml).find("link").each(function () {

                    $nodeId = $(this).attr("id");
                    if ($nodeId == $docId) {
                        foundNode = true;
                        // הכנסת ערכי הרשומה למשתנים המאותחלים
                        $docName = $(this).text();
                        $docType = $(this).attr("type");
                        $docAuthor = $(this).attr("author");
                        $docDate = $(this).attr("date");
                        $docLink = $(this).attr("url");
                        $docPlce = $(this).attr("place");
                        return false;
                    }
                });
                // לאחר הלולאה אם לא נמצאה רשומה בעלת מספר זה, יחזיר את הערך לאפס ויודיע למשתמש
                // במידה ויימצא - ייקח את כל הערכים הנמצאים במשתנים ויכניסם לטופס
                if (foundNode) {
                    $("#DocNameBox").val($docName);
                    $("#urlBox").val($docLink);
                    $("#placeBox").val($docPlce);
                    $("#authorNameBox").val($docAuthor);

                    switch ($docType) {
                        case "protocol":
                            $("#typeList").val("protocol");
                            break;
                        case "schedule":
                            $("#typeList").val("schedule");
                            break;
                        case "olympus":
                            $("#typeList").val("olympus");
                            break;
                        case "formalPaper":
                            $("#typeList").val("formalPaper");
                            break;
                    }

                    var id = "<%= dateBox.ClientID %>";
                    $("#" + id).val($docDate);
                }
                else {
                    $("#idBox").val("0");
                    alert("מספר רשומה מבוקש לא נמצא!");
                    // איפוס נתוני הטופס על מנת למנוע שמירות חדשות / עריכות לא מכוונות
                    $("#DocNameBox").val("");
                    $("#urlBox").val("");
                    $("#placeBox").val("");
                    $("#authorNameBox").val("");
                    $("#typeList").val("formalPaper");
                    $("#" + id).val();
                    
                }
            }

            // פונקציה זו מקבלת את נתוני הרשומה ומטמיעה אותם בפקדי הדף
        });
           
    </script>
</head>
<body>
    <div id="instructions">
        <div id="instrText">
                <h4 style="margin-top: 1%;">הנחיות להוספת מסמך למבואה</h4>
                      <ul>
         <li>הקישור אותו מוסיפים למסמך תקין.</li>
         <li>המסמך מסווג כראוי לתוכנו.</li>
         <li>שמירה על תמציתיות בכותרת המסמך.</li>
         <li>במידה והמסמך חופף בסוג התוכן למסמך אחר, קראו למסמך על פי כותרת המסמך החופף. <br />
             למשל: סיכום של ישיבה ייכתב כך: סיכום ישיבת מזכירות ; <br />מסמך המכיל פעולה שנכתבה עבור המזכירות ייכתב כך: פעולה #מספר כלשהו - נושא הפעולה.</li>
         <li>במידה ומדובר במסמך שנכתב על ידי אדם כלשהו, ציינו את שמו. במידה והמסמך נכתב בזמן פגישה או שמדובר בסיכום / פרוטוקול - ציינו "המזכירות".</li>
      </ul>

            שימו לב!<br />
            במידה והמסמך עונה על יותר מסיווג מסמך אחד - בחרו בסיווג אשר מציג בצורה הטובה ביותר את מהות המסמך. <br />
            למשל - אם מדובר על לו"ז העבודה של המזכירות בנוגע להכנות מרכז התנועה / עולימפוס, אז הסיווג המתאים הוא לו"ז עבודה.
              </div>
    </div>
    <form id="form1" runat="server">
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
            <div id="main_wrapper">
                <h1>לוח ניהול המבואה</h1>
                <h5 id="details">
                    ניתן להוסיף רשומה חדשה למבואה - או לחילופין לעדכן רשומה קיימת. 
                     על מנת להוסיף רשומה חדשה - השאר את מספר המסמך על 0. 
                     כדי לעדכן רשומה קיימת - הכנס את מספר הרשומה שברצונך לעדכן. <br /> <br />
                    <span id="furtherInstructions">לחץ כאן על מנת להציג הוראות סיווג מסמך חדש</span>
                            </h5>              
            <span id="statusSpan"><asp:Label ID="status" runat="server" Text=""></asp:Label></span>
                
            <table>
                <tr>
                    <td>
                        מספר מסמך:
                    </td>
                    <td>
                        <asp:TextBox ID="idBox" runat="server" TextMode="Number" Text="0"></asp:TextBox>
                    </td>
                </tr>
                                <tr>
                    <td>
                        שם המסמך:
                    </td>
                    <td>
                        <asp:TextBox ID="DocNameBox" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        סוג המסמך:
                    </td>
                    <td>
                        <asp:DropDownList ID="typeList" runat="server">
                            <asp:ListItem Text="מסמך רשמי" Value="formalPaper" Enabled="true"></asp:ListItem>
                            <asp:ListItem Text="פרוטוקול/סיכום ישיבה" Value="protocol" Enabled="true"></asp:ListItem>
                            <asp:ListItem Text="מרכז תנועה/עולימפוס" Value="olympus" Enabled="true"></asp:ListItem>
                            <asp:ListItem Text="לוח זמנים" Value="schedule" Enabled="true"></asp:ListItem>
                            <asp:ListItem Text="פרויקטים של המזכירות" Value="projects" Enabled="true"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>

                    <td>
                        קישור:
                    </td>
                    <td>
                        <asp:TextBox ID="urlBox" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>נכתב ע"י:</td>
                    <td>
                        <asp:TextBox ID="authorNameBox" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>מיקום (ניתן להשאיר ריק):</td>
                    <td>
                        <asp:TextBox ID="placeBox" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>בתאריך:</td>
                    <td>
                        <asp:TextBox ID="dateBox" runat="server" TextMode="Date"></asp:TextBox></td>
                </tr>
            </table>
            <asp:Button ID="Button1" runat="server" Text="הוסף נתונים לקובץ XML" OnClick="Button1_Click" />
        </div>
    
    </form>
        <footer>נבנה ע"י נועם לויאן</footer>
</body>
</html>
