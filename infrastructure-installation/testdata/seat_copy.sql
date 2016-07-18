USE seatmanagement;

CREATE USER 'seatmanagement'@'%' IDENTIFIED BY 'seat';
CREATE USER 'seatoverview'@'%' IDENTIFIED BY 'seat';
GRANT ALL ON seatmanagement.* TO 'seatmanagement'@'%';
GRANT SELECT ON seatmanagement.* TO 'seatoverview'@'%';
