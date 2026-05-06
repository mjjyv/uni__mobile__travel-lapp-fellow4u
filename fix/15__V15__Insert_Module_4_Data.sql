-- =============================================================================
-- Dữ liệu mẫu cho Module 4: Chi tiết Hành trình
-- =============================================================================

-- 1. Thêm Đơn vị cung cấp (Providers)
INSERT INTO tour_providers (name, website_url, logo_url, rating_avg, description) VALUES
('VietTraveler Co.', 'https://viettraveler.com', 'https://i.pravatar.cc/150?u=viettraveler', 4.9, 'Top rated local tour agency in Da Nang with 10 years of experience.'),
('Sea Sun Tours', 'https://seasuntours.com', 'https://i.pravatar.cc/150?u=seasun', 4.7, 'Specializing in beach and island adventures.')
ON CONFLICT DO NOTHING;

-- 2. Cập nhật Tour hiện có với Provider
UPDATE tours SET 
    provider_id = (SELECT provider_id FROM tour_providers WHERE name = 'VietTraveler Co.' LIMIT 1),
    pickup_point = 'Da Nang International Airport (Terminal 1)'
WHERE title LIKE '%Da Nang%' OR title LIKE '%Hoi An%';

-- 3. Thêm Thư viện ảnh (Images) cho Tour ID 1 (Giả định là tour Đà Nẵng)
INSERT INTO tour_images (tour_id, image_url, display_order, caption) VALUES
(1, 'https://ohdidi.vn/uploads/static/NEWS/blog/du%20lich%20da%20nang%20hoi%20an/du_lich_da_nang_hoi_an_2.png', 1, 'Da Nang - Hoi An Overview'),
(1, 'https://images2.thanhnien.vn/528068263637045248/2025/6/18/the-legend-danang-1-17502421275011965589401.jpg', 2, 'Dragon Bridge'),
(1, 'https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/08/Nui-Ngu-Hanh-Son.png', 3, 'Marble Mountains')
ON CONFLICT DO NOTHING;

-- 4. Thêm Lịch trình (Schedules) cho Tour ID 1
INSERT INTO tour_schedules (tour_id, day_number, start_time, activity_title, description) VALUES
(1, 1, '08:00:00', 'Airport Pickup', 'Our guide will meet you at the arrival hall with a Fellow4U sign.'),
(1, 1, '10:30:00', 'Hotel Check-in', 'Check-in at Furama Resort Da Nang and rest.'),
(1, 1, '15:00:00', 'Marble Mountains Visit', 'Explore the mystical caves and ancient pagodas.'),
(1, 2, '09:00:00', 'Bana Hills Adventure', 'Full day exploring the French Village and Golden Bridge.'),
(1, 2, '18:00:00', 'Seafood Dinner', 'Fresh seafood feast at a local restaurant by the beach.'),
(1, 3, '08:00:00', 'Hoi An Ancient Town', 'A walking tour through the beautiful lanterns and old houses.'),
(1, 3, '14:00:00', 'Souvenir Shopping', 'Free time to buy local gifts before heading to the airport.')
ON CONFLICT DO NOTHING;

-- 5. Thêm Giá theo độ tuổi (Pricing) cho Tour ID 1
INSERT INTO tour_age_pricing (tour_id, age_group_label, price) VALUES
(1, 'Adult (12+ years)', 150.00),
(1, 'Child (5-11 years)', 95.00),
(1, 'Infant (Under 5)', 0.00)
ON CONFLICT DO NOTHING;
