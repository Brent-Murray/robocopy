import os
import zipfile
import sys

try:
    from tqdm import tqdm  # Try to import tqdm
except ModuleNotFoundError:
    # If tqdm is not installed, install it
    print("Installing tqdm...")
    os.system("pip install tqdm")
    from tqdm import tqdm  # Now import tqdm

def zip_folders_in_directory(directory_path=None):
    try:
        # If no directory_path is provided, use the directory where this script is located
        if directory_path is None:
            script_dir = os.path.dirname(os.path.abspath(__file__))
            directory_path = script_dir

        # Validate if the provided path is a directory
        if not os.path.isdir(directory_path):
            raise ValueError("The provided path is not a directory.")

        # Get the list of folders in the specified directory
        folders = [f for f in os.listdir(directory_path) if os.path.isdir(os.path.join(directory_path, f))]

        # Calculate the total number of folders to zip
        total_folders = len(folders)

        # Loop through the folders and create zip files with tqdm for progress bar
        for folder in tqdm(folders, desc="Zipping Folders", unit="folder"):
            zip_filename = os.path.join(directory_path, f"{folder}.zip")
            with zipfile.ZipFile(zip_filename, 'w', zipfile.ZIP_DEFLATED) as zipf:
                folder_path = os.path.join(directory_path, folder)
                # Walk through all files and subdirectories, including empty folders
                for root_dir, dirs, files in os.walk(folder_path):
                    for file in files:
                        file_path = os.path.join(root_dir, file)
                        arcname = os.path.relpath(file_path, folder_path)
                        zipf.write(file_path, arcname)
                    for dir_name in dirs:
                        dir_path = os.path.join(root_dir, dir_name)
                        arcname = os.path.relpath(dir_path, folder_path)
                        zipf.write(dir_path, arcname)

        print("Folders and contents zipped successfully.")

    except Exception as e:
        print(f"An error occurred: {str(e)}")

if __name__ == "__main__":
    zip_folders_in_directory()
