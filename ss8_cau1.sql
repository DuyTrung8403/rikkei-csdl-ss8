CREATE TABLE order_detail
(
    id           SERIAL PRIMARY KEY,
    order_id     INT,
    product_name VARCHAR(100),
    quantity     INT,
    unit_price   NUMERIC(10, 2)
);

INSERT INTO order_detail (order_id, product_name, quantity, unit_price)
VALUES
    (1, 'Bàn phím cơ', 2, 550000.00),
    (1, 'Chuột không dây', 1, 300000.00),
    (2, 'Màn hình 24 inch', 1, 3500000.00);

-- 1.Viết một Stored Procedure có tên calculate_order_total(order_id_input INT, OUT total NUMERIC)
-- Tham số order_id_input: mã đơn hàng cần tính
-- Tham số total: tổng giá trị đơn hàng
-- 2.Trong Procedure: Viết câu lệnh tính tổng tiền theo order_id
CREATE OR REPLACE PROCEDURE calculate_order_total(
    order_id_input INT,
    OUT total NUMERIC(10, 2)
)
    language plpgsql
AS
$$
BEGIN
    SELECT SUM(od.quantity * od.unit_price) INTO total FROM order_detail od WHERE od.order_id = order_id_input;
END;
$$;


-- 3.Gọi Procedure để kiểm tra hoạt động với một order_id cụ thể
DO
$$
    DECLARE
    total_price NUMERIC(10,2);
    order_id INT := 1;
    BEGIN
        CALL calculate_order_total(order_id,total_price);
        RAISE NOTICE 'Tong tien cua don hang % la %', order_id, total_price;
    end;
$$;