drop database AASH;

CREATE DATABASE IF NOT EXISTS AASH;
USE AASH;


CREATE TABLE UserAccounts (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('student', 'faculty', 'staff', 'admin') NOT NULL
);


-- Departments Table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_full_name VARCHAR(100) NOT NULL,
    department_name VARCHAR(20) NOT NULL
);

-- Faculty Table
 -- ALTER TABLE Faculty AUTO_INCREMENT = 5000;
CREATE TABLE Faculty (
    faculty_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    office_location VARCHAR(100),
    department_id INT,
    designation VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE Faculty AUTO_INCREMENT = 5000;

-- add starting number for student id: 213902045
-- ALTER TABLE Students AUTO_INCREMENT = 213902045;

-- Students Table
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(255) UNIQUE,
    date_of_birth DATE NOT NULL,
    enrollment_date DATE,
    expected_graduation_date DATE,
    department_id INT,
    advisor_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (advisor_id) REFERENCES Faculty(faculty_id) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE Students AUTO_INCREMENT = 213902045;


-- Courses Table
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    credits INT NOT NULL,
    department_id INT,
    prerequisite_course_id INT,-- presentation
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (prerequisite_course_id) REFERENCES Courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Student marks table
CREATE TABLE marks (
    student_id INT,
    course_id INT,
    mark DECIMAL(5, 2),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Payments Table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_type VARCHAR(255) NOT NULL,
    payment_method VARCHAR(50),
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Amount to pay for each student
CREATE TABLE AmountToPay
(
    student_id INT PRIMARY KEY,
    payable_ammount DECIMAL(10, 2) not null
);
-- Staff Table
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department_id INT,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20),
    position VARCHAR(255) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Classroom Table
CREATE TABLE Classroom (
    classroom_id INT AUTO_INCREMENT PRIMARY KEY,
    building VARCHAR(100),
    room_number VARCHAR(10),
    UNIQUE (building, room_number) 
);

-- Timeslot Table
CREATE TABLE Timeslot (
    time_slot_id INT AUTO_INCREMENT PRIMARY KEY,
    day VARCHAR(20),
    start_time TIME,
    end_time TIME
);

-- Term Table
CREATE TABLE Term (
    term_id INT AUTO_INCREMENT PRIMARY KEY,
    term_name VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

-- Section Table
CREATE TABLE Section (
    sec_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT,
    term_id INT,
    classroom_id INT,
    time_slot_id INT,
    instructor_id INT,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (term_id) REFERENCES Term(term_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (classroom_id) REFERENCES Classroom(classroom_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (time_slot_id) REFERENCES Timeslot(time_slot_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES Faculty(faculty_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ClassRepresentatives (
    cr_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    sec_id INT,
    term_id INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sec_id) REFERENCES Section(sec_id),
    FOREIGN KEY (term_id) REFERENCES Term(term_id)
);


-- Attendance Table
CREATE TABLE Attendance (
    date DATE,
    student_id INT,
    course_id INT,
    sec_id INT,
    attendance_status VARCHAR(20),
    faculty_id INT,
    term_id INT,
    PRIMARY KEY (date, student_id, course_id, sec_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id, sec_id) REFERENCES Section(course_id, sec_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (term_id) REFERENCES Term(term_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Unified Enrollment and Academic Record Table
CREATE TABLE CourseEnrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    sec_id INT,
    term_id INT,
    grade_point DECIMAL(3, 2),
    grade VARCHAR(5),
    status VARCHAR(20) NOT NULL, -- value should be 'incompleted', 'enrolled', or 'completed',
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id, sec_id) REFERENCES Section(course_id, sec_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (term_id) REFERENCES Term(term_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Alumni Table
CREATE TABLE Alumni (
    student_id INT PRIMARY KEY,
    graduation_year YEAR,
    job VARCHAR(100),
    company VARCHAR(100),
    salary DECIMAL(10, 2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Research Projects Table
CREATE TABLE ResearchProjects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(255) NOT NULL,
    lead_faculty_id INT,
    budget DECIMAL(15, 2),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (lead_faculty_id) REFERENCES Faculty(faculty_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Extracurricular Activities Table
CREATE TABLE ExtracurricularActivities (
    activity_id INT AUTO_INCREMENT PRIMARY KEY,
    activity_name VARCHAR(100) NOT NULL,
    student_id INT,
    role VARCHAR(50),
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- FacultyCourses Table 
CREATE TABLE FacultyCourseTerm (
    faculty_id INT,
    course_id INT,
    term_id INT,
    PRIMARY KEY (faculty_id, course_id, term_id),
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (term_id) REFERENCES Term(term_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- -----------------------
-- transportation table: Future work
CREATE TABLE Drivers (
    driver_id INT AUTO_INCREMENT PRIMARY KEY,
    driver_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE RouteLocations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    location_name VARCHAR(255) NOT NULL
);

CREATE TABLE Transportation (
    transport_id INT AUTO_INCREMENT PRIMARY KEY,
    transport_name VARCHAR(255) NOT NULL,
    driver_id INT,
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE TransportationSchedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    transport_id INT,
    location_id INT,
    departure_time TIME NOT NULL,
    FOREIGN KEY (transport_id) REFERENCES Transportation(transport_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (location_id) REFERENCES RouteLocations(location_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 
-- Insert data into UserAccounts
INSERT INTO UserAccounts (username, password_hash, role) VALUES
('Jabed', SHA2('password1', 256), 'student');
-- Insert data into Departments
INSERT INTO Departments (department_id, department_full_name, department_name) VALUES
(101, 'Department of Computer Science and Engineering', 'CSE'),
(102, 'Department of Electrical and Electronic Engineering', 'EEE'),
(103, 'Department of Business Administration', 'BBA'),
(104, 'Department of English', 'ENG'),
(105, 'Department of Law', 'LAW');


-- Insert data into Faculty
INSERT INTO Faculty (first_name, last_name, email, phone_number, office_location, department_id, designation, salary) VALUES
('Aminur', 'Rahman', 'aminur.rahman@university.edu', '8801710000001', 'Room 507', 101, 'Professor', 120000),
('Faiz', 'Al Faisal', 'faiz.faisal@university.edu', '8801710000002', 'Room 508', 102, 'Associate Professor', 100000),
('Babe', 'Sultana', 'babe.sultana@university.edu', '8801710000003', 'Room 509', 101, 'Assistant Professor', 80000),
('Md. Zahidul', 'Hasan', 'zahidul@university.edu', '8801710000004', 'Room 510', 101, 'Instructor', 70000),
('Najmus', 'sakib', 'najmus.sakib@university.edu', '8801710000004', 'Room 510', 104, 'Lecturer', 70000);




-- Insert data into Students
INSERT INTO Students (first_name, last_name, address, phone, email, date_of_birth, enrollment_date, expected_graduation_date, department_id, advisor_id) VALUES
('Tanvir', 'Ahmed', 'Uttara, Dhaka', '01700000001', 'tanvir.ahmed@udbms.edu', '1995-04-12', '2021-09-15', '2025-05-30', 102, 5000),
('Jabed', 'Hossen', 'Uttara, Dhaka', '01700000002', 'jabedhasan@udbms.edu', '2000-08-22', '2021-09-15', '2025-05-30', 101, 5001),
('Sakib', 'Al Hasan', 'Banani, Dhaka', '01700000003', 'sakib.alhasan@udbms.edu', '1997-01-15', '2021-09-15', '2025-05-30', 103, 5002),
('Tamim', 'Iqbal', 'Gulshan, Dhaka', '01700000004', 'tamim.iqbal@udbms.edu', '1996-02-20', '2021-09-15', '2025-05-30', 104, 5003),
('Mushfiqur', 'Rahim', 'Dhanmondi, Dhaka', '01700000005', 'mushfiqur.rahim@udbms.edu', '2021-06-09', '2025-09-15', '2018-05-30', 105, 5004);

INSERT INTO Students (first_name, last_name, address, phone, email, date_of_birth, enrollment_date, expected_graduation_date, department_id, advisor_id) VALUES
('Tanvir1', 'Ahmed', 'Uttara, Dhaka', '01700000001', 'tanvir1.ahmed@udbms.edu', '1995-04-12', '2014-09-15', '2018-05-30', 101, 5000),
('Jabed1', 'Hossen', 'Uttara, Dhaka', '01700000002', 'jabedhasan1@udbms.edu', '1996-08-22', '2015-09-15', '2019-05-30', 102, 5001),
('Sakib1', 'Al Hasan', 'Banani, Dhaka', '01700000003', 'sakib.alhasan1@udbms.edu', '1997-01-15', '2016-09-15', '2020-05-30', 103, 5002),
('Tamim1', 'Iqbal', 'Gulshan, Dhaka', '01700000004', 'tamim.iqbal1@udbms.edu', '1996-02-20', '2015-09-15', '2019-05-30', 104, 5003),
('Mushfiqur1', 'Rahim', 'Dhanmondi, Dhaka', '01700000005', 'mushfiqur.rahim1@udbms.edu', '1995-06-09', '2014-09-15', '2018-05-30', 105, 5004);




-- Insert data into Courses
INSERT INTO Courses (course_name, course_code, credits, department_id) VALUES
('Compiler', 'CSE305', 3, 101),
('Compiler Lab', 'CSE306', 1, 101),
('Database System', 'CSE209', 3, 101),
('Database System Lab', 'CSE210', 1, 101),
('Electrical Drives and Instrumentation', 'EEE205', 3, 102);




-- Insert data into Staff
INSERT INTO Staff (first_name, last_name, department_id, email, phone_number, position, salary) VALUES
('Ayesha', 'Siddiqua', 101, 'ayesha.siddiqua@udbms.edu', '01600000001', 'Office Assistant', 30000.00),
('Rashed', 'Karim', 102, 'rashed.karim@udbms.edu', '01600000002', 'Lab Assistant', 25000.00),
('Farhana', 'Akhter', 103, 'farhana.akhter@udbms.edu', '01600000003', 'Admission Officer', 35000.00),
('Mahmud', 'Khan', 104, 'mahmud.khan@udbms.edu', '01600000004', 'Librarian', 37000.00),
('Jahid', 'Hasan', 105, 'jahid.hasan@udbms.edu', '01600000005', 'Maintenance Supervisor', 32000.00);

-- Insert data into Classroom
INSERT INTO Classroom (building, room_number) VALUES
('Main Building', '101'),
('J', '102'),
('K', '201'),
('L', '301'),
('5', '401');

-- Insert data into Timeslot
INSERT INTO Timeslot (day, start_time, end_time) VALUES
('Sunday', '08:00:00.', '10:00:00'),
('Monday', '10:00:00', '12:00:00'),
('Tuesday,Friday', '12:00:00', '14:00:00'),
('Thursday', '14:00:00', '16:00:00'),
('Thursday', '16:00:00', '18:00:00');



-- Insert data into Term
INSERT INTO Term (term_name, start_date, end_date) VALUES
('Fall 2023', '2023-07-15', '2024-01-27'),
('Summer 2023', '2023-06-01', '2023-09-01'),
('Spring 2024', '2024-09-15', '2024-01-15'),
('Summer 2024', '2024-06-01', '2024-09-01');

-- Insert data into Section
INSERT INTO Section (course_id, term_id, classroom_id, time_slot_id, instructor_id) VALUES
(1, 1, 1, 1, 5000),
(2, 1, 2, 2, 5001),
(3, 1, 3, 3, 5002),
(4, 1, 4, 4, 5003),
(5, 2, 5, 5, 5004);

-- Insert data into ClassRepresentatives
INSERT INTO ClassRepresentatives (student_id, sec_id, term_id) VALUES
(213902045, 1, 1),
(213902046, 2, 1),
(213902047, 3, 1),
(213902048, 4, 1),
(213902049, 5, 2);

-- Insert data into Attendance
INSERT INTO Attendance (date, student_id, course_id, sec_id, attendance_status, faculty_id, term_id) VALUES
('2022-01-20', 213902045, 1, 1, 'Present', 5000, 1),
('2022-01-20', 213902046, 2, 2, 'Absent', 5001, 1),
('2022-01-20', 213902047, 3, 3, 'Present', 5002, 1),
('2022-01-21', 213902048, 4, 4, 'Present', 5003, 2),
('2022-01-21', 213902049, 5, 5, 'Absent', 5004, 2);



INSERT INTO Attendance (date, student_id, course_id, sec_id, attendance_status, faculty_id, term_id) VALUES
('2022-01-20', 213902046, 1, 1, 'Absent', 5000, 1),
('2022-02-20', 213902046, 2, 2, 'Absent', 5001, 1),
('2022-03-20', 213902046, 3, 3, 'Absent', 5002, 1),
('2022-04-21', 213902046, 4, 4, 'Absent', 5003, 2),
('2022-01-21', 213902046, 5, 5, 'Absent', 5004, 2);

-- Insert data into CourseEnrollment
-- Insert data into CourseEnrollment
INSERT INTO CourseEnrollment (student_id, course_id, sec_id, term_id, status) VALUES
(213902045, 1, 1, 1,'enrolled'),
(213902047, 3, 3, 1,'enrolled'),
(213902048, 4, 4, 1,'enrolled'),
(213902049, 5, 5, 2,'enrolled');

INSERT INTO CourseEnrollment (student_id, course_id, sec_id, term_id, status) VALUES
(213902045, 1, 1, 1,'enrolled'),
(213902046, 2, 2, 1,'enrolled'),
(213902046, 3, 3, 1,'enrolled'),
(213902046, 4, 4, 1,'enrolled'),
(213902049, 5, 5, 2,'enrolled');


-- Insert data into Alumni
INSERT INTO Alumni (student_id, graduation_year, job, company, salary) VALUES
(213902050, 2018, 'Software Engineer', 'TechSolution Ltd.', 60000.00),
(213902051, 2019, 'Electrical Engineer', 'PowerGrid Corp.', 55000.00),
(213902052, 2020, 'Account Manager', 'FinanceBank Ltd.', 50000.00),
(213902053, 2019, 'Content Writer', 'MediaHouse Ltd.', 45000.00),
(213902054, 2018, 'Legal Advisor', 'LawConsultancy Ltd.', 50000.00);


-- Insert data into ResearchProjects
INSERT INTO ResearchProjects (project_name, lead_faculty_id, budget, start_date, end_date) VALUES
('Artificial Intelligence in Healthcare', 5000, 2000000.00, '2022-01-01', '2023-01-01'),
('Renewable Energy Systems', 5001, 1500000.00, '2022-02-01', '2023-02-01'),
('Consumer Behavior Analysis', 5002, 1000000.00, '2022-03-01', '2023-03-01'),
('Modern English Literature', 5003, 800000.00, '2022-04-01', '2023-04-01'),
('Constitutional Law and Society', 5004, 1200000.00, '2022-05-01', '2023-05-01');

-- Insert data into ExtracurricularActivities
INSERT INTO ExtracurricularActivities (activity_name, student_id, role) VALUES
('Programming Club', 213902046, 'Member'),
('Electronics Club', 213902045, 'President'),
('Business Club', 213902047, 'Treasurer'),
('Literature Club', 213902048, 'Secretary'),
('Law Society', 213902049, 'Member');

-- Insert data into FacultyCourseTerm
INSERT INTO FacultyCourseTerm (faculty_id, course_id, term_id) VALUES
(5000, 1, 1),
(5001, 2, 1),
(5002, 3, 1),
(5003, 4, 2),
(5004, 5, 2);

-- Insert data into FacultyCourseTerm
INSERT INTO FacultyCourseTerm (faculty_id, course_id, term_id) VALUES
(5000, 3, 1),
(5000, 4, 1),
(5000, 5, 1),
(5000, 4, 3),
(5004, 5, 3);



-- Insert data into Drivers
INSERT INTO Drivers (driver_name, phone_number) VALUES
('Abdul Karim', '01812345678'),
('Mohammed Ali', '01887654321'),
('Rashidul Islam', '01811223344'),
('Anwar Hossain', '01822334455'),
('Jahangir Alam', '01833445566');

-- Insert data into RouteLocations
INSERT INTO RouteLocations (location_name) VALUES
('Uttara'),
('Airport'),
('Kuril'),
('Gulshan'),
('Dhanmondi');

-- Insert data into Transportation
INSERT INTO Transportation (transport_name, driver_id) VALUES
('Abdullahpur', 1),
('Mirpur', 2),
('Gulshan', 3),
('Jatrabari', 4),
('Gazipur', 5);

-- Insert data into TransportationSchedule
INSERT INTO TransportationSchedule (transport_id, location_id, departure_time) VALUES
(1, 1, '07:00:00'),
(2, 2, '08:00:00'),
(3, 3, '09:00:00'),
(4, 4, '10:00:00'),
(5, 1, '08:00:00');
