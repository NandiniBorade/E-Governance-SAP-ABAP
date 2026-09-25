# E-Governance Citizen Service & Grievance Management System

## Project Overview

E-Governance Citizen Service & Grievance Management System is an SAP ABAP-based application developed to manage citizen service applications and grievances in a centralized system.

The system allows users to enter citizen details, submit applications, automatically generate a unique Application ID, search application records, clear data, and display application information using ALV reporting.

## Objectives

- Manage citizen service applications
- Store application data in SAP database
- Generate unique Application ID
- Search application details
- Validate mandatory fields
- Display data using ALV Report
- Provide Smart Form support

## Key Features

- Citizen Application Management
- Application ID Generation
- Data Validation
- Application Search
- Clear Functionality
- Application Status
- Priority Management
- ALV Reporting
- Smart Forms

## Technologies Used

- SAP ABAP
- SAP S/4HANA
- ABAP Dictionary (DDIC)
- Open SQL
- Dynpro / Module Pool Programming
- PBO / PAI
- ALV Reporting
- Smart Forms

## SAP ABAP Concepts Used

- Domains
- Data Elements
- Transparent Table
- Work Area
- Internal Table
- Open SQL
- SELECT
- INSERT
- COMMIT WORK
- SY-SUBRC
- SY-UCOMM
- PERFORM / FORMs
- ALV Grid
- Smart Forms

## Database Table

**ZEG_APPLICATION**

Main fields:

- APPLICATION_ID
- CITIZEN_NAME
- MOBILE
- EMAIL
- ADDRESS
- SERVICE_NAME
- DEPARTMENT
- APPLICATION_DATE
- STATUS
- OFFICER_NAME
- REMARKS
- GRIEVANCE
- PRIORITY
- CREATED_DATE
- CREATED_TIME

## Main Functionalities

### SAVE
Validates mandatory fields, generates Application ID and saves application data.

### SEARCH
Searches application details using Application ID.

### CLEAR
Clears the entered screen data.

### REPORT
Displays application records using ALV Grid.

### EXIT
Terminates the application.

## Smart Form

**ZEG_APPLICATION_FORM**

The Smart Form displays application details including Application ID, Citizen Name, Service Name, Department, Status, Officer Name, Priority, Remarks and Grievance.

## Project Status

**Completed**

## Author

**Nandini Borade**
