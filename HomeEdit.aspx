<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HomeEdit.aspx.cs" Inherits="HomeEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="ckeditor/ckeditor.js"></script>
    <script src="Scripts/Jquery.js"></script>
    <script>
        $(document).ready(function () {
            CKEDITOR.replace('editor1');
        });
    </script>
</head>
<body>
    <form id="form1" runat="server" method="post">
    <div>
        
        <br /> <br /> <br /> <br /> <br /> <br /> <br /> <br /> <br />
        <textarea id="editor1" cols="20" rows="2"></textarea>
        <input id="Button1" type="button" value="button" />
    </div>
    </form>
</body>
</html>
