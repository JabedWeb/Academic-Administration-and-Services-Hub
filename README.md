# Academic-Administration-and-Services-Hub

## Overview
This repository contains the MySQL database setup for a simple Academic-Administration and Services Hub (AASH). It includes scripts for creating tables, inserting initial data, and some example queries and triggers that demonstrate typical operations within the system.

## Features
- User account management for students, faculty, and admin staff.
- Course and enrollment records handling.
- Attendance tracking system.
- Payment processing and record maintenance.
- Faculty workload and schedule management.
- Transportation and extracurricular activities tracking.

## How to Use
To use this database:
1. Clone this repository to your local machine.
2. Open your MySQL database management tool (such as phpMyAdmin, MySQL Workbench, etc.).
3. Import the `.sql` files to set up the database and tables.
4. Run the insert scripts to populate the tables with initial data.
5. Utilize the provided queries to interact with the database.

## Structure
The database is divided into several tables, each handling a different aspect of the university administration:
- `UserAccounts` for login credentials and role management.
- `Students`, `Faculty`, `Staff`, `Alumni` for personal records.
- `Courses`, `Classroom`, `Section` for course management.
- `Payments`, `AmountToPay` for financial transactions.
- And many more.