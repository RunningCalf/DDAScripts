#!/usr/bin/python
# In stability tests, they need to treat EMMA cube as DDA mode. To do this, we need add following lines in function CDSSReportDefinition::Read(…)
# in file /COM/SourceCode/DSSReport/CDSSReportDefinition.cpp
#	void CDSSReportDefinition::Read(…)
#	{
#		…
#		// Treat all emma cube as DDA mode
#		if (!mEmmaCubeDefnPtr.IsNull())
#		{
#			mDatasetServeMode.mValue = DssDatasetServeAsModel;
#		}
#	}
import os
import sys
import re

if len(sys.argv) < 2:
        print len(sys.argv)
        sys.exit(1)
srcFileName = sys.argv[1]
srcFile = open(srcFileName, 'r')
targetFile = open("srcTemp", 'w')
isFuncStart = False
isFuncEnd = False
isFuncNameFound = False
braceCnt = 0
for line in srcFile.readlines():
        if not isFuncNameFound and re.search('void\s+CDSSReportDefinition::Read\(', line):
                isFuncNameFound = True
                if re.search('{', line):
                        braceCnt += 1
                        isFuncStart = True
        if isFuncNameFound and not isFuncEnd:
                if re.search('{', line):
                        braceCnt += 1
                        isFuncStart = True
                if re.search('}', line):
                        braceCnt -= 1
                if braceCnt == 0 and isFuncStart and not isFuncEnd:
                        isFuncEnd = True
                        index = line.rfind('}')
                        if index == 0:
                                line = '\n\tif (!mEmmaCubeDefnPtr.IsNull())\n\t{\n\t\tmDatasetServeMode.mValue = DssDatasetServeAsModel;\n\t}\n' + line
                        else:
                                line = line[:index-1] + '\n\tif (!mEmmaCubeDefnPtr.IsNull())\n\t{\n\t\tmDatasetServeMode.mValue = DssDatasetServeAsModel;\n\t}\n' + line[index:]
        targetFile.write(line)

srcFile.close()
targetFile.close()

os.system('attrib -r ' + srcFileName)
os.system('mv -f srcTemp ' + srcFileName)