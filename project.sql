-- tạo data base
CREATE DATABASE hackthon
Use hackthon
-- Câu 2. Tạo bảng cho CSDL
-- Tạo bảng Tác giả
CREATE TABLE tbl_authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT, 
    author_name VARCHAR(100) NOT NULL,       
    birth_year YEAR                          
);

-- Tạo bảng Sách
CREATE TABLE tbl_books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,   
    title VARCHAR(255) NOT NULL,               
    author_id INT,                           
    category VARCHAR(100),                    
    published_year YEAR,                      
    available_copies INT,                     
    FOREIGN KEY (author_id) REFERENCES tbl_authors(author_id)  
);

-- Tạo bảng Bạn đọc
CREATE TABLE tbl_members (
    member_id INT PRIMARY KEY AUTO_INCREMENT, 
    member_name VARCHAR(100) NOT NULL,         
    phone VARCHAR(20) NOT NULL UNIQUE,        
    email VARCHAR(100) NOT NULL UNIQUE,     
    address VARCHAR(255)                      
);

-- Tạo bảng Thông tin chi tiết bạn đọc
CREATE TABLE tbl_member_info (
    member_id INT PRIMARY KEY,                 
    membership_type ENUM('Standard', 'Premium'), 
    registration_date DATE,                    
    expiry_date DATE,                       
    FOREIGN KEY (member_id) REFERENCES tbl_members(member_id)  
);

-- Tạo bảng Mượn trả sách
CREATE TABLE tbl_borrow_records (
    borrow_id INT PRIMARY KEY AUTO_INCREMENT,  
    member_id INT,                            
    book_id INT,                             
    borrow_date DATE,                        
    return_date DATE,                         
    FOREIGN KEY (member_id) REFERENCES tbl_members(member_id),  
    FOREIGN KEY (book_id) REFERENCES tbl_books(book_id)        
);

-- 2.1 Thêm cột tiền phạt vào bảng mượn trả sách
ALTER TABLE tbl_borrow_records
ADD COLUMN fine_amount DECIMAL(10,2);          

-- 2.2 Sửa kiểu dữ liệu cột số điện thoại
ALTER TABLE tbl_members
MODIFY COLUMN phone VARCHAR(15) NOT NULL UNIQUE;  

-- 2.3 Xóa cột ngày hết hạn khỏi bảng thông tin chi tiết
ALTER TABLE tbl_member_info
DROP COLUMN expiry_date;    

-- Câu 3. INSERT INTO dữ liệu vào bẳng
-- Thêm dữ liệu vào bảng tác giả
INSERT INTO tbl_authors (author_id, author_name, birth_year) VALUES
(1, 'Đoàn Giỏi', 1917),
(2, 'Ngô Tất Tố', 1902),
(3, 'Nam Cao', 1917),
(4, 'Vũ Trọng Phụng', 1903),
(5, 'Tô Hoài', 1920);

-- Thêm dữ liệu vào bảng sách
INSERT INTO tbl_books (book_id, title, author_id, category, published_year, available_copies) VALUES
(1, 'Đất rừng phương Nam', 1, 'Tiểu thuyết', 1954, 10),
(2, 'Tắt đèn', 2, 'Tiểu thuyết', 1940, 5),
(3, 'Đời thừa', 3, 'Tiểu thuyết', 1943, 8),
(4, 'Số đỏ', 4, 'Tiểu thuyết', 1940, 12),
(5, 'Dế mèn phiêu lưu ký', 5, 'Truyện thiếu nhi', 1941, 7);

-- Thêm dữ liệu vào bảng bạn đọc
INSERT INTO tbl_members (member_id, member_name, phone, email, address) VALUES
(1, 'Nguyễn Văn A', '0932767326', 'anv@gmail.com', 'Hà Nội'),
(2, 'Trần Thị B', '0992378636', 'btt@gmail.com', 'Hồ Chí Minh'),
(3, 'Lê Văn C', '0932767365', 'clv@gmail.com', 'Đà Nẵng'),
(4, 'Phạm Thị D', '0973265632', 'dpt@gmail.com', 'Hà Nội'),
(5, 'Nguyễn Thị E', '0923865633', 'ent@gmail.com', 'Hồ Chí Minh');

-- Thêm dữ liệu vào bảng thông tin chi tiết bạn đọc
INSERT INTO tbl_member_info (member_id, membership_type, registration_date) VALUES
(1, 'Premium', '2023-01-01'),
(2, 'Standard', '2023-04-05'),
(3, 'Premium', '2023-03-10'),
(4, 'Premium', '2023-02-15'),
(5, 'Standard', '2023-05-20');

-- Thêm dữ liệu vào bảng mượn trả sách
INSERT INTO tbl_borrow_records (borrow_id, member_id, book_id, borrow_date, return_date) VALUES
(1, 1, 1, '2023-01-10', '2023-01-20'),
(2, 2, 2, '2023-02-05', '2023-02-15'),
(3, 3, 3, '2023-03-15', NULL),
(4, 4, 4, '2023-04-10', '2023-04-25'),
(5, 5, 5, '2023-05-05', '2023-05-15');
-- Câu 4.
-- Câu 4a 
-- Viết truy vấn lấy danh sách tất cả các sách có trong thư viện, bao gồm:
-- Mã sách, tên sách, thể loại, năm xuất bản, số bản sách có sẵn.

