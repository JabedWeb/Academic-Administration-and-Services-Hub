-- --Login Query (Authenticating Users):
-- SELECT * FROM UserAccounts WHERE username = 'Jabed' AND password_hash = SHA2('password1', 256);


-- --User Dashboard (Displaying Personal Information):
-- SELECT * FROM Students WHERE student_id = 213902046;

-- --Editing Personal Information:
-- UPDATE Students SET first_name = 'Md Jabed' WHERE student_id = 213902046;


-- --Administrative Removal of a Student:
-- DELETE FROM Students WHERE student_id = 213902004;

--Viewing Class Schedule for the  Student with teacher name: 
-- done

SELECT c.course_name, c.course_code, s.day, s.start_time, s.end_time ,f.first_name, f.last_name, f.email, f.phone_number
FROM Section sec
JOIN Courses c ON sec.course_id = c.course_id
JOIN Timeslot s ON sec.time_slot_id = s.time_slot_id
JOIN Faculty f ON sec.instructor_id = f.faculty_id
JOIN CourseEnrollment ce ON sec.sec_id = ce.sec_id
WHERE ce.student_id = 213902046 AND ce.term_id = 1;






--Viewing Courses Taught by a Faculty Member: 
-- done 
SELECT c.course_name
FROM Courses c
JOIN FacultyCourseTerm fct ON c.course_id = fct.course_id
WHERE fct.faculty_id = 5000 AND fct.term_id = 1;






--Listing All Books Available in the Library:
-- done 

SELECT title, author_creator FROM Library WHERE availability_status = 'Available';

--Viewing Research Projects:
-- done 
SELECT project_name, start_date, end_date FROM ResearchProjects WHERE lead_faculty_id = 5003;


--Checking Current Enrollments for a Student:
-- done 
SELECT c.course_name, ce.status
FROM CourseEnrollment ce
JOIN Courses c ON ce.course_id = c.course_id
WHERE ce.student_id = 213902046 AND ce.term_id = 1;


-- Finding Student's Advisor Details:
-- done
SELECT f.first_name, f.last_name, f.email, f.phone_number
FROM Faculty f
JOIN Students s ON f.faculty_id = s.advisor_id
WHERE s.student_id = 213902046;


--Viewing Attendance Record for a Student in a Course:

-- done
SELECT date, attendance_status
FROM Attendance
WHERE student_id = 213902046 AND course_id = 1;


-- Extracurricular Activities a Student is Involved In:
-- done 
SELECT activity_name, role
FROM ExtracurricularActivities
WHERE student_id = 213902046;

















-- 1. Retrieve Student Information
-- This query fetches detailed information about students, including their department and advisor details.



SELECT 
    s.student_id, s.first_name, s.last_name, s.email, s.department_id, d.department_name, f.first_name AS advisor_first_name, f.last_name AS advisor_last_name
FROM 
    Students s
JOIN 
    Departments d ON s.department_id = d.department_id
JOIN 
    Faculty f ON s.advisor_id = f.faculty_id;

-- 2. Faculty Workload Analysis
-- This query helps to understand the workload of faculty members by listing the number of courses they are teaching in a term.
SELECT 
    f.faculty_id, f.first_name, f.last_name, COUNT(fct.course_id) AS total_courses
FROM 
    Faculty f
JOIN 
    FacultyCourseTerm fct ON f.faculty_id = fct.faculty_id
GROUP BY 
    f.faculty_id;



-- 3. Course Enrollment Details
-- Fetches information about students enrolled in a specific course during a particular term.
SELECT 
    e.student_id, s.first_name, s.last_name, c.course_name, t.term_name
FROM 
    CourseEnrollment e
JOIN 
    Students s ON e.student_id = s.student_id
JOIN 
    Courses c ON e.course_id = c.course_id
JOIN 
    Term t ON e.term_id = t.term_id
WHERE 
    e.course_id = [Your_Course_ID] AND e.term_id = [Your_Term_ID];
Replace [Your_Course_ID] and [Your_Term_ID] with specific values.



-- 4. Attendance Report
-- Generates an attendance report for a course section during a term.
SELECT 
    a.date, a.student_id, s.first_name, s.last_name, a.attendance_status
FROM 
    Attendance a
JOIN 
    Students s ON a.student_id = s.student_id
WHERE 
    a.course_id = [Course_ID] AND a.sec_id = [Section_ID] AND a.term_id = [Term_ID];



-- 5. Outstanding Payments
-- Lists students who have outstanding payments.

SELECT 
    s.student_id, s.first_name, s.last_name, apt.payable_ammount
FROM 
    AmountToPay apt
JOIN 
    Students s ON apt.student_id = s.student_id
WHERE 
    apt.payable_ammount > 0;



-- 6. Update Student Advisor
-- Updates the advisor for a student.
UPDATE Students
SET 
    advisor_id = [New_Advisor_ID]
WHERE 
    student_id = [Student_ID];



-- 7. Aggregate Departmental Salary Expenditure
-- Calculates the total salary expenditure per department.
SELECT 
    d.department_name, SUM(f.salary) AS total_salary
FROM 
    Faculty f
JOIN 
    Departments d ON f.department_id = d.department_id
GROUP BY 
    d.department_name;




-- 8. Transportation Utilization
-- Provides details of transportation usage, including driver and route information.

SELECT 
    t.transport_name, d.driver_name, rl.location_name, ts.departure_time
FROM 
    TransportationSchedule ts
JOIN 
    Transportation t ON ts.transport_id = t.transport_id
JOIN 
    Drivers d ON t.driver_id = d.driver_id
