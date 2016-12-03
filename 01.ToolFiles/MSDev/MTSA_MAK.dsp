# Microsoft Developer Studio Project File - Name="MTSA_MAK" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) External Target" 0x0106

CFG=MTSA_MAK - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "MTSA_MAK.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "MTSA_MAK.mak" CFG="MTSA_MAK - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "MTSA_MAK - Win32 Release" (based on "Win32 (x86) External Target")
!MESSAGE "MTSA_MAK - Win32 Debug" (based on "Win32 (x86) External Target")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""

!IF  "$(CFG)" == "MTSA_MAK - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Cmd_Line "NMAKE /f MTSA_MAK.mak"
# PROP BASE Rebuild_Opt "/a"
# PROP BASE Target_File "MTSA_MAK.exe"
# PROP BASE Bsc_Name "MTSA_MAK.bsc"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Cmd_Line "NMAKE /f MTSA_MAK.mak"
# PROP Rebuild_Opt "/a"
# PROP Target_File "MTSA_MAK.exe"
# PROP Bsc_Name "MTSA_MAK.bsc"
# PROP Target_Dir ""

!ELSEIF  "$(CFG)" == "MTSA_MAK - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Cmd_Line "NMAKE /f MTSA_MAK.mak"
# PROP BASE Rebuild_Opt "/a"
# PROP BASE Target_File "MTSA_MAK.exe"
# PROP BASE Bsc_Name "MTSA_MAK.bsc"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Cmd_Line "nmake /f "MTSA_MAK.mak""
# PROP Rebuild_Opt "/a"
# PROP Target_File "MTSA_MAK.exe"
# PROP Bsc_Name ""
# PROP Target_Dir ""

!ENDIF 

# Begin Target

# Name "MTSA_MAK - Win32 Release"
# Name "MTSA_MAK - Win32 Debug"

!IF  "$(CFG)" == "MTSA_MAK - Win32 Release"

!ELSEIF  "$(CFG)" == "MTSA_MAK - Win32 Debug"

!ENDIF 

# Begin Group "01.ToolFiles"

# PROP Default_Filter ""
# Begin Group "Tasking_Tricore"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Tasking_Tricore\tasking_1_5_asm_depend.awk
# End Source File
# Begin Source File

SOURCE=.\Tasking_Tricore\tasking_1_5_asm_depend.pl
# End Source File
# Begin Source File

SOURCE=.\Tasking_Tricore\tasking_1_5_c_depend.awk
# End Source File
# Begin Source File

SOURCE=.\Tasking_Tricore\tasking_1_5_c_depend.pl
# End Source File
# Begin Source File

SOURCE=.\Tasking_Tricore\tasking_2_x_c_depend.pl
# End Source File
# End Group
# Begin Group "Diab_PPC"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Diab_PPC\diab_4_4b_c_compiler_depends.sed
# End Source File
# Begin Source File

SOURCE=.\Diab_PPC\diab_4_4b_developer_studio.sed
# End Source File
# Begin Source File

SOURCE=.\Diab_PPC\diab_4_4b_error.sed
# End Source File
# End Group
# End Group
# Begin Source File

SOURCE=..\..\Ashling_Pathfinder.mak
# End Source File
# Begin Source File

SOURCE=..\..\Cosmic_HC08.mak
# End Source File
# Begin Source File

SOURCE=..\..\Cosmic_HC12.mak
# End Source File
# Begin Source File

SOURCE=..\..\create_toolcat.pl
# End Source File
# Begin Source File

SOURCE=..\..\DiabData_esys_5_3.mak
# End Source File
# Begin Source File

SOURCE=..\..\DiabData_PowerPC.mak
# End Source File
# Begin Source File

SOURCE=..\..\GHS_ESYS.mak
# End Source File
# Begin Source File

SOURCE=..\..\HiTech_PIC.mak
# End Source File
# Begin Source File

SOURCE=..\..\MAKEDOCS.BAT
# End Source File
# Begin Source File

SOURCE=..\..\MAKEDOCS.MAK
# End Source File
# Begin Source File

SOURCE=..\..\MTSA.mak
# End Source File
# Begin Source File

SOURCE=..\..\NEC_78k0.mak
# End Source File
# Begin Source File

SOURCE=..\..\NEC_v850.mak
# End Source File
# Begin Source File

SOURCE=..\..\Polyspace.mak
# End Source File
# Begin Source File

SOURCE=..\..\qac.mak
# End Source File
# Begin Source File

SOURCE=..\..\SubProject_Cosmic_HC08.mak
# End Source File
# Begin Source File

SOURCE=..\..\SubProject_Cosmic_HC12.mak
# End Source File
# Begin Source File

SOURCE=..\..\SubProject_DiabData_esys_5_3.mak
# End Source File
# Begin Source File

SOURCE=..\..\SubProject_DiabData_PowerPC.mak
# End Source File
# Begin Source File

SOURCE=..\..\SubProject_GHS_ESYS.mak
# End Source File
# Begin Source File

SOURCE=..\..\SubProject_HiTech_PIC.mak
# End Source File
# Begin Source File

SOURCE=..\..\SubProject_NEC_78k0.mak
# End Source File
# Begin Source File

SOURCE=..\..\SubProject_NEC_78k0_SRCDIRS.mak
# End Source File
# Begin Source File

SOURCE=..\..\SubProject_NEC_v850.mak
# End Source File
# Begin Source File

SOURCE=..\..\SubProject_qac.mak
# End Source File
# Begin Source File

SOURCE=..\..\SubProject_Tasking_C166.mak
# End Source File
# Begin Source File

SOURCE=..\..\SubProject_Tasking_TriCore.mak
# End Source File
# Begin Source File

SOURCE=..\..\SubProject_Tasking_TriCore_2_0.mak
# End Source File
# Begin Source File

SOURCE=..\..\SubProject_TI_TMS470.mak
# End Source File
# Begin Source File

SOURCE=..\..\swrlse.mak
# End Source File
# Begin Source File

SOURCE=..\..\Tasking_C166.mak
# End Source File
# Begin Source File

SOURCE=..\..\Tasking_TriCore.mak
# End Source File
# Begin Source File

SOURCE=..\..\Tasking_TriCore_2_0.mak
# End Source File
# Begin Source File

SOURCE=..\..\TI_TMS470.mak
# End Source File
# End Target
# End Project
