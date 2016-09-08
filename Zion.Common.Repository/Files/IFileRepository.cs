using System;
using System.Collections.Generic;

namespace HrMaxx.Common.Repository.Files
{
	public interface IFileRepository
	{
		void DeleteDestinationFile(string file);
		void DeleteFile(string file);
		void DeleteFiles(List<string> files);
		void MoveFile(string source, string destination);
		void MovePDFFile(string source, string destination);
		string GetDocumentLocation(string documentName);
		byte[] GetFile(string documentName);
		byte[] GetFileBytesByPath(string documentPath);
		byte[] GetSourceFileBytesByPath(string documentPath);

		string CreateDirectory(string dirName);
		void DeleteDirectory(string dirName);
		void CopyFile(string source, string destination);
		byte[] ZipDirectory(string source, string fileName);
		List<string> GetDirectoryFiles();
		void MoveDestinationFile(string sourceFileName, string destinationFileName);
		void MoveFile(string source, string destination, byte[] file);
		void SaveUserImage(string user, string image);
		bool FileExists(Guid documentId);
		void DeleteTargetFile(string file);
	}
}