using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using HrMaxx.Common.Models.Dtos;

namespace HrMaxx.Common.Repository.Files
{
	public class FileRepository : IFileRepository
	{
		private readonly string _destinationPath;
		private readonly string _archivePath;
		private readonly string _sourcePath;
		private readonly string _pdfSourcePath;
		private readonly string _userImagePath;

		public FileRepository(string destinationPath, string sourcePath, string userimagepath, string archivePath)
		{
			_destinationPath = destinationPath;
			_archivePath = archivePath;
			_sourcePath = sourcePath;
			_userImagePath = userimagepath;
			_pdfSourcePath = _destinationPath + "PDFTemp/";
		}

		public void DeleteDestinationFile(string file)
		{
			File.Delete(_destinationPath + file);
		}

		public void DeleteFile(string file)
		{
			file = _sourcePath + file;
			if (File.Exists(file))
				File.Delete(file);
		}

		public void DeleteFiles(List<string> files)
		{
			foreach (string file in files)
				DeleteFile(file);
		}

		public void MoveFile(string source, string destination)
		{
			string destPath = _destinationPath + destination;
			string srcPath = _sourcePath + source;
			File.Move(srcPath, destPath);
		}

		public void MovePDFFile(string source, string destination)
		{
			string destPath = _destinationPath + destination;
			string srcPath = _pdfSourcePath + source;
			File.Copy(srcPath, destPath, true);
			File.Delete(srcPath);
		}

		public string GetDocumentLocation(string documentName)
		{
			return _destinationPath + documentName;
		}

		public byte[] GetFile(string documentName)
		{
			return GetFileBytesByPath(_destinationPath + documentName);
		}

		public byte[] GetFileBytesByPath(string documentPath)
		{
			return File.ReadAllBytes(documentPath);
		}

		public byte[] GetSourceFileBytesByPath(string documentPath)
		{
			return File.ReadAllBytes(_sourcePath + documentPath);
		}

		public string GetArchiveJson(string rootdirectory, string directory, string fileName)
		{
			var filename =
                $"{_archivePath}{rootdirectory}\\{(string.IsNullOrWhiteSpace(directory) ? string.Empty : directory + "\\")}{fileName}.json";
			return File.ReadAllText(filename);
		}
		public bool ArchiveFileExists(string rootdirectory, string directory, string fileName)
		{
			var filename =
                $"{_archivePath}{rootdirectory}\\{(string.IsNullOrWhiteSpace(directory) ? string.Empty : directory + "\\")}{fileName}.json";
			return File.Exists(filename);
		}

		public void SaveArchiveJson(string rootdirectory, string directory, string name, string data)
		{
			var invalidChars = Path.GetInvalidFileNameChars();

			name = new string(name
			.Where(x => !invalidChars.Contains(x))
			.ToArray());
			var fileName =
                $"{_archivePath}{rootdirectory}\\{(string.IsNullOrWhiteSpace(directory) ? string.Empty : directory + "\\")}{name}.json";
			if (File.Exists(fileName))
			{
				File.Delete(fileName);
			}
			var fileInfo = new FileInfo(fileName);
			if (fileInfo.Directory != null && !fileInfo.Directory.Exists) 
				fileInfo.Directory.Create();
			File.WriteAllText(fileName, data);
		}

		public string CreateDirectory(string dirName)
		{
			if (!Directory.Exists(_destinationPath + dirName))
				return Directory.CreateDirectory(_destinationPath + dirName).FullName;
			return _destinationPath + dirName;
		}

		public void DeleteDirectory(string dirName)
		{
			if (Directory.Exists(dirName))
				Directory.Delete(dirName, true);
		}

		public void CopyFile(string source, string destination)
		{
			if (File.Exists(_destinationPath + source))
				File.Copy(_destinationPath + source, destination);
		}

		public byte[] ZipDirectory(string source, string fileName, bool delete = true)
		{
			if (Directory.Exists(source))
			{
				if (File.Exists(_destinationPath + fileName))
					File.Delete(_destinationPath + fileName);
				ZipFile.CreateFromDirectory(source, _destinationPath + fileName, CompressionLevel.Fastest, false);
			}
			//Directory.Delete(source, true);
			var bytes = GetFileBytesByPath(_destinationPath + fileName);
			if(delete)
				File.Delete(_destinationPath + fileName);
			return bytes;
		}

