CREATE DATABASE IF NOT EXISTS placement_db;

USE placement_db;

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    email VARCHAR(100),
    phone VARCHAR(100),
    enrollment_year INT,
    batch VARCHAR(10)
);

CREATE TABLE Programming (
    student_id INT,
    problems_solved INT,
    assessments_completed INT,
    projects_submitted INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

CREATE TABLE SoftSkills (
    student_id INT,
    communication INT,
    teamwork INT,
    presentation INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

CREATE TABLE Placements (
    student_id INT,
    placement_ready VARCHAR(10),
    mock_interview_score INT,
    internship_experience VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

SELECT s.batch, AVG(p.problems_solved) AS avg_problems
FROM Students s
JOIN Programming p ON s.student_id = p.student_id
GROUP BY s.batch;

SELECT s.name, p.mock_interview_score
FROM Students s
JOIN Placements p ON s.student_id = p.student_id
WHERE p.placement_ready = 'Yes'
ORDER BY p.mock_interview_score DESC
LIMIT 5;

SELECT student_id,
       (communication + teamwork + presentation)/3 AS avg_soft_skills
FROM SoftSkills;

SELECT s.name
FROM Students s
JOIN Placements p ON s.student_id = p.student_id
WHERE p.internship_experience = 'Yes'
  AND p.placement_ready = 'No';

SELECT s.name
FROM Students s
JOIN Programming pr ON s.student_id = pr.student_id
JOIN SoftSkills ss ON s.student_id = ss.student_id
WHERE pr.problems_solved > 70
  AND (ss.communication + ss.teamwork + ss.presentation)/3 > 80;
  
SELECT s.batch, AVG(p.mock_interview_score) AS avg_mock_score
FROM Students s
JOIN Placements p ON s.student_id = p.student_id
GROUP BY s.batch;

SELECT placement_ready, COUNT(*) AS total
FROM Placements
GROUP BY placement_ready;

SELECT s.name
FROM Students s
JOIN Programming p ON s.student_id = p.student_id
WHERE p.projects_submitted = 0;

SELECT s.name, ss.communication
FROM Students s
JOIN SoftSkills ss ON s.student_id = ss.student_id
WHERE ss.communication > 90;

SELECT s.name
FROM Students s
JOIN SoftSkills ss ON s.student_id = ss.student_id
JOIN Placements p ON s.student_id = p.student_id
WHERE (ss.communication + ss.teamwork + ss.presentation)/3 > 85
  AND p.mock_interview_score < 50;








