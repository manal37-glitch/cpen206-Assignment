-- Students table
CREATE TABLE students(
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL UNIQUE,
    student_email VARCHAR(50) NOT NULL,
    student_contact VARCHAR(50) NOT NULL
);

-- Lecturers
CREATE TABLE lecturers(
    lecturer_id SERIAL PRIMARY KEY,
    lecturer_name VARCHAR(100) NOT NULL UNIQUE,
    lecturer_email VARCHAR(50) NOT NULL,
    lecturer_contact VARCHAR(50) NOT NULL
);

-- TAs
CREATE TABLE ta(
    ta_id SERIAL PRIMARY KEY,
    ta_name VARCHAR(100) NOT NULL UNIQUE,
    ta_email VARCHAR(50) NOT NULL,
    ta_contact VARCHAR(50) NOT NULL
);

-- Courses
CREATE TABLE courses(
    course_id SERIAL PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_name VARCHAR(100) NOT NULL,
    credit_hours INT NOT NULL,
    lecturer_id INT,
    ta_id INT,
    FOREIGN KEY (lecturer_id) REFERENCES lecturers(lecturer_id),
    FOREIGN KEY (ta_id) REFERENCES ta(ta_id)
);

-- Enrollments
CREATE TABLE course_enrollment(
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Fees
CREATE TABLE student_fees(
    payment_id SERIAL PRIMARY KEY,
    payment_date DATE,
    amount_paid NUMERIC(10,2) NOT NULL,
    balance NUMERIC(10,2) NOT NULL,
    student_id INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Users for login/register
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    password TEXT NOT NULL
);

-- Students
INSERT INTO students (student_name, student_email, student_contact)
VALUES ('Ohnyu Lee', 'olee@university.edu', '33783'),
       ('Manal Mohammed', 'mak@university.edu', '0382974');

-- Lecturers
INSERT INTO lecturers (lecturer_name, lecturer_email, lecturer_contact)
VALUES ('Mr. John Assiamah', 'jasi@university.edu', '064536'),
       ('Dr. Margeret', 'mar@university.edu', '06453634');

-- TAs
INSERT INTO ta (ta_name, ta_email, ta_contact)
VALUES ('Akosua', 'ak@ug.edu.gh', '2839348'),
       ('Kudus Banna', 'kb@ug.edu.gh', '2844348');

-- Courses
INSERT INTO courses (course_code, course_name, credit_hours, lecturer_id, ta_id)
VALUES ('CPEN 208', 'Software Engineering', 3, 1, 1),
       ('CPEN 202', 'Data Structures', 3, 2, 2);

-- Enrollments
INSERT INTO course_enrollment (student_id, course_id, enrollment_date)
VALUES (1, 1, CURRENT_DATE),
       (2, 2, CURRENT_DATE);

-- Fees
INSERT INTO student_fees (student_id, amount_paid, balance, payment_date)
VALUES (1, 1500.00, 500.00, CURRENT_DATE),
       (2, 1000.00, 1000.00, CURRENT_DATE);

CREATE OR REPLACE FUNCTION outstanding_fees()
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_agg(row_to_json(sub))
    INTO result
    FROM (
        SELECT
            s.student_id,
            s.student_name AS full_name,
            COUNT(e.course_id) * 1000 AS total_fees,
            COALESCE(SUM(f.amount_paid), 0) AS amount_paid,
            (COUNT(e.course_id) * 1000 - COALESCE(SUM(f.amount_paid), 0)) AS outstanding_balance
        FROM students s
        LEFT JOIN course_enrollment e ON s.student_id = e.student_id
        LEFT JOIN student_fees f ON s.student_id = f.student_id
        GROUP BY s.student_id, s.student_name
    ) sub;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM outstanding_fees();