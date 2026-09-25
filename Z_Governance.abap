*&---------------------------------------------------------------------*
*& Report Z_GOVERNANCE
*&---------------------------------------------------------------------*
REPORT Z_GOVERNANCE.

TABLES : ZEG_APPLICATION.

DATA: GV_APPLICATION_ID     TYPE ZEG_DE_APPLICATION_ID,
      GV_CITIZEN_NAME       TYPE CHAR40,
      GV_MOBILE              TYPE ZEG_DE_MOBILE,
      GV_EMAIL               TYPE ZEG_DE_EMAIL,
      GV_ADRESS              TYPE CHAR100,
      GV_SERVICE_NAME       TYPE CHAR40,
      GV_DEPARTMENT         TYPE CHAR40,
      GV_APPLICATION_DATE   TYPE DATS,
      GV_STATUS              TYPE ZEG_DE_STATUS,
      GV_OFFICER_NAME       TYPE CHAR40,
      GV_REMARK             TYPE ZEG_DE_REASON,
      GV_GEIEVANCE          TYPE CHAR255,
      GV_PRIORITY           TYPE ZEG_DE_PRIORITY.

START-OF-SELECTION.
  CALL SCREEN 0100.


*---------------------------------------------------------------------*
* PBO
*---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.

  "SET PF-STATUS 'Z_GOVERNANCE'.

ENDMODULE.


*---------------------------------------------------------------------*
* PAI
*---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CASE SY-UCOMM.

    WHEN 'EXIT'.
      LEAVE PROGRAM.

    WHEN 'CITIZEN'.
      MESSAGE 'Citizen Application Selected' TYPE 'I'.

    WHEN 'GRIEVANCE'.
      MESSAGE 'Grievance Selected' TYPE 'I'.

    WHEN 'STATUS'.
      MESSAGE 'Application Status Selected' TYPE 'I'.

    WHEN 'SAVE'.
      PERFORM SAVE_DATA.

    WHEN 'CLEAR'.
      PERFORM CLEAR_DATA.

    WHEN 'SEARCH'.
      PERFORM SEARCH_DATA.

    WHEN 'REPORT'.
      PERFORM REPORT_DATA.

  ENDCASE.

ENDMODULE.


*---------------------------------------------------------------------*
* SAVE DATA
*---------------------------------------------------------------------*
FORM SAVE_DATA.

  DATA: WA_APPLICATION TYPE ZEG_APPLICATION,
        LV_NUMBER      TYPE I.

  "Validation

  IF GV_CITIZEN_NAME IS INITIAL.
    MESSAGE 'Please enter Citizen Name' TYPE 'E'.
  ENDIF.

  IF GV_MOBILE IS INITIAL.
    MESSAGE 'Please enter Mobile Number' TYPE 'E'.
  ENDIF.

  IF GV_EMAIL IS INITIAL.
    MESSAGE 'Please enter E-mail' TYPE 'E'.
  ENDIF.

  IF GV_ADRESS IS INITIAL.
    MESSAGE 'Please enter Your Correct Address' TYPE 'E'.
  ENDIF.

  IF GV_SERVICE_NAME IS INITIAL.
    MESSAGE 'Please enter Your Service Name' TYPE 'E'.
  ENDIF.


  "Generate Application ID

  SELECT COUNT( * )
    FROM ZEG_APPLICATION
    INTO LV_NUMBER.

  LV_NUMBER = LV_NUMBER + 1.

  GV_APPLICATION_ID =
    |{ LV_NUMBER WIDTH = 10 ALIGN = RIGHT PAD = '0' }|.


  "Move data to Work Area

  WA_APPLICATION-APPLICATION_ID = GV_APPLICATION_ID.
  WA_APPLICATION-CITIZEN_NAME = GV_CITIZEN_NAME.
  WA_APPLICATION-MOBILE = GV_MOBILE.
  WA_APPLICATION-EMAIL = GV_EMAIL.
  WA_APPLICATION-ADDRESS = GV_ADRESS.
  WA_APPLICATION-SERVICE_NAME = GV_SERVICE_NAME.
  WA_APPLICATION-DEPARTMENT = GV_DEPARTMENT.
  WA_APPLICATION-APPLICATION_DATE = SY-DATUM.
  WA_APPLICATION-STATUS = 'SUBMITTED'.
  WA_APPLICATION-OFFICER_NAME = GV_OFFICER_NAME.
  WA_APPLICATION-REMARKS = GV_REMARK.
  WA_APPLICATION-GRIEVANCE = GV_GEIEVANCE.
  WA_APPLICATION-PRIORITY = GV_PRIORITY.
  WA_APPLICATION-CREATED_DATE = SY-DATUM.
  WA_APPLICATION-CREATED_TIME = SY-UZEIT.


  "Save data

  INSERT ZEG_APPLICATION FROM WA_APPLICATION.

  IF SY-SUBRC = 0.

    COMMIT WORK.

    MESSAGE 'Application Saved Successfully' TYPE 'S'.

  ELSE.

    MESSAGE 'Application Not Saved' TYPE 'E'.

  ENDIF.

ENDFORM.


*---------------------------------------------------------------------*
* CLEAR DATA
*---------------------------------------------------------------------*
FORM CLEAR_DATA.

  CLEAR : GV_APPLICATION_ID,
          GV_CITIZEN_NAME,
          GV_MOBILE,
          GV_EMAIL,
          GV_ADRESS,
          GV_SERVICE_NAME,
          GV_DEPARTMENT,
          GV_APPLICATION_DATE,
          GV_STATUS,
          GV_OFFICER_NAME,
          GV_REMARK,
          GV_GEIEVANCE,
          GV_PRIORITY.

  MESSAGE 'Data Cleared Successfully' TYPE 'S'.

