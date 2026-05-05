-- =============================================================================
-- Dự án: Fellow4U
-- Module: 08 - Khởi tạo yêu cầu dịch vụ (Trip Request Builder)
-- Mô tả: Lưu trữ yêu cầu chuyến đi tùy chỉnh, quản lý địa điểm chọn lọc và ngôn ngữ.
-- =============================================================================

-- 1. Bảng Trip_Requests (Yêu cầu chuyến đi tùy chỉnh)
-- Đây là "bản tin tuyển dụng" mà Traveler tạo ra để thu hút các Guide
CREATE TABLE IF NOT EXISTS trip_requests (
    request_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    
    -- Thông tin địa điểm & Thời gian
    destination_name VARCHAR(255) NOT NULL, -- Tên điểm đến (có thể là city hoặc vùng miền)
    location_id INT REFERENCES locations(location_id), -- Link tới bảng địa điểm chính thức nếu có
    
    start_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    
    -- Tham số định lượng
    travelers_count INT NOT NULL DEFAULT 1 CHECK (travelers_count > 0),
    budget_per_hour DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    
    -- Trạng thái yêu cầu
    status ENUM('pending', 'active', 'converted', 'expired') DEFAULT 'active',
    
    description TEXT, -- Ghi chú thêm từ khách hàng
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT check_time_order CHECK (end_time > start_time)
);

-- 2. Bảng Request_Attractions (Danh sách địa điểm tham quan được chọn)
-- Quản lý quan hệ Nhiều-Nhiều giữa một yêu cầu và các điểm tham quan (Attractions)
CREATE TABLE IF NOT EXISTS request_attractions (
    request_id INT NOT NULL REFERENCES trip_requests(request_id) ON DELETE CASCADE,
    attraction_id INT NOT NULL REFERENCES attractions(attraction_id) ON DELETE CASCADE,
    sort_order INT DEFAULT 0, -- Thứ tự ưu tiên tham quan
    PRIMARY KEY (request_id, attraction_id)
);

-- 3. Bảng Request_Languages (Yêu cầu ngôn ngữ cho Guide)
CREATE TABLE IF NOT EXISTS request_languages (
    request_id INT NOT NULL REFERENCES trip_requests(request_id) ON DELETE CASCADE,
    lang_id INT NOT NULL REFERENCES languages(lang_id) ON DELETE CASCADE,
    PRIMARY KEY (request_id, lang_id)
);

-- 4. Tối ưu hóa truy vấn cho Guide tìm việc
-- Giúp Guide lọc các yêu cầu tại khu vực mình hoạt động và theo ngày
CREATE INDEX idx_requests_location_date ON trip_requests(location_id, start_date);
-- Giúp Traveler xem lại các yêu cầu mình đã tạo
CREATE INDEX idx_requests_user_id ON trip_requests(user_id);

-- 5. Trigger tự động cập nhật updated_at
CREATE TRIGGER update_trip_requests_modtime
    BEFORE UPDATE ON trip_requests
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- 6. Logic chuyển đổi (Gợi ý)
-- Khi một Guide được chọn từ Bidding, request_id này sẽ được gắn vào booking_id (Module 7)
-- Cột này sẽ được thêm vào bảng bookings ở Module 7 nếu cần truy vết ngược.
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS source_request_id INT REFERENCES trip_requests(request_id) ON DELETE SET NULL;