JOIN 
    RouteLocations rl ON ts.location_id = rl.location_id;





-- 9. Course Prerequisite Check
-- Lists all courses with their prerequisites.

SELECT 
    c1.course_name AS course, c2.course_name AS prerequisite
FROM 
    Courses c1
LEFT JOIN 
    Courses c2 ON c1.prerequisite_course_id = c2.course_id;




-- 10. Alumni Employment Status
-- Fetches employment details of alumni.
SELECT 
    a.student_id, s.first_name, s.last_name, a.job, a.company, a.salary
FROM 
    Alumni a
JOIN 
    Students s ON a.student_id = s.student_id


----------------------------------------


--  count the number of students in each department
SELECT d.department_name, COUNT(*) AS student_count
FROM Students s
JOIN Departments d ON s.department_id = d.department_id
GROUP BY d.department_name;


-- Calculate the total amount collected through various payment methods
SELECT payment_method, SUM(amount) AS total_collected
FROM Payments
GROUP BY payment_method;


-- Calculate Total Credit taken for a Specific Student
SELECT 
  S.student_id, S.first_name, S.last_name, SUM(C.credits) AS Total_Credits
FROM 
  Students S
JOIN 
  CourseEnrollment CE ON S.student_id = CE.student_id
JOIN 
  Courses C ON CE.course_id = C.course_id
WHERE 
  S.student_id = 213902046 and CE.status = 'Completed'
GROUP BY 
  S.student_id, S.first_name, S.last_name;

 
-- Top 5 highest paid faculty member  
SELECT first_name, last_name, salary
FROM Faculty
ORDER BY salary DESC
LIMIT 5;

 
-- Faculty Members with Salaries Above the Department Average
SELECT f.first_name, f.last_name, f.salary
FROM Faculty f
WHERE f.salary > (
  SELECT AVG(salary)
  FROM Faculty
  WHERE department_id = f.department_id
);

 
-- Search Faculty Members by Name
SELECT first_name, last_name
FROM Faculty
WHERE first_name LIKE '%aminur%';

 
-- Update a specific student email, phone or anything
UPDATE Students
SET email = 'newemail@university.edu'
WHERE student_id = 213902046;


 
-- List of Students Who Have Not Paid Their Dues in specific department
SELECT 
  s.first_name,  s.last_name, d.department_name FROM Students s
JOIN 
  Departments d ON s.department_id = d.department_id
WHERE 
  s.student_id NOT IN (
    SELECT  p.student_id FROM Payments p WHERE p.status = 'Completed'
      AND p.payment_date <= '2022-01-15'
  )
  AND d.department_name = 'CSE';

 
-- Total Budget of Completed Research Projects in a specific end date
SELECT SUM(budget) AS total_completed_budget
FROM ResearchProjects
WHERE end_date < CURRENT_DATE;

 
-- Faculty Members Who Teach More Than 3 Courses
SELECT f.faculty_id, f.first_name, f.last_name, COUNT(*) AS courses_taken
FROM Faculty f
JOIN FacultyCourseTerm fct ON f.faculty_id = fct.faculty_id
GROUP BY f.faculty_id
HAVING COUNT(*) > 3;

 



  



















-- View Grades for a Specific Term:
SELECT c.course_name, e.grade 
FROM CourseEnrollment e 
JOIN Courses c ON e.course_id = c.course_id 
WHERE e.student_id = [Your Student ID] AND e.term_id = [Specific Term ID];


-- Check Attendance Record for a Specific Term:
SELECT a.date, c.course_name, a.attendance_status 
FROM Attendance a 
JOIN Courses c ON a.course_id = c.course_id 
WHERE a.student_id = "213902046" AND a.term_id = "1";



-- -- View Academic Advisor Details:
-- SELECT f.first_name, f.last_name, f.email, f.phone_number 
-- FROM Faculty f 
-- JOIN Students s ON f.faculty_id = s.advisor_id 
-- WHERE s.student_id = "213902046";



-- -- Check Financials - Payments and Due Amount:
-- SELECT p.payment_date, p.amount, p.status 
-- FROM Payments p 
-- WHERE p.student_id = "213902046";


-- -- To view outstanding dues:
-- SELECT payable_ammount 
-- FROM AmountToPay 
-- WHERE student_id = "213902046";


-- -- View Participation in Extracurricular Activities:
-- SELECT activity_name, role 
-- FROM ExtracurricularActivities 
-- WHERE student_id = "213902046";






-- Find Nearest Transportation Route Based on Address:
-- SELECT t.transport_name, d.driver_name, d.phone_number, r.location_name, ts.departure_time 
-- FROM Students s 
-- JOIN RouteLocations r ON s.address LIKE CONCAT('%', r.location_name, '%') 
-- JOIN TransportationSchedule ts ON r.location_id = ts.location_id 
-- JOIN Transportation t ON ts.transport_id = t.transport_id 
-- JOIN Drivers d ON t.driver_id = d.driver_id 
-- WHERE s.student_id = "213902046";


--Find Class Representatives for Specific Courses in a Term:
-- SELECT cr.student_id, s.first_name, s.last_name, s.phone, c.course_name, t.term_name 
-- FROM ClassRepresentatives cr 
-- JOIN Students s ON cr.student_id = s.student_id 
-- JOIN Section sec ON cr.sec_id = sec.sec_id 
-- JOIN Courses c ON sec.course_id = c.course_id 
-- JOIN Term t ON cr.term_id = t.term_id 
-- WHERE c.course_id IN 
--     (SELECT course_id FROM CourseEnrollment WHERE student_id = "213902046" AND term_id = "1");