ENDFORM.


*---------------------------------------------------------------------*
* SEARCH DATA
*---------------------------------------------------------------------*
FORM SEARCH_DATA.

  DATA: WA_APPLICATION TYPE ZEG_APPLICATION.

  IF GV_APPLICATION_ID IS INITIAL.
    MESSAGE 'Please enter Application ID' TYPE 'E'.
  ENDIF.

  SELECT SINGLE *
    FROM ZEG_APPLICATION
    INTO WA_APPLICATION
    WHERE APPLICATION_ID = GV_APPLICATION_ID.

  IF SY-SUBRC <> 0.

    MESSAGE 'Application Not Found' TYPE 'E'.

  ELSE.

    GV_CITIZEN_NAME     = WA_APPLICATION-CITIZEN_NAME.
    GV_MOBILE            = WA_APPLICATION-MOBILE.
    GV_EMAIL             = WA_APPLICATION-EMAIL.
    GV_ADRESS            = WA_APPLICATION-ADDRESS.
    GV_SERVICE_NAME      = WA_APPLICATION-SERVICE_NAME.
    GV_DEPARTMENT        = WA_APPLICATION-DEPARTMENT.
    GV_APPLICATION_DATE  = WA_APPLICATION-APPLICATION_DATE.
    GV_STATUS            = WA_APPLICATION-STATUS.
    GV_OFFICER_NAME      = WA_APPLICATION-OFFICER_NAME.
    GV_REMARK            = WA_APPLICATION-REMARKS.
    GV_GEIEVANCE         = WA_APPLICATION-GRIEVANCE.
    GV_PRIORITY          = WA_APPLICATION-PRIORITY.

    MESSAGE 'Application Found Successfully' TYPE 'S'.

  ENDIF.

ENDFORM.


*---------------------------------------------------------------------*
* ALV REPORT
*---------------------------------------------------------------------*
FORM REPORT_DATA.

  DATA: LT_APPLICATION TYPE TABLE OF ZEG_APPLICATION,
        LT_FIELDCAT    TYPE SLIS_T_FIELDCAT_ALV.

  PERFORM BUILD_FIELDCAT CHANGING LT_FIELDCAT.

  SELECT *
    FROM ZEG_APPLICATION
    INTO TABLE LT_APPLICATION.

  IF LT_APPLICATION IS INITIAL.

    MESSAGE 'No Application Data Found' TYPE 'E'.

  ELSE.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        IT_FIELDCAT = LT_FIELDCAT
      TABLES
        T_OUTTAB = LT_APPLICATION.

  ENDIF.

ENDFORM.


*---------------------------------------------------------------------*
* ALV FIELD CATALOG
*---------------------------------------------------------------------*
FORM BUILD_FIELDCAT
  CHANGING PT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV.

  DATA: WA_FIELDCAT TYPE SLIS_FIELDCAT_ALV.


  CLEAR WA_FIELDCAT.
  WA_FIELDCAT-FIELDNAME = 'APPLICATION_ID'.
  WA_FIELDCAT-SELTEXT_M = 'Application ID'.
  APPEND WA_FIELDCAT TO PT_FIELDCAT.


  CLEAR WA_FIELDCAT.
  WA_FIELDCAT-FIELDNAME = 'CITIZEN_NAME'.
  WA_FIELDCAT-SELTEXT_M = 'Citizen Name'.
  APPEND WA_FIELDCAT TO PT_FIELDCAT.


  CLEAR WA_FIELDCAT.
  WA_FIELDCAT-FIELDNAME = 'MOBILE'.
  WA_FIELDCAT-SELTEXT_M = 'Mobile'.
  APPEND WA_FIELDCAT TO PT_FIELDCAT.


  CLEAR WA_FIELDCAT.
  WA_FIELDCAT-FIELDNAME = 'EMAIL'.
  WA_FIELDCAT-SELTEXT_M = 'E-mail'.
  APPEND WA_FIELDCAT TO PT_FIELDCAT.


  CLEAR WA_FIELDCAT.
  WA_FIELDCAT-FIELDNAME = 'SERVICE_NAME'.
  WA_FIELDCAT-SELTEXT_M = 'Service Name'.
  APPEND WA_FIELDCAT TO PT_FIELDCAT.


  CLEAR WA_FIELDCAT.
  WA_FIELDCAT-FIELDNAME = 'DEPARTMENT'.
  WA_FIELDCAT-SELTEXT_M = 'Department'.
  APPEND WA_FIELDCAT TO PT_FIELDCAT.


  CLEAR WA_FIELDCAT.
  WA_FIELDCAT-FIELDNAME = 'APPLICATION_DATE'.
  WA_FIELDCAT-SELTEXT_M = 'Application Date'.
  APPEND WA_FIELDCAT TO PT_FIELDCAT.


  CLEAR WA_FIELDCAT.
  WA_FIELDCAT-FIELDNAME = 'STATUS'.
  WA_FIELDCAT-SELTEXT_M = 'Status'.
  APPEND WA_FIELDCAT TO PT_FIELDCAT.


  CLEAR WA_FIELDCAT.
  WA_FIELDCAT-FIELDNAME = 'OFFICER_NAME'.
  WA_FIELDCAT-SELTEXT_M = 'Officer Name'.
  APPEND WA_FIELDCAT TO PT_FIELDCAT.


  CLEAR WA_FIELDCAT.
  WA_FIELDCAT-FIELDNAME = 'PRIORITY'.
  WA_FIELDCAT-SELTEXT_M = 'Priority'.
  APPEND WA_FIELDCAT TO PT_FIELDCAT.

ENDFORM.
