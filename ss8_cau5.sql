CREATE TABLE employees
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary     NUMERIC(10, 2),
    bonus      NUMERIC DEFAULT 0
);

INSERT INTO employees (name, department, salary)
VALUES ('Nguyen Van A', 'HR', 4000),
       ('Tran Thi B', 'IT', 6000),
       ('Le Van C', 'Finance', 10500),
       ('Pham Thi D', 'IT', 8000),
       ('Do Van E', 'HR', 12000);

CREATE OR REPLACE PROCEDURE update_employee_status(
    p_emp_id INT,
    OUT p_status TEXT
)
    language plpgsql
AS
$$
DECLARE
    v_emp_id         INT;
    v_salary         NUMERIC(10, 2);
    v_current_status TEXT;
BEGIN
    SELECT id, salary INTO v_emp_id,v_salary FROM employees WHERE id = p_emp_id;
    -- Nếu nhân viên không tồn tại, ném lỗi "Employee not found"
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee not found';
    end if;
    IF v_salary < 0 THEN
        RAISE EXCEPTION 'Luong k hop le';
    -- Nếu lương < 5000 → cập nhật status = 'Junior'
    ELSEIF v_salary < 5000 THEN
        p_status := 'Junior';
    --Nếu lương từ 5000–10000 → cập nhật status = 'Mid-level'
    ELSEIF v_salary BETWEEN 5000 AND 10000 THEN
        p_status := 'Mid-level';
    --Nếu lương > 10000 → cập nhật status = 'Senior’
    ELSE
        p_status := 'Senior';
    END IF;
end;
$$;

DO
$$
-- Trả ra p_status sau khi cập nhật
    DECLARE
        v_status TEXT;
        v_id     INT := 1;
    BEGIN
        CALL update_employee_status(v_id, v_status);
        RAISE NOTICE 'Status cua nhan vien co ma % la %', v_id, v_status;
    END;
$$;