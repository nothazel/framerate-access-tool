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

DestinationFolderRoot = "C:\Users\" & WSHShell.ExpandEnvironmentStrings("%USERNAME%") & "\AppData\Local\Roblox\Versions\"

If Not FSO.FolderExists(DestinationFolderRoot) Then
    WScript.Echo "Target folder does not exist."
    WScript.Quit
End If

Set VersionsFolder = FSO.GetFolder(DestinationFolderRoot)

FoundTargetFile = False

For Each SubFolder In VersionsFolder.SubFolders
    ' Check if "RobloxPlayerBeta" file exists in the subfolder
    RobloxPlayerBetaFilePath = SubFolder.Path & "\RobloxPlayerBeta.exe"
    If FSO.FileExists(RobloxPlayerBetaFilePath) Then
        TargetFolder = SubFolder.Path & "\" & SourceFolderName
        If FSO.FolderExists(TargetFolder) Then
            WScript.Echo "Source folder '" & SourceFolderName & "' already exists in target folder: " & FSO.GetFileName(SubFolder.Path)
            WScript.Quit
        Else
            FSO.CopyFolder SourceFolderPath, TargetFolder
            WScript.Echo "Source folder '" & SourceFolderName & "' successfully copied to target folder: " & FSO.GetFileName(SubFolder.Path)
            FoundTargetFile = True
        End If
    End If
Next

If Not FoundTargetFile Then
    WScript.Echo "No target folder with 'RobloxPlayerBeta' file found."
End If
