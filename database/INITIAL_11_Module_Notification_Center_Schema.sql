-- =============================================================================
-- Dự án: Fellow4U
-- Module: 11 - Trung tâm Thông báo
-- Mô tả: Quản lý thông báo đẩy (Push), thông báo trong ứng dụng và mẫu nội dung.
-- =============================================================================

-- 1. Khởi tạo kiểu dữ liệu cho loại thông báo
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'notification_category') THEN
        CREATE TYPE notification_category AS ENUM (
            'booking_update',   -- Cập nhật trạng thái tour
            'payment_status',   -- Xác nhận thanh toán
            'chat_arrival',     -- Có tin nhắn mới
            'review_reminder',  -- Nhắc nhở để lại đánh giá
            'system_alert',     -- Thông báo từ quản trị viên
            'promotion'         -- Khuyến mãi/Tin tức
        );
    END IF;
END $$;

-- 2. Bảng Notification_Templates (Quản lý mẫu nội dung)
-- Giúp chuẩn hóa thông điệp và hỗ trợ đa ngôn ngữ dễ dàng
CREATE TABLE IF NOT EXISTS notification_templates (
    template_id SERIAL PRIMARY KEY,
    category notification_category NOT NULL,
    template_key VARCHAR(50) UNIQUE NOT NULL, -- Ví dụ: 'BOOKING_ACCEPTED_TEMPLATE'
    title_pattern TEXT NOT NULL,  -- Ví dụ:"Chuyến đi đã sẵn sàng!"
    body_pattern TEXT NOT NULL,   -- Ví dụ: "{guide_name} đã chấp nhận yêu cầu của bạn tại {location}."
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Bảng Notifications (Lưu trữ thông báo cá nhân)
CREATE TABLE IF NOT EXISTS notifications (
    notif_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    category notification_category NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,

    -- Dữ liệu hỗ trợ Deep-linking (Nhấn vào thông báo mở đúng màn hình)
    related_entity_type VARCHAR(50), -- 'booking', 'review', 'chat', 'news'
    related_entity_id INT,           -- ID của booking_id, news_id,...

    -- Trạng thái
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP WITH TIME ZONE,

    -- Lưu trữ thêm dữ liệu linh hoạt (ví dụ: avatar người gửi, link ảnh)
    extra_data JSONB, 

    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tối ưu hóa truy vấn cho Notification Center
-- Truy vấn nhanh thông báo chưa đọc của 1 User
CREATE INDEX IF NOT EXISTS idx_notifications_unread ON notifications(user_id, is_read) WHERE is_read IS FALSE;
-- Sắp xếp thông báo theo thời gian mới nhất
CREATE INDEX IF NOT EXISTS idx_notifications_created ON notifications(user_id, created_at DESC);

-- 5. Function/Trigger hỗ trợ tự động dọn dẹp (Optional)
-- Xóa các thông báo cũ hơn 90 ngày để giảm tải database
CREATE OR REPLACE PROCEDURE clean_old_notifications()
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM notifications WHERE created_at < NOW() - INTERVAL '90 days';
END;
$$;

-- LƯU Ý: Dữ liệu mẫu (Notification Templates) đã được chuyển sang file Seed riêng.