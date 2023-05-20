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

If Not FSO.FolderExists(DestinationFolder) Then
    WScript.Echo "Target folder does not exist."
    WScript.Quit
End If

Set VersionsFolder = FSO.GetFolder(DestinationFolder)

For Each SubFolder In VersionsFolder.SubFolders
    If Left(SubFolder.Name, 8) = "version-" Then
        Dim TargetFolder
        TargetFolder = SubFolder.Path & "\" & SourceFolderName
        If FSO.FolderExists(TargetFolder) Then
            WScript.Echo "Source folder '" & SourceFolderName & "' already exists in target folder: " & FSO.GetFileName(SubFolder.Path)
            WScript.Quit
        Else
            FSO.CopyFolder SourceFolderPath, TargetFolder
            WScript.Echo "Source folder '" & SourceFolderName & "' successfully copied to target folder: " & FSO.GetFileName(SubFolder.Path)
        End If
    End If
Next
