; OpenCandySample.nsi
;
; This is a fairly simple example of an NSIS installer that walks through
; the basic functionality a typical installer provides and also shows the
; required OpenCandy integration points.
;
; You should be able to build this installer without any modification
; and see a sample offer from the OpenCandy network. The unmodified installer
; is safe to run, it just drops a copy of this .nsi file in the installation
; folder.
;
; Everything specific to OpenCandy in this script is encapsulated like this:
;
; # [OpenCandy]
;     ; OpenCandy stuff here
; # [/OpenCandy]
;
; If you already have your own .nsi script the accompanying SDK notes highlight
; the steps neccessary for integration and this sample will provide a good
; reference implementation. For advanced support please contact the OpenCandy
; partner support team.
;
; Copyright (c) 2008 - 2011 OpenCandy, Inc.
;
; You may use and modify this .nsi file for your product installer so long as
; you abide by the terms of the OpenCandy SDK EULA.
;



;--------------------------------
; Definitions
;--------------------------------

# [OpenCandy]

	; These values get passed to the OpenCandy API. Once you've signed up
	; for OpenCandy you'll be provided with a customized set of values that
	; you must set here before releasing your installer.
	;
	; These values must be defined before including OCSetupHlp.nsh.
	;
	; For internal purposes it's okay to use the sample values that are preset
	; below. If everything is working properly you'll see a sample offer screen
	; display in your installer. When you compile your installer with these
	; sample values some warnings will be displayed in the compiler output
	; window to remind you to change these values before your release.

	; Please change "Open Candy Sample" to the name of your product
	!define OC_STR_MY_PRODUCT_NAME "Open Candy Sample"
	; Please change the key and secret to the ones assigned for your specific products
	!define OC_STR_KEY "748ad6d80864338c9c03b664839d8161"
	!define OC_STR_SECRET "dfb3a60d6bfdb55c50e1ef53249f1198"
	; Optionally change the path to OCSetupHlp.dll here if it's not in the same folder
	; as your .nsi file. You must specify the relative path from your .nsi file location.
	!define OC_OCSETUPHLP_FILE_PATH ".\OCSetupHlp.dll"
	
# [/OpenCandy]

!define PRODUCT_PROPER_NAME                "My Product"
!define PRODUCT_FILESYSTEM_NAME            "My Product"
!define PRODUCT_PUBLISHER_PROPER_NAME      "My Company, Inc."
!define PRODUCT_PUBLISHER_FILESYSTEM_NAME  "My Company"
!define INSTALLER_EXE_NAME                 "OCSampleNSISInstall.exe"
!define PRODUCT_DIR_REGKEY                 "Software\${PRODUCT_PUBLISHER_FILESYSTEM_NAME}\${PRODUCT_FILESYSTEM_NAME}"

; Uncomment this definition to use Modern UI 2 instead of Modern UI. It's best
; to use Modern UI 2 if you're starting fresh with the latest version of NSIS
; and you don't have many custom dialogs created with InstallOptions. By default
; this sample installer uses Modern UI for maximum compatibility.
; !define OPTION_USE_MUI_2



;--------------------------------
; Installer Configuration
;--------------------------------

# [OpenCandy]
	; OpenCandy requires RequestExecutionLevel admin
# [/OpenCandy]
; Request admin privileges for Windows Vista, 7.
RequestExecutionLevel admin

; Name (shown in various places in the installer UI)
Name "${PRODUCT_PROPER_NAME}"

; Output file generated by NSIS compiler
OutFile "${INSTALLER_EXE_NAME}"

; Default installation folder
InstallDir "$PROGRAMFILES\${PRODUCT_PUBLISHER_FILESYSTEM_NAME}\${PRODUCT_FILESYSTEM_NAME}"

; Automatically remember any user-customized installation path
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""

; Use lzma compression
SetCompressor lzma

; Optimize Data Block
SetDatablockOptimize on

; Restore last write datestamp of files
SetDateSave on

; Show un/installation details
ShowInstDetails   show
ShowUnInstDetails show



;--------------------------------
; Includes
;--------------------------------

; Use Modern UI to make the installer look nice
!ifdef OPTION_USE_MUI_2
!include "MUI2.nsh"
!else
!include "MUI.nsh"
!endif

; Include Sections header so that we can manipulate
; section properties in .onInit
!include "Sections.nsh"

# [OpenCandy]
	; Include the OpenCandy Setup Helper header
	; This provides all the OpenCandy helper macros, functions
	; and definitions that are used by this install script.
	!include "OCSetupHlp.nsh"
# [/OpenCandy]



;--------------------------------
; Reserve files
;--------------------------------

!insertmacro MUI_RESERVEFILE_LANGDLL
# [/OpenCandy]
	; Improve startup performance and increase offer fetch time by
	; reserving an early place in the file data block for OpenCandy DLL.
	!insertmacro OpenCandyReserveFile
# [/OpenCandy]
!ifndef OPTION_USE_MUI_2
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
!endif



;--------------------------------
; Variables
;--------------------------------

; Create any globals here
; Var MyGlobalVariable



;--------------------------------
; Modern UI Configuration
;--------------------------------

; MUI Settings
!define MUI_ABORTWARNING

; MUI Settings / Icons
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

; MUI Settings / Header
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange-r.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "${NSISDIR}\Contrib\Graphics\Header\orange-uninstall-r.bmp"

