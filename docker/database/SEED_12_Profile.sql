-- =============================================================================
-- SEED 12: Profile & Personal Content (Module 12)
-- Mô tả: User Photos, Journeys (Albums), Settings, Security Logs
-- =============================================================================

-- 1. Cập nhật thông tin mở rộng cho Users (Bio, Cover, DOB, Gender)
-- Dữ liệu này thường được nhập khi user edit profile
UPDATE users SET
    bio = CASE 
        WHEN email = 'emily@example.com' THEN 'Love traveling and photography. Always looking for hidden gems.'
        WHEN email = 'minh.tran@example.com' THEN 'Digital nomad exploring Asia. Foodie and history buff.'
        ELSE bio 
    END,
    cover_url = CASE 
        WHEN email = 'emily@example.com' THEN 'https://www.agoda.com/wp-content/uploads/2024/04/Featured-image-Han-River-at-night-in-Seoul-South-Korea.jpg'
        WHEN email = 'minh.tran@example.com' THEN 'https://image.vietnam.travel/sites/default/files/styles/top_banner/public/2022-12/shutterstock_1939037803_0.jpg'
        ELSE cover_url 
    END,
    date_of_birth = CASE 
        WHEN email = 'emily@example.com' THEN '1995-05-15'
        WHEN email = 'minh.tran@example.com' THEN '1990-11-20'
        ELSE date_of_birth 
    END,
    gender = CASE 
        WHEN email = 'emily@example.com' THEN 'Female'
        WHEN email = 'minh.tran@example.com' THEN 'Male'
        ELSE gender 
    END
WHERE email IN ('emily@example.com', 'minh.tran@example.com');

-- 2. Kho ảnh cá nhân (User Photos)
-- Emily upload ảnh du lịch
INSERT INTO user_photos (user_id, image_url, storage_provider, width, height, is_public, uploaded_at) VALUES
((SELECT user_id FROM users WHERE email = 'emily@example.com'), 'https://i.pravatar.cc/150?u=emily_photo1', 'local', 1080, 1080, TRUE, CURRENT_TIMESTAMP - INTERVAL '10 days'),
((SELECT user_id FROM users WHERE email = 'emily@example.com'), 'https://i.pravatar.cc/150?u=emily_photo2', 'local', 1080, 1350, TRUE, CURRENT_TIMESTAMP - INTERVAL '8 days'),
((SELECT user_id FROM users WHERE email = 'minh.tran@example.com'), 'https://i.pravatar.cc/150?u=minh_photo1', 'local', 1080, 1080, TRUE, CURRENT_TIMESTAMP - INTERVAL '5 days')
ON CONFLICT DO NOTHING;

-- 3. Nhật ký hành trình (User Journeys / Albums)
-- Emily tạo album "Da Nang Trip 2024"
INSERT INTO user_journeys (user_id, title, location_name, description, likes_count, created_date)
SELECT 
    u.user_id,
    'Da Nang Memories 2024',
    'Da Nang, Vietnam',
    'An unforgettable trip with amazing food and views.',
    12,
    CURRENT_DATE - INTERVAL '5 days'
FROM users u
WHERE u.email = 'emily@example.com'
ON CONFLICT DO NOTHING;

-- Minh tạo album "Seoul Autumn"
INSERT INTO user_journeys (user_id, title, location_name, description, likes_count, created_date)
SELECT 
    u.user_id,
    'Seoul Autumn Vibes',
    'Seoul, South Korea',
    'Beautiful leaves and historic palaces.',
    8,
    CURRENT_DATE - INTERVAL '2 days'
FROM users u
WHERE u.email = 'minh.tran@example.com'
ON CONFLICT DO NOTHING;

-- 4. Gắn ảnh vào Hành trình (Journey Media)
-- Gắn ảnh của Emily vào album Da Nang
INSERT INTO journey_media (journey_id, photo_id, display_order)
SELECT 
    j.journey_id,
    p.photo_id,
    1
FROM user_journeys j
JOIN user_photos p ON p.user_id = j.user_id
JOIN users u ON u.user_id = j.user_id
WHERE u.email = 'emily@example.com'
AND j.title = 'Da Nang Memories 2024'
AND p.image_url LIKE '%emily_photo1%'
ON CONFLICT DO NOTHING;

INSERT INTO journey_media (journey_id, photo_id, display_order)
SELECT 
    j.journey_id,
    p.photo_id,
    2
FROM user_journeys j
JOIN user_photos p ON p.user_id = j.user_id
JOIN users u ON u.user_id = j.user_id
WHERE u.email = 'emily@example.com'
AND j.title = 'Da Nang Memories 2024'
AND p.image_url LIKE '%emily_photo2%'
ON CONFLICT DO NOTHING;

-- 5. Cài đặt người dùng (User Settings)
INSERT INTO user_settings (user_id, preferred_language, preferred_currency, enable_push_notifications, enable_email_notifications, theme_mode) VALUES
((SELECT user_id FROM users WHERE email = 'emily@example.com'), 'en', 'USD', TRUE, TRUE, 'light'),
((SELECT user_id FROM users WHERE email = 'minh.tran@example.com'), 'vi', 'VND', TRUE, FALSE, 'dark'),
((SELECT user_id FROM users WHERE email = 'anh.nguyen@fellow4u.com'), 'vi', 'VND', TRUE, TRUE, 'system'),
((SELECT user_id FROM users WHERE email = 'jiwon.park@fellow4u.com'), 'kr', 'KRW', TRUE, TRUE, 'light')
ON CONFLICT (user_id) DO UPDATE SET
    preferred_language = EXCLUDED.preferred_language,
    preferred_currency = EXCLUDED.preferred_currency;

-- 6. Nhật ký bảo mật (Security Logs)
-- Ghi log đăng nhập hoặc đổi mật khẩu giả lập
INSERT INTO security_logs (user_id, action_type, ip_address, device_info, created_at) VALUES
((SELECT user_id FROM users WHERE email = 'emily@example.com'), 'LOGIN_ATTEMPT', '192.168.1.100', 'iPhone 14 Pro / iOS 17', CURRENT_TIMESTAMP - INTERVAL '1 hour'),
((SELECT user_id FROM users WHERE email = 'minh.tran@example.com'), 'PASSWORD_CHANGE', '192.168.1.101', 'Samsung Galaxy S23 / Android 14', CURRENT_TIMESTAMP - INTERVAL '24 hours'),
((SELECT user_id FROM users WHERE email = 'anh.nguyen@fellow4u.com'), 'LOGIN_ATTEMPT', '10.0.0.5', 'Windows 11 / Chrome', CURRENT_TIMESTAMP - INTERVAL '30 minutes')
ON CONFLICT DO NOTHING;

-- 7. Reset Sequences
SELECT setval('user_photos_photo_id_seq', (SELECT MAX(photo_id) FROM user_photos));
SELECT setval('user_journeys_journey_id_seq', (SELECT MAX(journey_id) FROM user_journeys));
SELECT setval('security_logs_log_id_seq', (SELECT MAX(log_id) FROM security_logs));