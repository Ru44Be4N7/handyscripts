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
  Command = 'QUERY.FILEEXISTS "|macrofilepath|/|Prefix_failed||finalN||Sufix_failed|.cgns" "exists_failed"'

  $!IF "|exists_normal|" == "YES"
      $!READDATASET "|macrofilepath|/|Prefix_normal||finalN||Sufix_normal|.cgns"
        READDATAOPTION = APPEND 
  $!ELSEIF "|exists_failed|" == "YES"
      $!READDATASET "|macrofilepath|/|Prefix_failed||finalN||Sufix_failed|.cgns"
        READDATAOPTION = APPEND 
  $!ENDIF

$!ENDLOOP
