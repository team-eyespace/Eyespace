var fs = require('fs');

fs.readFile('busticket.jpg', function(err, data) {
  if (err) throw err;
  console.log(data);
});


var fs = require("fs");
var encodedImage;
var decodedImage
fs.readFile('busticket.jpg', function(err, data) {
  if (err) throw err;

  // Encode to base64
  encodedImage = Buffer.from(data, 'binary').toString('base64');

  // Decode from base64
  decodedImage = Buffer.from(encodedImage, 'base64').toString('binary');
});


//Method 2
window.URL = window.URL || window.webkitURL

$http({
  url: image,
  responseType: 'blob'
}).then(blob => {
  // change the type
  blob = new Blob([blob], {type: 'image/png'})
  $scope.model.view.image = URL.createObjectURL(blob)
})

// Other Code Useful
public bool IsBase64String(string s)
{
  s = s.Trim();
  return (s.Length % 4 == 0) && Regex.IsMatch(s, @"^[a-zA-Z0-9\+/]*={0,3}$", RegexOptions.None);

}

 public void LoadImage()
{
  string string64 = "R0lGODlhAQABAIAAAAAAAAAAACH5BAAAAAAALAAAAAABAAEAAAICTAEAOw==";
  bool isStringValid = this.IsBase64String(string64);
  if (isStringValid)
  {
     byte[] bytes = Convert.FromBase64String(string64);
     System.Drawing.Image image;
     using (MemoryStream ms = new MemoryStream(bytes))
     {
        image = System.Drawing.Image.FromStream(ms);
        //image.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
     }                
   }            
}

