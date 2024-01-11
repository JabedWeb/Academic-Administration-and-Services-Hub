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