SELECT book_id,title,category,published_year,available_copies 
FROM tbl_books
-- Câu 4b 
-- Viết truy vấn lấy danh sách tất cả các thành viên đã từng mượn sách, không trùng lặp.

SELECT tbl_members.member_id, tbl_members.member_name, tbl_members.phone, tbl_members.email, tbl_members.address
FROM tbl_members 
INNER JOIN tbl_borrow_records  ON tbl_members.member_id = tbl_borrow_records.member_id
GROUP BY tbl_members.member_id, tbl_members.member_name, tbl_members.phone, tbl_members.email, tbl_members.address
ORDER BY tbl_members.member_id;
-- Câu 5a 
-- Viết truy vấn lấy danh sách tất cả tác giả và số lượng sách họ đã viết, hiển thị:
-- Tên tác giả, số lượng sách đã xuất bản.

SELECT tbl_authors.author_name, COUNT(tbl_books.book_id) as SL_Sach 
FROM tbl_authors 
LEFT JOIN tbl_books  ON tbl_authors.author_id =tbl_books.author_id
GROUP BY  tbl_authors.author_name

--Câu 5b
--Viết truy vấn lấy danh sách tất cả các sách đã từng được mượn, hiển thị:
--Tên sách, số lần được mượn.
SELECT tbl_books.title, COUNT(tbl_borrow_records.book_id) as SL_Muon
FROM tbl_books 
LEFT JOIN tbl_borrow_records  ON tbl_books.book_id =tbl_borrow_records.book_id
GROUP BY  tbl_books.title
-- Câu 6a 
--Viết truy vấn tìm số lượng sách mỗi bạn đọc đã mượn, hiển thị:
--Tên bạn đọc, số lượng sách đã mượn.
SELECT tbl_members.member_name AS Ten_Ban_Doc, COUNT(tbl_borrow_records.book_id) AS SLS_Da_Doc
FROM tbl_members 
INNER JOIN tbl_borrow_records  ON tbl_members.member_id = tbl_borrow_records.member_id
GROUP BY  tbl_members.member_name
-- Câu 6b (5 điểm)
-- Viết truy vấn chỉ hiển thị những bạn đọc đã mượn từ 3 cuốn sách trở lên.

SELECT tbl_members.member_name as Ten_nguoi_Muon, COUNT(tbl_borrow_records.book_id) as Sach_Muon
FROM tbl_members 
INNER JOIN tbl_borrow_records  ON tbl_members.member_id = tbl_borrow_records.member_id
GROUP BY  tbl_members.member_name
HAVING COUNT(tbl_borrow_records.book_id) >= 3

--Câu 7 
--Viết truy vấn lấy danh sách 5 cuốn sách được mượn nhiều nhất, hiển thị:
--Tên sách, tổng số lượt mượn.


SELECT tbl_books.title, COUNT(tbl_borrow_records.book_id) as Tong_Luot_Muon
FROM tbl_books 
INNER JOIN tbl_borrow_records  ON tbl_books.book_id = tbl_borrow_records.book_id
GROUP BY  tbl_books.title
ORDER BY Tong_Luot_Muon DESC
LIMIT 5;
-- Câu 8 
-- Viết truy vấn lấy danh sách tất cả thành viên và số lượng sách họ đã mượn, hiển thị:
-- Tên bạn đọc, tổng số sách đã mượn (hiển thị 0 nếu chưa mượn sách nào).

SELECT tbl_members.member_name, COUNT(tbl_borrow_records.book_id) as total_books_borrowed
FROM tbl_members 
LEFT JOIN tbl_borrow_records  ON tbl_members.member_id = tbl_borrow_records.member_id
GROUP BY tbl_members.member_name

-- Câu 9 
--Câu 9a 
-- Viết truy vấn lấy tên bạn đọc đã mượn nhiều sách nhất, hiển thị:
-- Tên bạn đọc, số lượng sách đã mượn.

SELECT tbl_members.member_name, COUNT(tbl_borrow_records.book_id) as books_borrowed
FROM tbl_members 
INNER JOIN tbl_borrow_records  ON tbl_members.member_id = tbl_borrow_records.member_id
GROUP BY  tbl_members.member_name
HAVING COUNT(tbl_borrow_records.book_id) = (
    SELECT COUNT(book_id)
    FROM tbl_borrow_records
    GROUP BY member_id
    ORDER BY COUNT(book_id) DESC
    LIMIT 1
);


-- Câu 9b
-- Viết truy vấn lấy danh sách các cuốn sách chưa từng được mượn.

SELECT tbl_books.title
FROM tbl_books 
LEFT JOIN tbl_borrow_records  ON tbl_books.book_id = tbl_borrow_records.book_id
WHERE tbl_borrow_records.book_id IS NULL;