		public List<string> GetDirectoryFiles()
		{
			return Directory.GetFiles(_destinationPath)
				.Select(f => Path.GetFileName(f))
				.ToList();
		}

		public void MoveDestinationFile(string sourceFileName, string destinationFileName)
		{
			string destPath = _destinationPath + destinationFileName;
			string srcPath = _destinationPath + sourceFileName;
			if (!File.Exists(srcPath)) return;
			File.Copy(srcPath, destPath, true);
			File.Delete(srcPath);
		}

		public void MoveFile(string source, string destination, byte[] file)
		{
			string destPath = _destinationPath + destination;
			string srcPath = _sourcePath + source;
			File.Delete(srcPath);
			using (var f = new FileStream(destPath, FileMode.Create, FileAccess.Write))
			{
				f.Write(file, 0, file.Length);
			}
		}

		public void SaveUserImage(string user, string image)
		{
			if (!string.IsNullOrWhiteSpace(_userImagePath))
			{
				string dest = _userImagePath + user + ".jpg";
				if (File.Exists(dest))
					File.Delete(dest);
				byte[] imageBytes = Convert.FromBase64String(image);
				using (var f = new FileStream(dest, FileMode.Create, FileAccess.Write))
				{
					f.Write(imageBytes, 0, imageBytes.Length);
				}
			}
		}

		public bool FileExists(Guid documentId)
		{
			string destPath = documentId + ".*";
			var dir = new DirectoryInfo(_destinationPath);
			return dir.GetFiles(destPath).Any();
		}

		public void DeleteTargetFile(string file)
		{
			File.Delete(file);
		}

		public void SaveFile(Guid id, string documentExtension, byte[] file)
		{
			var filePath = $"{_destinationPath}{id}.{documentExtension}";
			if (File.Exists(filePath))
			{
				File.Delete(filePath);
			}
			File.WriteAllBytes(filePath, file);
		}

		public string SaveFile(string directory, string name, string extension, string content)
		{

			var invalidChars = Path.GetInvalidFileNameChars();

			name = new string(name
			.Where(x => !invalidChars.Contains(x))
			.ToArray());
            directory = directory.Contains(_destinationPath)
                ? directory
                : $"{_destinationPath}{directory}";
            var fileName = $"{directory}\\{name}.{extension}";
			if (File.Exists(fileName))
			{
				File.Delete(fileName);
			}
			File.WriteAllText(fileName, content);
			return fileName;
		}
		public void SaveFile(string directory, string name, string extension, byte[] content)
		{

			var invalidChars = Path.GetInvalidFileNameChars();

			name = new string(name
			.Where(x => !invalidChars.Contains(x))
			.ToArray());
            directory = directory.Contains(_destinationPath)
                ? directory
                : $"{_destinationPath}{directory}";
			var fileName = $"{directory}\\{name}.{extension}";
			if (File.Exists(fileName))
			{
				File.Delete(fileName);
			}
			File.WriteAllBytes(fileName, content);
		}

		public void DeleteArchiveDirectory(string rootDirectory, string directory, string name)
		{
			DeleteDirectory($"{_archivePath}{rootDirectory}\\{directory}\\{name}");
		}

		public bool FileExists(string directory, string name, string ext)
		{
			var invalidChars = Path.GetInvalidFileNameChars();

			name = new string(name
			.Where(x => !invalidChars.Contains(x))
			.ToArray());
            directory = directory.Contains(_destinationPath)
                ? directory
                : $"{_destinationPath}{directory}";
            var fileName = $"{directory}\\{name}.{ext}";
			return File.Exists(fileName);

		}

		public string GetFileText(string file)
		{
			return File.ReadAllText(file);
		}

        public void PurgeDocuments(string directory, int days)
        {
            directory = directory.Contains(_destinationPath)
                ? directory
                : $"{_destinationPath}{directory}";

            var files = Directory.GetFiles(directory)
                .Select(f => new FileInfo(f))
                .Where(f=>f.LastWriteTime < DateTime.Today.AddDays(-1*days))
                .ToList();
                //.ForEach(f=>f.Delete()));
            files.ForEach(f => f.Delete());
        }

        public void DeleteArchiveFile(string rootDirectory, string directory, string name)
		{
			var fileName =
                $"{_archivePath}{rootDirectory}\\{(string.IsNullOrWhiteSpace(directory) ? string.Empty : directory + "\\")}{name}.json";
			if (File.Exists(fileName))
			{
				File.Delete(fileName);
			}
		}
	}
}