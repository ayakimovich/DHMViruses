/* 
 *  Nanolive batch scaling and color merging
 *  Artur Yakimovich (c) copyright 2017
 */

function getAllOpenWindows(returnType){
		names = newArray(nImages); 
		ids = newArray(nImages);
		print("number of open Imgages is: " + nImages); 
		for (i=0; i < ids.length; i++){ 
        	selectImage(i+1); 
        	ids[i] = getImageID(); 
        	names[i] = getTitle(); 
        	print(ids[i] + " = " + names[i]);
		}
		if(returnType=="ids"){
           return ids;
        }
        else if(returnType=="names"){
           return names;
        }
}


function getDirAndFileList(ReadPath, filePattern, listType){
	 //listType = "dir" or "file", file default
	 list = getFileList(ReadPath);
	//clean up the file list
	dirList = newArray();
	fileList = newArray();
	
	for(i=0; i<=list.length-1; i++){
		if (matches(list[i], filePattern))
			fileList = Array.concat(fileList, list[i]);
	}
	 if (listType == "file"){
		return fileList;
	}
	else {
		return fileList;
	}
}



inDir = getDirectory("Select the input folder..."); 
outDir = inDir + File.separator + "rgb";
File.makeDirectory(outDir);

setBatchMode(true);
conditionsDir = getDirAndFileList(inDir, ".*_/", "file");
Array.print(conditionsDir);
for (iCondition=0; iCondition < conditionsDir.length; iCondition++){
	timepointsDir = getDirAndFileList(inDir+File.separator+conditionsDir[iCondition], ".*/", "file");
	Array.print(timepointsDir);
	for (iTP=0; iTP < timepointsDir.length; iTP++){
		files = getDirAndFileList(inDir+File.separator+conditionsDir[iCondition]+File.separator+timepointsDir[iTP], ".*.tiff", "file");
		Array.print(files);
		for (iFiles=0; iFiles < files.length; iFiles++){
			print(files[iFiles]);
			open(inDir+File.separator+conditionsDir[iCondition]+File.separator+timepointsDir[iTP]+File.separator+files[iFiles]);
			title = getTitle();
			
			run("Z Project...", "projection=[Max Intensity]");
			close(title);
			selectWindow("MAX_"+title);
			//run("Enhance Contrast", "saturated=0.35");
			run("Gamma...", "value=1.001");
			//run("Red Hot");
			run("16 colors");
			setMinAndMax(1.3370, 1.4); //1.3842
			run("RGB Color");
			path = outDir+File.separator+replace(conditionsDir[iCondition],"/","")+replace(timepointsDir[iTP],"/","")+"_"+files[iFiles];
			
			//path = replace(path,"\\d","d");
			print(path);
			saveAs("Tiff", path);
			
			title = getTitle();
			close(title);
		}
	}
}