; MUI Settings / Wizard
!define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange-uninstall.bmp"



;--------------------------------
; Installer pages
;--------------------------------

; Welcome page
!insertmacro MUI_PAGE_WELCOME

# [OpenCandy]
	; You must display the OpenCandy EULA during installation
	; before the OpenCandy offer screen. We recommend appending
	; the OpenCandy EULA to your own license agreement.
# [/OpenCandy]
; End user license agreement	
!insertmacro MUI_PAGE_LICENSE "OpenCandy EULA.txt"

; Component selection (you might want to omit this in a simpler setup)
!insertmacro MUI_PAGE_COMPONENTS

; Choose directory (you might want to omit this in a simpler setup)
!insertmacro MUI_PAGE_DIRECTORY

# [OpenCandy]
	; Insert the OpenCandy offer page
	!insertmacro OpenCandyOfferPage
# [/OpenCandy]

; Perform installation (excutes each enabled Section)
!insertmacro MUI_PAGE_INSTFILES

; Finish page
!insertmacro MUI_PAGE_FINISH



;--------------------------------
; Language support
;--------------------------------

!insertmacro MUI_LANGUAGE "English"
LangString Section_Name_MainProduct    ${LANG_ENGLISH} "${PRODUCT_PROPER_NAME}"
LangString Section_Name_MainProductExt ${LANG_ENGLISH} "${PRODUCT_PROPER_NAME} extensions"



;---------------------------
; Install sections
;---------------------------

# [OpenCandy]
; This section is hidden. It will always execute during installation
; but it won't appear on your component selection screen.
Section "-OpenCandyEmbedded"
	; Handle any offers the user accepted
	!insertmacro OpenCandyInstallEmbedded	
SectionEnd
# [/OpenCandy]



Section "$(Section_Name_MainProduct)" SECTIONID_MAINPRODUCT
	; Put your own product installation code here!
	;
	; Notice that because this is the main product section
	; there's some code in the .onInit callback that prevents
	; the user from disabling this section on the components
	; selection screen.

	SetShellVarContext All ; Refer to "All users" paths
	SetOutPath $INSTDIR ; Set output path to the installation directory.

	; Unpack files - We'll just use OpenCandySample.nsi as an example
	File OpenCandySample.nsi
SectionEnd



Section "$(Section_Name_MainProductExt)" SECTIONID_MAINPRODUCTEXT
	; This section doesn't do anything! :)
	; It's here to demonstrate how multiple sections show up on the
	; components selection screen, how to set localized names for multiple
	; sections, and so forth. Notice that because this section isn't
	; made read-only in .onInit users can turn it off on the component
	; selection screen and then any code in this section won't run.
SectionEnd


;---------------------------
; Localized descriptions
;---------------------------

; Add localized section descriptions. These appear when you hover
; the mouse over items on the component selection screen. This code has
; to come after all of your Sections.
LangString DESC_SECTIONID_MAINPRODUCT ${LANG_ENGLISH} "Installs ${PRODUCT_PROPER_NAME}"
LangString DESC_SECTIONID_MAINPRODUCTEXT ${LANG_ENGLISH} "Installs extensions for ${PRODUCT_PROPER_NAME}"
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${SECTIONID_MAINPRODUCT} $(DESC_SECTIONID_MAINPRODUCT)
	!insertmacro MUI_DESCRIPTION_TEXT ${SECTIONID_MAINPRODUCTEXT} $(DESC_SECTIONID_MAINPRODUCTEXT)
!insertmacro MUI_FUNCTION_DESCRIPTION_END



;--------------------------------
; .onInit NSIS callback
;--------------------------------

Function .onInit
	; Display a language selection dialog box for languages
	; This will only show if you have added multiple languages
	; using the MUI_LANGUAGE macro.
	!insertmacro MUI_LANGDLL_DISPLAY
	
	; Set the main product section to read-only so that users
	; can't turn it off on the component selection screen.
	!insertmacro SetSectionFlag ${SECTIONID_MAINPRODUCT} ${SF_RO}

# [OpenCandy]
	; Initialize OpenCandy, check for offers
	;
	; Note: If you use a language selection system,
	; e.g. MUI_LANGDLL_DISPLAY or calls to LangDLL, you must insert
	; this macro after the language selection code in order for
	; OpenCandy to detect the user-selected language.
	!insertmacro OpenCandyAsyncInit "${OC_STR_MY_PRODUCT_NAME}" "${OC_STR_KEY}" "${OC_STR_SECRET}" ${OC_INIT_MODE_NORMAL}
# [/OpenCandy]
FunctionEnd



;--------------------------------
; .onInstSuccess NSIS callback
;--------------------------------

Function .onInstSuccess
# [OpenCandy]
	; Signal successfull installation, download and install accepted offers
	!insertmacro OpenCandyOnInstSuccess
# [/OpenCandy]
FunctionEnd



;--------------------------------
; .onGUIEnd NSIS callback
;--------------------------------

Function .onGUIEnd
# [OpenCandy]
	; Inform the OpenCandy API that the installer is about to exit
	!insertmacro OpenCandyOnGuiEnd
# [/OpenCandy]
FunctionEnd


# [OpenCandy]
	; Have the compiler perform some basic OpenCandy API implementation checks
	!insertmacro OpenCandyAPIDoChecks
# [/OpenCandy]