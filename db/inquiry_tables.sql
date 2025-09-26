-- 고객 문의 테이블
CREATE TABLE IF NOT EXISTS cust_inquiry (
    inquiry_id INT AUTO_INCREMENT PRIMARY KEY,
    cust_id VARCHAR(30) NOT NULL,
    category VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_cust_inquiry_customer FOREIGN KEY (cust_id) REFERENCES cust (cust_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_cust_inquiry_status CHECK (status IN ('OPEN', 'IN_PROGRESS', 'ANSWERED', 'CLOSED')),
    INDEX idx_cust_inquiry_cust (cust_id),
    INDEX idx_cust_inquiry_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 고객 문의 메시지 테이블
CREATE TABLE IF NOT EXISTS cust_inquiry_message (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    inquiry_id INT NOT NULL,
    sender_id VARCHAR(30) NOT NULL,
    sender_type VARCHAR(20) NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_inquiry_message_inquiry FOREIGN KEY (inquiry_id) REFERENCES cust_inquiry (inquiry_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_inquiry_message_sender CHECK (sender_type IN ('CUSTOMER', 'ADMIN')),
    INDEX idx_inquiry_message_inquiry (inquiry_id),
    INDEX idx_inquiry_message_sender (sender_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
