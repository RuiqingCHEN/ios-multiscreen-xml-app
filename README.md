# Multi-Screen iOS App (XML-Based)

## Overview
This project is an iOS application developed using Xcode and Swift.

The app displays information about a group of members (animals), including
basic details, extended descriptions, image galleries, and related web content.

---

## App Structure

### Screen 1 – UITableViewController
- Displays a list of group members
- Search functionality included
- Selecting an item navigates to Screen 2

### Screen 2 – UIViewController
- Displays image, name, and basic information
- Button provided to navigate to Screen 3

### Screen 3 – UIViewController
- Displays detailed text information
- Button provided to navigate to Screen 4

### Screen 4 – WebViewController
- Displays a webpage related to the selected member
- Includes navigation controls (back, forward, refresh)

---

## Data Source
- All app data is stored in an **XML file**
- XML is parsed in the model layer
- Each member contains:
  - Name
  - Images
  - Description
  - Web URL

---

## Technologies Used
- Swift
- UIKit
- UITableView
- UICollectionView
- WebView
- XML Parsing

---

## How to Run
1. Clone the repository
2. Open the `.xcodeproj` file in Xcode
3. Select an iOS Simulator or physical device
4. Run the project

---

## Screenshots
![1e675b381d32cee82ba6ed0a53abae88_](https://github.com/user-attachments/assets/85da7edb-d205-4f5b-9e4f-6324aa7de041)
![203e6d74a18ef3213f970004244060a3_](https://github.com/user-attachments/assets/ab3a9bd1-91cb-4bf1-9237-66955590af2c)
<img width="413" height="889" alt="4d98c8f0713134fc0e2c364e48affc56_" src="https://github.com/user-attachments/assets/e56a2fbf-4796-45bc-86d1-c6c660b21fe5" />
<img width="407" height="889" alt="d1eb4080f980b89593bf3014a32ced36_" src="https://github.com/user-attachments/assets/cd54cf9b-41c7-4664-bc5d-6a90999fce73" />


## Architecture
- MVC pattern
- Model handles XML parsing and data management
