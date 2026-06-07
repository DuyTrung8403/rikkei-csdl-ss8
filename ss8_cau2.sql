CREATE TABLE inventory
(
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    quantity     INT
);

INSERT INTO inventory (product_name, quantity)
VALUES ('Laptop Dell XPS', 10),
       ('Chuột Logitech', 5),
       ('Bàn phím cơ', 0);

-- 1. Viết một Procedure có tên check_stock(p_id INT, p_qty INT) để:
-- Kiểm tra xem sản phẩm có đủ hàng không
-- Nếu quantity < p_qty, in ra thông báo lỗi bằng RAISE EXCEPTION ‘Không đủ hàng trong kho’
CREATE OR REPLACE PROCEDURE check_stock(
    p_id INT,
    p_qty INT
)
    language plpgsql
AS
$$
DECLARE
    current_quantity INT;
BEGIN
    SELECT i.quantity INTO quantity FROM inventory i WHERE i.product_id = p_id;
    IF current_quantity < p_qty THEN
        RAISE EXCEPTION 'Khong du hang trong kho';
    end if;
end;
$$;

-- 2. Gọi Procedure với các trường hợp:
-- Một sản phẩm có đủ hàng
CALL check_stock(1, 8);
-- Một sản phẩm không đủ hàng
CALL check_stock(3, 8);