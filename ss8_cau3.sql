CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    job_level INT,
    salary NUMERIC (10,2)
);

INSERT INTO employees (emp_name, job_level, salary)
VALUES
    ('Nguyễn Văn A', 1, 10000000.00),
    ('Trần Thị B', 2, 15000000.00),
    ('Lê Văn C', 3, 20000000.00);

-- 1.Tạo Procedure adjust_salary(p_emp_id INT, OUT p_new_salary NUMERIC) để:
-- Nhận emp_id của nhân viên
-- Cập nhật lương theo quy tắc Level 1 → tăng 5%, Level 2 → tăng 10%, Level 3 → tăng 15%
-- Trả về p_new_salary (lương mới) sau khi cập nhật

CREATE OR REPLACE PROCEDURE adjust_salary(
    p_emp_id INT,
    OUT p_new_salary NUMERIC(10,2)
) language plpgsql
AS $$
    DECLARE
    v_job_level INT;
    v_current_salary NUMERIC (10,2);
    BEGIN
        SELECT e.job_level,e.salary INTO v_job_level, v_current_salary FROM employees e WHERE e.emp_id = p_emp_id;
        IF v_job_level = 1 THEN
            p_new_salary := v_current_salary + v_current_salary * 0.05;
        ELSEIF v_job_level = 2 THEN
            p_new_salary := v_current_salary + v_current_salary * 0.1;
        ELSEIF v_job_level = 3 THEN
            p_new_salary := v_current_salary + v_current_salary * 0.15;
        ELSE
            RAISE EXCEPTION 'Level khong hop le, vui long thu lai';
        end if;

        UPDATE employees SET salary = p_new_salary where emp_id = p_emp_id;

    end;
$$;

DO $$
    DECLARE
        p_new_salary NUMERIC(10,2);
    BEGIN
        CALL adjust_salary (3,p_new_salary);
        RAISE NOTICE 'Lương mới sau khi cập nhật là: %', p_new_salary;
    END;
$$;