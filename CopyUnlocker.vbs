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
    Do
        SourceFolderPath = InputBox("" & SourceFolderName & " folder not found. Please enter the path to the " & SourceFolderName & " folder:")
        If SourceFolderPath = "" Then
            WScript.Quit
        End If
    Loop Until FSO.FolderExists(SourceFolderPath) And FSO.GetFolder(SourceFolderPath).Name = SourceFolderName
End If

DestinationFolderRoot = "C:\Users\" & WSHShell.ExpandEnvironmentStrings("%USERNAME%") & "\AppData\Local\Roblox\Versions\"

If Not FSO.FolderExists(DestinationFolderRoot) Then
    Do
        DestinationFolderRoot = InputBox("Versions folder does not exist. Please enter the path to the Roblox's Versions folder:")
        If DestinationFolderRoot = "" Then
            WScript.Quit
        End If
    Loop Until FSO.FolderExists(DestinationFolderRoot)
End If

Set VersionsFolder = FSO.GetFolder(DestinationFolderRoot)

FoundTargetFile = False

For Each SubFolder In VersionsFolder.SubFolders
    ' Check if "RobloxPlayerBeta" file exists in the subfolder
    RobloxPlayerBetaFilePath = SubFolder.Path & "\RobloxPlayerBeta.exe"
    If FSO.FileExists(RobloxPlayerBetaFilePath) Then
        TargetFolder = SubFolder.Path & "\" & SourceFolderName
        If FSO.FolderExists(TargetFolder) Then
            response = MsgBox("Source folder '" & SourceFolderName & "' already exists in target folder: " & FSO.GetFileName(SubFolder.Path) & ". Do you want to uninstall The FPS Unlocker?", vbYesNo)
            If response = vbYes Then
                response = MsgBox("Are you sure you want to delete the source folder '" & SourceFolderPath & "' from the target folder '" & TargetFolder & "'?", vbYesNo)
                If response = vbYes Then
                    On Error Resume Next
                    FSO.DeleteFolder(TargetFolder)
                    If Err.Number <> 0 Then
                        WScript.Echo "An error occurred while trying to delete the source folder: " & Err.Description
                        Err.Clear
                    Else
                        WScript.Echo "Source folder '" & SourceFolderPath & "' successfully deleted from target folder: " & TargetFolder
                    End If
                    On Error GoTo 0
                End If
                
            End If
            
            WScript.Quit
            
        Else
            
            response = MsgBox("Do you want to copy the source folder '" & SourceFolderPath & "' to the target folder '" & TargetFolder & "'?", vbYesNo)
            
            If response = vbYes Then
                
                response = MsgBox("Are you sure you want to copy the source folder '" & SourceFolderPath & "' to the target folder '" & TargetFolder & "'?", vbYesNo)
                
                If response = vbYes Then
                    
                    On Error Resume Next
                    
                    FSO.CopyFolder SourceFolderPath, TargetFolder
                    
                    If Err.Number <> 0 Then
                        
                        WScript.Echo "An error occurred while trying to copy the source folder: " & Err.Description
                        
                        Err.Clear
                        
                    Else
                        
                        WScript.Echo "Source folder '" & SourceFolderPath & "' successfully copied to target folder: " & TargetFolder
                        
                        FoundTargetFile = True
                        
                    End If
                    
                    On Error GoTo 0
                    
                End If
                
            End If
            
        End If
        
    End If
    
Next

If Not FoundTargetFile Then
    
    WScript.Echo "No target folder with 'RobloxPlayerBeta' file found."
    
End If
