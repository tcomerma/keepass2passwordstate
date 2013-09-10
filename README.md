keepass2passwordstate  -  README
=====================
keepass2passwordstate.xsl

Convert KeePass XML (2.x) format ClickStudios PasswordState Import format

Usage
  Either:
  a) - Export from Keepass 2 to XML
     - Apply xsl to exported xml (I use Notepad++. Complements->XML tools->XSL Transformation) and provide parameter values for PasswordListID and AccountType
  b) Apply xsl directly from Keepass 2 (File->Export->Transform using XSL Template). Here you cannot pass parameters, so you have to edit keepass2passwordstate.xsl
  
  Notes: * Its mandatory to know the passwordlist ID. 
         * All passwords are imported into the same password list. Then you can use bulk move to reorder
		 * The original keepass "folder"  is stored into Description.
		 * !!File Must have .csv extension. If not, passwordstate refuses to import it.!!
  
  
       Field Mapping
	   
	   PasswordState     Keepass
	   ================= =====================================================
	   PasswordListID;   As set in param PasswordListID in config section
	   Title;            Title
	   UserName;         Username
	   Description;      Folder Hierarchy
	   AccountType;      As set in param AccountType in config section
	   Notes;		     Notes
	   URL;              URL
	   Password;         Password
	   ExpiryDate;		 Expiration Date
	   GenericField1;
	   GenericField2;
	   GenericField3;
	   GenericField4;
	   GenericField5;
	   GenericField6;
	   GenericField7;
	   GenericField8;
	   GenericField9;
	   GenericField10
	   
  
  	   
