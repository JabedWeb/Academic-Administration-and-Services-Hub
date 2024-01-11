-- *************************** Triggered into payment table ********************************
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
(213902046, 3000, curdate(), 'Tuition Fee', 'Bank', 'Completed');




-- *************************** Triggered into Marks Table ********************************
-- triggered for marks table, when mark is inserted, updated, deleted then update the grade, status and grade_point into enrolled table
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