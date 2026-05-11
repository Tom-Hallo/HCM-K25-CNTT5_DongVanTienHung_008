CREATE DATABASE hackathon_db;
USE hackathon_db;

-- PHẦN 1: TẠO CSDL VÀ CÁC BẢNG
-- CÂU 1:
-- BẢNG GUESTS
CREATE TABLE Guests (
	guest_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE
);

-- BẢNG ROOMTYPES
CREATE TABLE RoomTypes (
	type_id VARCHAR(5) PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL UNIQUE
);

-- BẢNG ROOMS
CREATE TABLE Rooms (
	room_id VARCHAR(5) PRIMARY KEY,
    room_name VARCHAR(100) NOT NULL UNIQUE,
    type_id VARCHAR(5) NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    capacity INT NOT NULL,
    
    FOREIGN KEY (type_id) REFERENCES RoomTypes(type_id)
);

-- BẢNG RESERVATIONS
CREATE TABLE Reservations (
	reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id VARCHAR(5) NOT NULL,
    room_id VARCHAR(5) NOT NULL,
    status  VARCHAR(20), -- ENUM('Booked','Checked-in','Cancelled')
	check_in_date DATE NOT NULL,
    
    FOREIGN KEY (guest_id) REFERENCES Guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

-- Câu 2:
-- THÊM DL BẢNG GUESTS
INSERT INTO Guests (guest_id, full_name, email, phone)
VALUES
('G01','Lê Văn Tám','tam.lv@gmail.com','0901111111'),
('G02','Bùi Thị Lan','lan.bt@gmail.com','0902222222'),
('G03','Đỗ Hữu Trọng','trong.dh@gmail.com','0903333333'),
('G04','Lý Thanh Hà','ha.lt@gmail.com','0904444444'),
('G05','Trương Vĩnh Ký','ky.tv@gmail.com','0905555555');

-- THÊM DL BẢNG ROOMTYPES
INSERT INTO RoomTypes (type_id, type_name)
VALUES
('T01','Standard'),
('T02','Superior'),
('T03','Deluxe'),
('T04','Suite');

-- THÊM DL BẢNG ROOMS
INSERT INTO Rooms (room_id, room_name, type_id, price_per_night, capacity)
VALUES
('R01','Phòng 101','T01',500000,2),
('R02','Phòng 102','T01',500000,2),
('R03','Phòng 201','T02',800000,2),
('R04','Phòng 301','T03',1200000,3),
('R05','Phòng 401','T04',2500000,4);

-- THÊM DL BẢNG RESERVATIONS
INSERT INTO Reservations (reservation_id, guest_id,room_id,status,check_in_date)
VALUES
(1,'G01','R01','Booked','2025-10-01'),
(2,'G02','R03','Checked-in','2025-10-02'),
(3,'G01','R02','Checked-in','2025-10-03'),
(4,'G04','R05','Cancelled','2025-10-04'),
(5,'G05','R01','Booked','2025-10-05');

-- CÂU 3:
UPDATE Rooms SET capacity = capacity + 2 WHERE room_name = 'Phòng 401';
UPDATE Rooms SET price_per_night = price_per_night * 1.05 WHERE room_name = 'Phòng 401';
-- CÂU 4:
UPDATE Guests SET phone = '0999999999' WHERE guest_id = 'G03';
-- CÂU 5:
DELETE FROM Reservations WHERE status = 'Cancelled' AND check_in_date < '2025-10-03';

-- PHẦN 2: Truy vấn DLCB
-- CÂU 6:
SELECT room_id, room_name, price_per_night
FROM rooms
WHERE (price_per_night BETWEEN 800000 AND 2000000) AND capacity > 2;

-- CÂU 7:
SELECT full_name, email
FROM Guests
WHERE full_name LIKE ('Lê%');

-- CÂU 8:
SELECT reservation_id, guest_id, check_in_date
FROM Reservations
ORDER BY check_in_date DESC;

-- CÂU 9:
SELECT * 
FROM Rooms
ORDER BY price_per_night DESC
LIMIT 3;

-- CÂU 10:
SELECT room_name, capacity
FROM Rooms
LIMIT 2 OFFSET 2;

-- PHẦN 3: TRUY VẤN DLNC
-- CÂU 11:
SELECT r.reservation_id, g.full_name, ro.room_name, r.check_in_date
FROM reservations r
JOIN guests g ON r.guest_id = g.guest_id
JOIN rooms ro ON ro.room_id = r.room_id
WHERE status = 'Booked';

-- CÂU 12:
SELECT type_name, room_name
FROM rooms r
RIGHT JOIN roomtypes rt ON r.type_id = rt.type_id;

-- CÂU 13:
SELECT status, COUNT(status) AS Total_Reservations
FROM reservations
GROUP BY status;

-- CÂU 14:
SELECT full_name, COUNT(reservation_id) AS total_ordered
FROM guests g
JOIN reservations r ON g.guest_id = r.guest_id
GROUP BY g.guest_id,g.full_name
HAVING total_ordered >= 2;

-- CÂU 15:
SELECT room_id, room_name, price_per_night
FROM rooms
WHERE price_per_night < (	
	SELECT AVG(price_per_night) AS average_price FROM rooms
);

-- CÂU 16:
SELECT full_name, phone 
FROM guests g
JOIN reservations re ON g.guest_id = re.guest_id
JOIN rooms ro ON re.room_id = ro.room_id
WHERE ro.room_name = 'Phòng 101' AND re.status = 'Booked';





