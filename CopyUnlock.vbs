Dim FSO, WSHShell
Set FSO = CreateObject("Scripting.FileSystemObject")
Set WSHShell = CreateObject("WScript.Shell")

SourceFolderName = "ClientSettings"
SourceFolderPath = ""

' Search for the source folder in the current directory
CurrentFolder = FSO.GetParentFolderName(WScript.ScriptFullName)
Set CurrentFolderObj = FSO.GetFolder(CurrentFolder)
For Each SubFolder In CurrentFolderObj.SubFolders
    If SubFolder.Name = SourceFolderName Then
        SourceFolderPath = SubFolder.Path
        Exit For
    End If
Next

If SourceFolderPath = "" Then
    WScript.Echo "Source folder '" & SourceFolderName & "' not found."
    WScript.Quit
End If

DestinationFolder = "C:\Users\" & WSHShell.ExpandEnvironmentStrings("%USERNAME%") & "\AppData\Local\Roblox\Versions\"

Set VersionsFolder = FSO.GetFolder(DestinationFolder)

For Each SubFolder In VersionsFolder.SubFolders
    If Left(SubFolder.Name, 8) = "version-" Then
        Dim TargetFolder
        TargetFolder = SubFolder.Path & "\" & SourceFolderName
        If Not FSO.FolderExists(TargetFolder) Then
            FSO.CopyFolder SourceFolderPath, TargetFolder
        End If
    End If
Next
