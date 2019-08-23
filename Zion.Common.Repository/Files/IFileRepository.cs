using System;
using System.Collections.Generic;
using HrMaxx.Common.Models.Dtos;

namespace HrMaxx.Common.Repository.Files
{
	public interface IFileRepository
	{
		void DeleteDestinationFile(string file);
		void DeleteFile(string file);
		void DeleteFiles(List<string> files);
		void DeleteArchiveFile(string directory, string name, string toString);

		void MoveFile(string source, string destination);
		void MovePDFFile(string source, string destination);
		string GetDocumentLocation(string documentName);
		byte[] GetFile(string documentName);
		byte[] GetFileBytesByPath(string documentPath);
		byte[] GetSourceFileBytesByPath(string documentPath);

		bool ArchiveFileExists(string rootdirectory, string directory, string fileName);
		string GetArchiveJson(string rootdirectory, string directory, string fileName);
		void SaveArchiveJson(string rootdirectory, string directory, string fileName, string data);

		string CreateDirectory(string dirName);
		void DeleteDirectory(string dirName);
		void CopyFile(string source, string destination);
		byte[] ZipDirectory(string source, string fileName, bool delete = true);
		List<string> GetDirectoryFiles();
		void MoveDestinationFile(string sourceFileName, string destinationFileName);
		void MoveFile(string source, string destination, byte[] file);
		void SaveUserImage(string user, string image);
		bool FileExists(Guid documentId);
		void DeleteTargetFile(string file);
		void SaveFile(Guid id, string documentExtension, byte[] file);
		string SaveFile(string directory, string name, string extension, string content);
		void SaveFile(string directory, string name, string extension, byte[] file);

		void DeleteArchiveDirectory(string rootDirectory, string directory, string name);
		bool FileExists(string dir, string name, string ext);
		string GetFileText(string file);
	}
}