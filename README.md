# ABAP Tools

This repository contains a set of ABAP utility tools designed to development and testing. These programs help developers inspect table configurations and settings, review current database records, and inject test data into existing entries when the available data does not meet testing expectations.

## Included Tools

**1. zfc_show_dict_details.abap**
Inspects the Data Dictionary to display technical configurations, field structures, and domain settings for multiple custom tables. This is used to verify technical setups before writing data access logic.

**2. zfc_read_db_data.abap**
Reads and displays the current data stored in the custom tables. This provides a quick way to review existing records and verify the current state of the database.

**3. zfc_inject_test_data.abap**
Updates existing database records to simulate specific scenarios and adds documentation notes. This tool is used when the current data is insufficient or not as expected, allowing developers to inject the necessary test data directly into existing entries to properly test the dashboard.

## Anonymization and Mapping

To protect internal system information, all database table names, domain names, and field names have been anonymized using generic placeholders. Before using these tools in your system, you must map the generic names to your actual Data Dictionary objects.

### Table and Domain Mapping
- example_db_01: Header Table
- example_db_02: Position Table
- example_db_03: Master Data Table
- example_db_04: Notes Table
- example_dom_01: Status Domain
- example_dom_02: Rule Type Domain

### Field Mapping
**Header Table (example_db_01):**
- field01: Record ID | field02: Status | field03: Customer | field04: Company Code
- field05: Created Date | field06: Run Date | field07: Reference ID

**Position Table (example_db_02):**
- field01: Record ID | field08: Document Number | field09: Year | field10: Item
- field11: Level | field12: Amount | field13: Currency | field14: Date

**Master Data Table (example_db_03):**
- field07: Reference ID | field15: Name | field16: User | field17: Email

**Notes Table (example_db_04):**
- field01: Record ID | field18: Note Number | field05: Date | field19: Time
- field20: User | field21: Text

## Usage

1. Download the files and open them in your SAP ABAP Editor (SE38).
2. Perform a global find and replace to map the generic names (example_db_XX, fieldXX) to your actual table and field names.
3. Activate the programs.
4. Run `zfc_show_dict_details` to verify your technical mapping.
5. Run `zfc_read_db_data` to check your current data.
6. Run `zfc_inject_test_data` to update existing records and populate the dashboard for testing.

## Disclaimer
These tools are provided for development and testing purposes only. The data injection tool modifies existing database records. Always test in a development or quality assurance environment before running in a production system.
