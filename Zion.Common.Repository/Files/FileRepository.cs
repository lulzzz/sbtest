using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;

namespace HrMaxx.Common.Repository.Files
{
	public class FileRepository : IFileRepository
	{
		private readonly string _destinationPath;
		private readonly string _sourcePath;
		private readonly string _userImagePath;

		public FileRepository(string destinationPath, string sourcePath, string userimagepath)
		{
			_destinationPath = destinationPath;
			_sourcePath = sourcePath;
			_userImagePath = userimagepath;
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

		public byte[] ZipDirectory(string source, string fileName)
		{
			if (Directory.Exists(source))
			{
				if (File.Exists(_destinationPath + fileName))
					File.Delete(_destinationPath + fileName);
				ZipFile.CreateFromDirectory(source, _destinationPath + fileName, CompressionLevel.Fastest, false);
			}

			return GetFileBytesByPath(_destinationPath + fileName);
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
	}
}