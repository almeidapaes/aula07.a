/* ============================================================
   QUESTÃO 01 - PROCEDURE
   ============================================================ */

CREATE PROCEDURE student_grade_points
    @grade VARCHAR(2) -- Parâmetro: conceito (A, B+, etc.)
AS
BEGIN
    SELECT 
        s.name AS student_name,
        s.dept_name AS student_department,
        c.title AS course_title,
        c.dept_name AS course_department,
        t.semester,
        t.year,
        t.grade AS alphanumeric_grade,

        -- Conversão de nota letra em numérica
        CASE 
            WHEN t.grade = 'A+' THEN 4.0
            WHEN t.grade = 'A'  THEN 4.0
            WHEN t.grade = 'A-' THEN 3.7
            WHEN t.grade = 'B+' THEN 3.3
            WHEN t.grade = 'B'  THEN 3.0
            WHEN t.grade = 'B-' THEN 2.7
            WHEN t.grade = 'C+' THEN 2.3
            WHEN t.grade = 'C'  THEN 2.0
            WHEN t.grade = 'C-' THEN 1.7
            WHEN t.grade = 'D'  THEN 1.0
            ELSE 0.0
        END AS numeric_grade

    FROM student s
    INNER JOIN takes t ON s.ID = t.ID       -- aluno em disciplinas
    INNER JOIN course c ON t.course_id = c.course_id

    WHERE t.grade = @grade -- filtro pelo parâmetro
END
GO


/* ============================================================
   QUESTÃO 02 - FUNCTION
   ============================================================ */

CREATE FUNCTION return_instructor_location (@instructor_name VARCHAR(100))
RETURNS TABLE
AS
RETURN
(
    SELECT 
        i.name AS instructor_name,
        c.title AS course_title,
        t.semester,
        t.year,
        s.building,
        s.room_number

    FROM instructor i
    INNER JOIN teaches t ON i.ID = t.ID     -- instrutor em turmas
    INNER JOIN section s 
        ON t.course_id = s.course_id
        AND t.sec_id = s.sec_id
        AND t.semester = s.semester
        AND t.year = s.year
    INNER JOIN course c ON t.course_id = c.course_id

    WHERE i.name = @instructor_name -- filtro pelo parâmetro
)
GO
