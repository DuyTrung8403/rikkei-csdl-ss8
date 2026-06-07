CREATE TABLE products
(
    id              SERIAL PRIMARY KEY,
    name            VARCHAR(100),
    price           NUMERIC(10, 2),
    discount_pecent INT
);

INSERT INTO products (name, price, discount_pecent)
VALUES
    ('Balo đi học', 500000.00, 20),
    ('Chuột Gaming', 800000.00, 70);

-- 1. Viết Procedure calculate_discount(p_id INT, OUT p_final_price NUMERIC) để:
-- Lấy price và discount_percent của sản phẩm
CREATE OR REPLACE PROCEDURE calculate_discount(
    p_id INT,
    OUT p_final_price NUMERIC
)
    language plpgsql
AS
$$
DECLARE
v_current_price NUMERIC(10,2);
    v_current_discount_percent INT;
BEGIN
    SELECT p.price, p.discount_pecent INTO v_current_price, v_current_discount_percent FROM products p WHERE p.id = p_id;
    -- Tính giá sau giảm: p_final_price = price - (price * discount_percent / 100)
    p_final_price := v_current_price - (v_current_price * v_current_discount_percent / 100);
    -- Nếu phần trăm giảm giá > 50, thì giới hạn chỉ còn 50%
    IF v_current_discount_percent > 50 THEN
        p_final_price := v_current_price - (v_current_price * 50 / 100);
    end if;
    -- 2.Cập nhật lại cột price trong bảng products thành giá sau giảm
    UPDATE products SET price = p_final_price WHERE id = p_id;
end;
$$;

DO $$
    DECLARE
        v_final_price NUMERIC(10,2);
    BEGIN
        CALL calculate_discount(2, v_final_price);
        RAISE NOTICE 'Giá sau khi giảm là: %', v_final_price;
    END;
$$;