// blob can be:
// - https://developer.mozilla.org/en-US/docs/Web/API/Blob
// - https://developer.mozilla.org/en-US/docs/Web/API/File
function readAsBase64(blob, cb) {
	var r = new FileReader();
	r.onload = function() {
		var data = r.result;
		cb(data.substr(data.indexOf(',') + 1);
	};
	r.readAsDataURL(blob);
}

readAsBase64(..., function(base64) {
	...
});


//Useful Data

(defun my-mime-imagetype (fname)
  (let (imtype
        mime-info
        subtype)
    (when (stringp fname)
      (setq mime-info (mime-find-file-type fname))
      (and (string-equal (car mime-info) "image")
           (setq subtype (car (cdr mime-info)))
           (setq imtype (intern subtype))))
    imtype))

(defun my-mime-entity-situation (oldfunc &rest args)
  (let* ((result   (apply oldfunc args))
         (filename (cdr (assq 'filename result)))
         (type     (cdr (assq 'type     result)))
         (subtype  (cdr (assq 'subtype  result)))
         imtype)
    (when (and (eq type    'application)
               (eq subtype 'octet-stream)
               (setq imtype (my-mime-imagetype filename)))
      (setf (alist-get 'type    result) 'image)
      (setf (alist-get 'subtype result) imtype))
    result))
(advice-add 'mime-entity-situation :around #'my-mime-entity-situation)

//ASP.net code for Octet Stream Help
<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<script runat="server">
    public string connectString = "Data Source=.;Initial Catalog=Northwind;Persist Security Info=True;User ID=sa;Password=muhan520!@";
    public byte[] ReadFileFromDB(int id, string connectString)
    {
        SqlConnection conn = new SqlConnection(connectString);
        byte[] file = null;
        try
        {
            conn.Open();
            SqlCommand cmd = conn.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "ReadFile";
            SqlParameter ID = cmd.Parameters.Add("@ID", SqlDbType.BigInt);
            ID.Direction = ParameterDirection.Input;
            ID.Value = id;
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                file = (byte[])reader["FileBinaryContent"];
            }
            reader.Close();
        }
        catch (SqlException ex)
        {
            Console.WriteLine(ex.ToString());
        }
        finally
        {
            conn.Close();
        }
        return file;
    }


    public int AddFileToDB(string connectString)
    {
        using (SqlConnection conn = new SqlConnection(connectString))
        {
            int ExeRes = 0;
            FileStream st = new FileStream(Server.MapPath("Demo.txt"), FileMode.Open);
            byte[] fileData = new byte[st.Length];
            st.Read(fileData, 0, (int)st.Length);
            st.Close();
            conn.Open();
            SqlCommand cmd = new SqlCommand("InsertFile", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlParameter FileBinaryContent = cmd.Parameters.Add("@FileBinaryContent", SqlDbType.VarBinary, int.MaxValue);
            FileBinaryContent.Value = fileData;
            SqlParameter FileType = cmd.Parameters.Add("@FileType", SqlDbType.NVarChar, 50);
            FileType.Value = ddlFileType.SelectedItem.Value.ToString();
            ExeRes = cmd.ExecuteNonQuery();
            return ExeRes;


        }
    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        AddFileToDB(connectString);
    }


    protected void btnRead_Click(object sender, EventArgs e)
    {
        byte[] fileData = ReadFileFromDB(int.Parse(ddlID.SelectedItem.Value), connectString);
        Response.ClearContent();
        BinaryWriter bw = new BinaryWriter(Response.OutputStream);
        bw.Write(fileData);
        bw.Close();
        Response.ContentType = ReturnExtension(".txt");
        Response.End();
     



    }


    private string ReturnExtension(string fileExtension)
    {
        switch (fileExtension)
        {
            case ".htm":
            case ".html":
            case ".log":
                return "text/HTML";
            case ".txt":
                return "text/plain";
            case ".doc":
                return "application/ms-word";
            case ".tiff":
            case ".tif":
                return "image/tiff";
            case ".asf":
                return "video/x-ms-asf";
            case ".avi":
                return "video/avi";
            case ".zip":
                return "application/zip";
            case ".xls":
            case ".csv":
                return "application/vnd.ms-excel";
            case ".gif":
                return "image/gif";
            case ".jpg":
            case "jpeg":
                return "image/jpeg";
            case ".bmp":
                return "image/bmp";
            case ".wav":
                return "audio/wav";
            case ".mp3":
                return "audio/mpeg3";
            case ".mpg":
            case "mpeg":
                return "video/mpeg";
            case ".rtf":
                return "application/rtf";
            case ".asp":
                return "text/asp";
            case ".pdf":
                return "application/pdf";
            case ".fdf":
                return "application/vnd.fdf";
            case ".ppt":
                return "application/mspowerpoint";
            case ".dwg":
                return "image/vnd.dwg";
            case ".msg":
                return "application/msoutlook";
            case ".xml":
            case ".sdxl":
                return "application/xml";
            case ".xdp":
                return "application/vnd.adobe.xdp+xml";
            default:
                return "application/octet-stream";
        }
    }


    

</script>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:DropDownList ID="ddlFileType" runat="server">
            <asp:ListItem>text/plain</asp:ListItem>
            <asp:ListItem>text/HTML</asp:ListItem>
            <asp:ListItem>image/gif</asp:ListItem>
            <asp:ListItem>image/jpeg</asp:ListItem>
        </asp:DropDownList>
        <asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click" />
        <asp:DropDownList ID="ddlID" runat="server">
            <asp:ListItem>1</asp:ListItem>
            <asp:ListItem>2</asp:ListItem>
            <asp:ListItem>3</asp:ListItem>
            <asp:ListItem>4</asp:ListItem>
            <asp:ListItem>5</asp:ListItem>
            <asp:ListItem>6</asp:ListItem>
            <asp:ListItem>7</asp:ListItem>
            <asp:ListItem>8</asp:ListItem>
        </asp:DropDownList>
        <asp:Button ID="btnRead" runat="server" Text="Read" OnClick="btnRead_Click" />
    </div>
    </form>
</body>
</html>





var jpeg = require('jpeg-js');
var jpegData = fs.readFileSync('busticket.jpg');
var rawImageData = jpeg.decode(jpegData, true); // return as Uint8Array
const imageUrl = rawImageData.data;