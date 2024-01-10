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
DELIMITER $$

CREATE TRIGGER update_enrollment_grade_point_status
AFTER INSERT ON marks
FOR EACH ROW
BEGIN
    DECLARE letterGrade CHAR(2);
    DECLARE GPA DECIMAL(3,2); 
	DECLARE Course_Status VARCHAR(20);
    SET Course_Status = 'Completed';

    --  grade and CGPA based on the mark
    IF NEW.mark >= 80  AND NEW.mark <=100 THEN
        SET letterGrade = 'A+';
        SET GPA = 4.00;
    ELSEIF NEW.mark >= 75 THEN
        SET letterGrade = 'A';
        SET GPA = 3.75;
    ELSEIF NEW.mark >= 70 THEN
        SET letterGrade = 'A-';
        SET GPA = 3.50;
    ELSEIF NEW.mark >= 65 THEN
        SET letterGrade = 'B+';
        SET GPA = 3.25;
    ELSEIF NEW.mark >= 60 THEN
        SET letterGrade = 'B';
        SET GPA = 3.00;
    ELSEIF NEW.mark >= 55 THEN
        SET letterGrade = 'B-';
        SET GPA = 2.75;
    ELSEIF NEW.mark >= 50 THEN
        SET letterGrade = 'C+';
        SET GPA = 2.50;
    ELSEIF NEW.mark >= 45 THEN
        SET letterGrade = 'C';
        SET GPA = 2.25;
    ELSEIF NEW.mark >= 40 THEN
        SET letterGrade = 'D';
        SET GPA = 2.00;
    ELSE
		SET Course_Status = 'Incompleted';
        SET letterGrade = 'F';
        SET GPA = 0.00;
    END IF;

    -- Update the enrollment table grade, status and grade_point of this subject
    UPDATE courseenrollment
    SET status = Course_Status,
        grade = letterGrade, 
        grade_point = GPA
    WHERE student_id = NEW.student_id AND course_id = NEW.course_id;
    
END$$

DELIMITER ;

-- Insert mark for a student
INSERT INTO marks (student_id, course_id, mark) 
VALUES (213902046, 3, 80.00);


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





DELIMITER $$
CREATE TRIGGER after_payment_insert
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    -- check exists, then update payable_amount value
    IF EXISTS (SELECT 1 FROM AmountToPay WHERE student_id = NEW.student_id) THEN
        UPDATE AmountToPay
        SET payable_ammount = payable_ammount - NEW.amount
        WHERE student_id = NEW.student_id;
    ELSE
        -- if doesn't exits then assume initial amount to pay 550000
        INSERT INTO AmountToPay (student_id, payable_ammount)
        VALUES (NEW.student_id, 550000 - NEW.amount);
    END IF;
END$$
DELIMITER ;


insert into Payments (student_id, amount, payment_date, payment_type, payment_method, status)
values
(213902046, 300000, curdate(), 'Tuition Fee', 'Bank', 'Completed');

-- Insert data into Payments
INSERT INTO Payments (student_id, amount, payment_date, payment_type, payment_method, status) VALUES
(213902045, 15000.00, curdate(), 'Tuition Fee', 'Online', 'Completed'),
(213902046, 12000.00, curdate(), 'Tuition Fee', 'Bank Transfer', 'Completed'),
(213902047, 13000.00, curdate(), 'Tuition Fee', 'Cash', 'Completed'),
(213902048, 14000.00, curdate(), 'Tuition Fee', 'Online', 'Completed'),
(213902049, 11000.00, curdate(), 'Tuition Fee', 'Bank Transfer', 'Completed');


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
    a.student_id, 
    s.first_name, 
    s.last_name
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


INSERT INTO ResearchProjects (project_name, lead_faculty_id, budget, start_date, end_date) VALUES
('Artificial Intelligence in Healthcare', 5000, 2000000.00, '2022-01-01', '2023-01-01'),
('Renewable Energy Systems', 5001, 1500000.00, '2022-02-01', '2023-02-01'),
('Consumer Behavior Analysis', 5002, 1000000.00, '2022-03-01', '2023-03-01'),
('Modern English Literature', 5003, 800000.00, '2022-04-01', '2023-04-01'),
('Constitutional Law and Society', 5004, 1200000.00, '2022-05-01', '2023-05-01');

 -- research project query

SELECT 
    rp.project_name, rp.budget, rp.start_date, rp.end_date, f.first_name, f.last_name
FROM
    ResearchProjects rp
        JOIN
    Faculty f ON rp.lead_faculty_id = f.faculty_id;
    