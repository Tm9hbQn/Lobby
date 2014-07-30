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
            // ניהול תפריט
            function ShutAllUp() {
                $(".icon_text").fadeOut();
            }
            $("#comments_btn").mouseover(function () {
                ShutAllUp();
                $("#comments_text").fadeIn(1000);
            });
            $("#mainSite_btn").mouseover(function () {
                ShutAllUp();
                $("#mainSite_text").fadeIn(1000);
            });
            $("#home_btn").mouseover(function () {
                ShutAllUp();
                $("#home_text").fadeIn(1000);
            });
           /* $("#cp_btn").mouseover(function () {
                ShutAllUp();
                $("#cp_text").fadeIn(1000);
            });*/
            $("#records_btn").mouseover(function () {
                ShutAllUp();
                $("#records_text").fadeIn(1000);
            });




            // לא לאפשר שליחת טופס באמצעות אנטר -רק באמצעות הקשה על כפתור השליחה
            $("input").keypress(function(e) {
                if(e.which == 13) {
                    return false;
                }
            });

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
                        success: LoadRecordsData
                    });
            });
            $("#typesList").change(function () {

                // אם מדובר על ניסיון ליצור סיווג חדש - יוודא ניקוי תיבות הטקסט ממידע
                // אם ניסיון לערוך סיווג מסוים - יטען את המידע עליו
                if ($(this).val() == 0) {
                    $("#nameBox").val("");
                    $("#typeBox").val("");
                    $("#nameBox").prop("readonly", false);
                }
                else {
                    $("#nameBox").prop("readonly", true);
                    // מציאת נתוני הסיווג המבוקש
                    $.ajax({
                        type: "GET",
                        url: "Categories.xml",
                        dataType: "xml",
                        success: LoadCategoriesData
                    });
                }
            });
            function formatDateForInput(date) {
                var year = date.getFullYear();
                var month = ("0" + (date.getMonth() + 1)).slice(-2);
                var day = ("0" + date.getDate()).slice(-2);
                return String.format("{0}-{1}-{2}", year, month, day);
            }
            //
            //
            //
            //
            //
            //
            //
            function LoadCategoriesData(xml) {
                $categoryName = "";
                $categoryXmlName = "";
                $enabled = "true";
                // מציאת הסיווג המבוקש
                $(xml).find("category").each(function () {
                    $nodeName = $(this).text();

                    if ($nodeName == $("#typesList").val()) {
                        $categoryName = $(this).attr("name");
                        $categoryXmlName = $(this).text();
                        $enabled = $(this).attr("enabled");
                    }
                });
                // טעינת הערכים שנמצאו לדף עצמו
                $("#typeBox").val($categoryName);
                $("#nameBox").val($categoryXmlName);
                id = "<%= checkBox.ClientID %>";
                if ($enabled == "true") {
                    $("#" + id).prop("checked", true);
                }
                else {
                    $("#" + id).prop("checked", false);
                }
            }
            //
            //
            //
            //
            //
            //
            //
            function LoadRecordsData(xml) {
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
            <div id="main_wrapper">
                <h1>לוח ניהול המבואה</h1>
                <div id="first_container">
                <h5 class="details">
                    ניתן להוסיף רשומה חדשה למבואה - או לחילופין לעדכן רשומה קיימת. 
                     על מנת להוסיף רשומה חדשה - השאר את מספר המסמך על 0. 
                     כדי לעדכן רשומה קיימת - הכנס את מספר הרשומה שברצונך לעדכן. <br /> <br />
                    <span id="furtherInstructions">לחץ כאן על מנת להציג הוראות סיווג מסמך חדש</span>
                            </h5>              
            <span class="statusSpan"><asp:Label ID="status" runat="server" Text=""></asp:Label></span>
                
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
                <br /> <br /> 
                    </div>












                <div id="second_container">
                    <h5 class="details">
                        ניתן לשנות ולהוסיף קטגוריות שונות באתר - קטגוריות אלו יוצגו במבואה. 
                        לא ניתן למחוק סיווגים קיימים - ניתן לבחור שלא להציגם במבואת המזכירות ועמם את כל המסמכים המקושרים אל הסיווג.
                        כל שינוי בחלק זה של האתר חייב להיות מאושר ומתוכנן מראש ע"י המזכירות!
                         <span class="statusSpan"><asp:Label ID="status2" runat="server" Text=""></asp:Label></span>
                    </h5> 

                    <table>
                        <tr>
                            <td>סוג מסמך:</td>
                            <td><asp:DropDownList ID="typesList" runat="server">
                                <asp:ListItem Selected="True" Text="סוג חדש" Value="0"></asp:ListItem>
                                </asp:DropDownList></td>
                        </tr>
                        <tr>
                            <td>
                                שם הסיווג:
                            </td>
                            <td>
                                <asp:TextBox ID="typeBox" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>סיווג עבור XML: <span  style="color: #0094ff; font-weight: 700; font-size:11px;" title="ניתן לקבוע רק עבור סיווגים חדשים. השם הניתן לסיווג הוא השם בו הוא ייקרא בקבצי המבואה הפנימיים (הגולש אינו חשוף לשם זה). יש לכתוב שם באנגלית וללא רווחים, המתאר בתמציתיות (מילה או שתי מילים מחוברות) את מהות הסיווג - עדיף את תרגום הסיווג לאנגלית">(?)</span></td>
                            <td>
                                <asp:TextBox ID="nameBox" runat="server" ></asp:TextBox>
                            </td>        
                        </tr>
                        <tr>
                           <td>האם להציג סיווג זה במבואה:</td>
                            <td>
                                <asp:CheckBox ID="checkBox" Checked="true" runat="server" /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Button ID="Button2" runat="server" Text="עדכן מבואה" OnClick="Button2_Click" /></td>
                        </tr>
                    </table>
                </div>
                </div>
    </form>
        <footer>נבנה ע"י נועם לויאן</footer>
</body>
</html>
