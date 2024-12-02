-- Q1 
CREATE TABLE teachers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    subject VARCHAR(50),
    experience INT,
    salary DECIMAL(10, 2)
);

INSERT INTO teachers (name, subject, experience, salary) VALUES
('Alice', 'Mathematics', 5, 50000),
('Bob', 'Physics', 12, 70000),
('Charlie', 'Chemistry', 8, 60000),
('Diana', 'Biology', 3, 45000),
('Edward', 'History', 15, 75000),
('Fiona', 'Geography', 10, 55000),
('George', 'English', 6, 48000),
('Helen', 'Computer Science', 4, 52000);


-- Q2
DELIMITER $$

CREATE TRIGGER before_insert_teacher
BEFORE INSERT ON teachers
FOR EACH ROW
BEGIN
	IF NEW.salary < 0 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END$$

DELIMITER ;

insert into teachers value (5,'Edward', 'History', 15, 75000);

-- Q3
CREATE TABLE teacher_log (
	log_id INT AUTO_INCREMENT PRIMARY KEY, 
    teacher_id INT,
    action VARCHAR(50),
    timestamp  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER after_insert_teacher
AFTER INSERT ON teachers
FOR EACH ROW
BEGIN
	INSERT INTO teacher_log (teacher_id,action) VALUES (NEW.id,"insert new teacher");
END $$

DELIMITER ;

insert into teachers (name, subject, experience, salary) value ('elen', 'Science', 4,62000);
select * from teachers;

-- Q4

DELIMITER $$

CREATE TRIGGER delete_exp
BEFORE DELETE ON teachers
FOR EACH ROW
BEGIN
	IF OLD.experience > 10 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Cannot delete teachers with more than 10 years of experience';
    END IF;
END $$

DELIMITER ;
DELETE FROM teachers WHERE id = 5;


-- Q5
DELIMITER $$

CREATE TRIGGER after_delete
AFTER DELETE ON teachers
FOR EACH ROW
BEGIN
	INSERT INTO teacher_log (teacher_id,action) VALUES (OLD.ID,'teacher deleted');
END $$

DELIMITER ;
DELETE FROM teachers WHERE id = 1;
SELECT * FROM teacher_log;