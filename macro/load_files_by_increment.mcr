#!MC 1410

$!VarSet |Prefix_normal| = "wing_"
$!VarSet |Sufix_normal| = "_vol"
$!VarSet |Prefix_failed| = "failed_mesh_wing_"
$!VarSet |Sufix_failed| = ""
$!VarSet |numberoffiles| = ""

$!PROMPTFORTEXTSTRING |numberoffiles|
    INSTRUCTIONS = "Number of total files"


$!LOOP |numberoffiles|
  $!VARSET |n| = "|LOOP|"

  # format file numbers to correct digits
  $!VarSet |finalN| = "|n%03d|"

  #Checks to see if the file exists
  $!EXTENDEDCOMMAND
  COMMANDPROCESSORID = "extendmcr"
  Command = 'QUERY.FILEEXISTS "|macrofilepath|/|Prefix_normal||finalN||Sufix_normal|.cgns" "exists_normal"'
  
  $!EXTENDEDCOMMAND
  COMMANDPROCESSORID = "extendmcr"
  Command = 'QUERY.FILEEXISTS "|macrofilepath|/|Prefix_failed||finalN||Sufix_failed|.cgns" "exists_failed"'

  $!IF "|exists_normal|" == "YES"
    $!ReadDataSet  '"STANDARDSYNTAX" "1.0" "FILELIST_CGNSFILES" "1" "|macrofilepath|/|Prefix_normal||finalN||Sufix_normal|.cgns" "LoadBCs" "Yes" "AssignStrandIDs" "Yes" "UniformGridStructure" "Yes" "LoaderVersion" "V3" "CgnsLibraryVersion" "4.1.2"'
	DataSetReader = 'CGNS Loader'
	VarNameList = '"CoordinateX" "CoordinateY" "CoordinateZ" "Density" "VelocityX" "VelocityY" "VelocityZ" "Pressure" "TurbulentSANuTilde" "ResDensity"'
	ReadDataOption = Append
	ResetStyle = No
	AssignStrandIDs = Yes
	InitialPlotType = Cartesian3D
	InitialPlotFirstZoneOnly = No
	AddZonesToExistingStrands = No
	VarLoadMode = ByName
  $!ELSEIF "|exists_failed|" == "YES"
    $!ReadDataSet  '"STANDARDSYNTAX" "1.0" "FILELIST_CGNSFILES" "1" "|macrofilepath|/|Prefix_failed||finalN||Sufix_failed|.cgns" "LoadBCs" "Yes" "AssignStrandIDs" "Yes" "UniformGridStructure" "Yes" "LoaderVersion" "V3" "CgnsLibraryVersion" "4.1.2"'
	DataSetReader = 'CGNS Loader'
	VarNameList = '"CoordinateX" "CoordinateY" "CoordinateZ" "Density" "VelocityX" "VelocityY" "VelocityZ" "Pressure" "TurbulentSANuTilde" "ResDensity"'
	ReadDataOption = Append
	ResetStyle = No
	AssignStrandIDs = Yes
	InitialPlotType = Cartesian3D
	InitialPlotFirstZoneOnly = No
	AddZonesToExistingStrands = No
	VarLoadMode = ByName
  $!ENDIF

$!ENDLOOP

$!Interface ZoneBoundingBoxMode = Off
$!FieldLayers ShowContour = Yes
$!SetContourVar 
  Var = 8
  ContourGroup = 1
  LevelInitMode = ResetToNice
