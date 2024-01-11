--Login Query (Authenticating Users):
SELECT * FROM UserAccounts WHERE username = 'Jabed' AND password_hash = SHA2('password1', 256);


-- User Dashboard (Displaying Personal Information):
SELECT * FROM Students WHERE student_id = 213902046;

--Editing Personal Information:
UPDATE Students SET first_name = 'Md Jabed' WHERE student_id = 213902046;


-- View Academic Advisor Details:
SELECT f.first_name, f.last_name, f.email, f.phone_number 
FROM Faculty f 
JOIN Students s ON f.faculty_id = s.advisor_id 
WHERE s.student_id = "213902046";


--Viewing Class Schedule for the  Student with teacher name: 
-- done

SELECT c.course_name, c.course_code, s.day, s.start_time, s.end_time ,f.first_name, f.last_name, f.email, f.phone_number
FROM Section sec
JOIN Courses c ON sec.course_id = c.course_id
JOIN Timeslot s ON sec.time_slot_id = s.time_slot_id
JOIN Faculty f ON sec.instructor_id = f.faculty_id
JOIN CourseEnrollment ce ON sec.sec_id = ce.sec_id
WHERE ce.student_id = 213902046 AND ce.term_id = 1;




--Find Class Representatives for Specific Courses in a Term:
SELECT cr.student_id, s.first_name, s.last_name, s.phone, c.course_name, t.term_name 
FROM ClassRepresentatives cr 
JOIN Students s ON cr.student_id = s.student_id 
JOIN Section sec ON cr.sec_id = sec.sec_id 
JOIN Courses c ON sec.course_id = c.course_id 
JOIN Term t ON cr.term_id = t.term_id 
WHERE c.course_id IN 
    (SELECT course_id FROM CourseEnrollment WHERE student_id = "213902046" AND term_id = "1");




-- Find Nearest Transportation Route Based on Address:
SELECT t.transport_name, d.driver_name, d.phone_number, r.location_name, ts.departure_time 
FROM Students s 
JOIN RouteLocations r ON s.address LIKE CONCAT('%', r.location_name, '%') 
JOIN TransportationSchedule ts ON r.location_id = ts.location_id 
JOIN Transportation t ON ts.transport_id = t.transport_id 
JOIN Drivers d ON t.driver_id = d.driver_id 
WHERE s.student_id = "213902046";



-- View Schedule for Current Term:
SELECT c.course_name, sc.day, sc.start_time, sc.end_time, cl.building, cl.room_number 
FROM Section sec 
JOIN Courses c ON sec.course_id = c.course_id 
JOIN Timeslot sc ON sec.time_slot_id = sc.time_slot_id 
JOIN Classroom cl ON sec.classroom_id = cl.classroom_id 
WHERE sec.term_id = "1" AND sec.course_id IN 
    (SELECT course_id FROM CourseEnrollment WHERE student_id = "213902046" AND term_id = "1");


-- View Participation in Extracurricular Activities:
SELECT activity_name, role 
FROM ExtracurricularActivities 
WHERE student_id = "213902046";




-- Alumni Details with Department:
SELECT a.student_id, s.first_name, s.last_name, d.department_full_name, a.graduation_year, a.job, a.company
FROM Alumni a
JOIN Students s ON a.student_id = s.student_id
JOIN Departments d ON s.department_id = d.department_id;



---------------------------------------------
---------------------------------------------
 -- Trigger based

-- Calculate Total Credit completed for a Specific Student
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




-- Check Financials - Payments and Due Amount:
SELECT p.payment_date, p.amount, p.status 
FROM Payments p 
WHERE p.student_id = "213902046";


-- To view outstanding dues:
SELECT payable_ammount 
FROM AmountToPay 
WHERE student_id = "213902046";


-- Total Payments Made by the Student:
SELECT SUM(amount) as TotalPaid
FROM Payments
WHERE student_id = 213902046;





 -- view as a faculty member

-- List of Students Who Have Been Absent More Than 3 Times in a Term
SELECT 
    a.student_id, s.first_name,  s.last_name, COUNT(*) AS absence_count FROM  Attendance a
JOIN 
    Students s ON a.student_id = s.student_id
WHERE 
    a.attendance_status = 'Absent'
    AND a.term_id = 1
GROUP BY 
    a.student_id
HAVING 
    COUNT(*) > 3;


-- Faculty Members Who Teach More Than 3 Courses
SELECT f.faculty_id, f.first_name, f.last_name, COUNT(*) AS courses_taken
FROM Faculty f
JOIN FacultyCourseTerm fct ON f.faculty_id = fct.faculty_id
GROUP BY f.faculty_id
HAVING COUNT(*) > 3;



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




--  count the number of students in each department
SELECT d.department_name, COUNT(*) AS student_count
FROM Students s
JOIN Departments d ON s.department_id = d.department_id
GROUP BY d.department_name;

--Administrative Removal of a Student:
DELETE FROM Students WHERE student_id = 213902047;




 -- research project query

SELECT 
    rp.project_name, rp.budget, rp.start_date, rp.end_date, f.first_name, f.last_name
FROM
    ResearchProjects rp
        JOIN
    Faculty f ON rp.lead_faculty_id = f.faculty_id;
    