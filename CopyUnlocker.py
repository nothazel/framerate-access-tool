import os
import shutil

source_folder_name = "ClientSettings"
source_folder_path = ""

current_folder = os.path.dirname(os.path.abspath(__file__))
for sub_folder in os.scandir(current_folder):
    if sub_folder.is_dir() and sub_folder.name == source_folder_name:
        source_folder_path = sub_folder.path
        break

if source_folder_path == "":
    print(f"Source Folder '{source_folder_name}' not found.")
    exit()

destination_folder = fr"C:\Users\{os.getlogin()}\AppData\Local\Roblox\Versions"

if not os.path.exists(destination_folder):
    print("Target folder does not exist.")
    exit()

for sub_folder in os.scandir(destination_folder):
    if sub_folder.is_dir() and sub_folder.name.startswith("version-"):
        target_folder = os.path.join(sub_folder.path, source_folder_name)
        if os.path.exists(target_folder):
            print(f"Source folder '{source_folder_name}' already exists in target folder: {os.path.basename(sub_folder.path)}")
            exit()
        else:
            shutil.copytree(source_folder_path, target_folder)
            print(f"Source folder '{source_folder_name}' successfully copied to target folder: {os.path.basename(sub_folder.path)}")