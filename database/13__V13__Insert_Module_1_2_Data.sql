-- =============================================================================
-- Dự án: Fellow4U
-- Nội dung: Dữ liệu mẫu (Seed Data) cho Module 1 & Module 2 (Refined & Robust)
-- =============================================================================

-- 1. DỮ LIỆU MODULE 1: AUTHENTICATION
-- -----------------------------------------------------------------------------

-- Thêm quốc gia (Nếu chưa có)
INSERT INTO countries (country_name, country_code, flag_url) VALUES 
('Vietnam', '+84', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Flag_of_Vietnam.svg/960px-Flag_of_Vietnam.svg.png'),
('South Korea', '+82', 'https://upload.wikimedia.org/wikipedia/commons/0/09/Flag_of_South_Korea.svg'),
('Japan', '+81', 'https://upload.wikimedia.org/wikipedia/en/thumb/9/9e/Flag_of_Japan.svg/1280px-Flag_of_Japan.svg.png'),
('USA', '+1', 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Flag_of_the_United_States_%28DDD-F-416E_specifications%29.svg/1280px-Flag_of_the_United_States_%28DDD-F-416E_specifications%29.svg.png')
ON CONFLICT (country_code) DO UPDATE 
SET country_name = EXCLUDED.country_name, flag_url = EXCLUDED.flag_url;

-- Thêm người dùng mẫu
-- Sử dụng ON CONFLICT (email) để không bị lỗi nếu đã tồn tại
INSERT INTO users (role, first_name, last_name, email, password_hash, country_id, avatar_url) VALUES 
('Traveler', 'Emily', 'Watson', 'emily@example.com', '$2a$12$obyHHLqZ1.98KEZjg8ZSZ.Q/W710jX8.dm7UxWL4BmhZhDVdI85li', (SELECT country_id FROM countries WHERE country_code = '+1' LIMIT 1), 'https://i.pravatar.cc/150?u=emily'),
('Guide', 'Anh', 'Nguyen', 'anh.nguyen@fellow4u.com', '$2a$12$obyHHLqZ1.98KEZjg8ZSZ.Q/W710jX8.dm7UxWL4BmhZhDVdI85li', (SELECT country_id FROM countries WHERE country_code = '+84' LIMIT 1), 'https://i.pravatar.cc/150?u=anh'),
('Guide', 'Ji-won', 'Park', 'jiwon.park@fellow4u.com', '$2a$12$obyHHLqZ1.98KEZjg8ZSZ.Q/W710jX8.dm7UxWL4BmhZhDVdI85li', (SELECT country_id FROM countries WHERE country_code = '+82' LIMIT 1), 'https://i.pravatar.cc/150?u=jiwon'),
('Traveler', 'Minh', 'Tran', 'minh.tran@example.com', '$2a$12$obyHHLqZ1.98KEZjg8ZSZ.Q/W710jX8.dm7UxWL4BmhZhDVdI85li', (SELECT country_id FROM countries WHERE country_code = '+84' LIMIT 1), 'https://i.pravatar.cc/150?u=minh')
ON CONFLICT (email) DO NOTHING;

-- Liên kết mạng xã hội
INSERT INTO social_accounts (social_id, user_id, provider) VALUES 
('fb_123456789', (SELECT user_id FROM users WHERE email = 'emily@example.com'), 'FB'),
('kakao_987654321', (SELECT user_id FROM users WHERE email = 'jiwon.park@fellow4u.com'), 'Kakao')
ON CONFLICT DO NOTHING;

-- 2. DỮ LIỆU MODULE 2: EXPLORE & RECOMMENDATIONS
-- -----------------------------------------------------------------------------

-- Địa điểm (Locations)
INSERT INTO locations (country_id, city_name, description, thumbnail_url, is_popular) VALUES 
((SELECT country_id FROM countries WHERE country_code = '+84' LIMIT 1), 'Da Nang', 'Thành phố đáng sống nhất Việt Nam với những bãi biển tuyệt đẹp.', 'https://danangfantasticity.com/wp-content/uploads/2019/01/telegraph-co-uk-tai-sao-ban-nen-ghe-tham-da-nang-viet-nam-nam-2019-nay-012.jpg', TRUE),
((SELECT country_id FROM countries WHERE country_code = '+84' LIMIT 1), 'Ho Chi Minh City', 'Trung tâm kinh tế năng động và giàu văn hóa.', 'https://image.vietnam.travel/sites/default/files/styles/top_banner/public/2022-12/shutterstock_1939037803_0.jpg?itok=ljeHfUg9', TRUE),
((SELECT country_id FROM countries WHERE country_code = '+82' LIMIT 1), 'Seoul', 'Sự pha trộn hoàn hảo giữa cung điện cổ kính và công nghệ hiện đại.', 'https://www.agoda.com/wp-content/uploads/2024/04/Featured-image-Han-River-at-night-in-Seoul-South-Korea.jpg', TRUE),
((SELECT country_id FROM countries WHERE country_code = '+81' LIMIT 1), 'Kyoto', 'Cố đô thanh bình với hàng ngàn ngôi đền rực rỡ.', 'https://duhocvietnhat.edu.vn/wp-content/uploads/Slide3.jpg', FALSE)
ON CONFLICT (city_name) DO NOTHING;

-- Hồ sơ Guide chuyên sâu
INSERT INTO guide_profiles (guide_id, bio, base_location_id, rating_avg, total_reviews, is_verified) VALUES 
((SELECT user_id FROM users WHERE email = 'anh.nguyen@fellow4u.com'), 'Xin chào! Mình là Anh, một người đam mê ẩm thực đường phố Đà Nẵng. Hãy để mình dẫn bạn đi ăn những món "hidden gems" nhé!', (SELECT location_id FROM locations WHERE city_name = 'Da Nang'), 4.9, 120, TRUE),
((SELECT user_id FROM users WHERE email = 'jiwon.park@fellow4u.com'), 'Welcome to Seoul! I specialize in historical palace tours and modern K-Pop culture experiences.', (SELECT location_id FROM locations WHERE city_name = 'Seoul'), 4.8, 85, TRUE)
ON CONFLICT (guide_id) DO NOTHING;

-- Tour dài ngày (Tours)
INSERT INTO tours (title, location_id, price, duration_days, is_featured, thumbnail_url) VALUES 
('Da Nang - Hoi An 3 Days Adventure', (SELECT location_id FROM locations WHERE city_name = 'Da Nang'), 150.00, 3, TRUE, 'https://danangfantasticity.com/wp-content/uploads/2019/01/telegraph-co-uk-tai-sao-ban-nen-ghe-tham-da-nang-viet-nam-nam-2019-nay-012.jpg'),
('Explore Seoul Like a Local', (SELECT location_id FROM locations WHERE city_name = 'Seoul'), 299.00, 5, TRUE, 'https://www.agoda.com/wp-content/uploads/2024/04/Featured-image-Han-River-at-night-in-Seoul-South-Korea.jpg'),
('Street Food Paradise in Saigon', (SELECT location_id FROM locations WHERE city_name = 'Ho Chi Minh City'), 80.00, 1, FALSE, 'https://image.vietnam.travel/sites/default/files/styles/top_banner/public/2022-12/shutterstock_1939037803_0.jpg?itok=ljeHfUg9')
ON CONFLICT (title) DO NOTHING;

-- Trải nghiệm ngắn hạn (Experiences)
INSERT INTO experiences (guide_id, title, location_id, price, duration_hours, thumbnail_url) VALUES 
((SELECT user_id FROM users WHERE email = 'anh.nguyen@fellow4u.com'), 'Morning Coffee & Dragon Bridge Walk', (SELECT location_id FROM locations WHERE city_name = 'Da Nang'), 15.00, 2.5, 'https://d2e5ushqwiltxm.cloudfront.net/wp-content/uploads/sites/86/2020/02/18084249/daragon-bridge-on-an-opening-day-c%E1%BA%A7u-r%E1%BB%93ng-%C4%91%C3%A0-n%E1%BA%B5ng-Danang-Discovery-4-famous-bridge-in-danang-Restaurant-near-me-dragon-bridge-history-a-new-iconic-image-of-danang.jpg'),
((SELECT user_id FROM users WHERE email = 'jiwon.park@fellow4u.com'), 'Han River Night Picnic with Chimaek', (SELECT location_id FROM locations WHERE city_name = 'Seoul'), 35.00, 3.0, 'https://static.wixstatic.com/media/0505b9_a4f9859e88774a7a84071de78b228270~mv2.jpg/v1/fill/w_640,h_496,al_c,q_80,usm_0.66_1.00_0.01,enc_avif,quality_auto/0505b9_a4f9859e88774a7a84071de78b228270~mv2.jpg')
ON CONFLICT (title) DO NOTHING;

-- Tin tức du lịch (Travel News)
INSERT INTO travel_news (title, content, metadata, image_url) VALUES 
('Top 10 Coffee Shops in Da Nang', 'Da Nang is famous for its unique coffee culture...', '{"tags": ["coffee", "lifestyle"], "author": "Fellow4U Team"}', 'https://hoangphuan.com/wp-content/uploads/2024/06/tour-du-lich-da-nang-1.jpg'),
('Moving to Seoul: A Travel Guide', 'Everything you need to know before visiting South Korea...', '{"tags": ["korea", "guide"], "author": "Ji-won"}', 'https://letseoul.com/_next/image?url=%2Fimages%2Fhero-seoul-night.jpg&w=3840&q=75')
ON CONFLICT (title) DO NOTHING;

-- Cập nhật chuỗi Serial (Để không bị lỗi ID khi Insert bằng tay tiếp theo)
SELECT setval('countries_country_id_seq', (SELECT MAX(country_id) FROM countries), true) WHERE (SELECT MAX(country_id) FROM countries) IS NOT NULL;
SELECT setval('users_user_id_seq', (SELECT MAX(user_id) FROM users), true) WHERE (SELECT MAX(user_id) FROM users) IS NOT NULL;
SELECT setval('locations_location_id_seq', (SELECT MAX(location_id) FROM locations), true) WHERE (SELECT MAX(location_id) FROM locations) IS NOT NULL;
SELECT setval('tours_tour_id_seq', (SELECT MAX(tour_id) FROM tours), true) WHERE (SELECT MAX(tour_id) FROM tours) IS NOT NULL;
SELECT setval('experiences_exp_id_seq', (SELECT MAX(exp_id) FROM experiences), true) WHERE (SELECT MAX(exp_id) FROM experiences) IS NOT NULL;
SELECT setval('travel_news_news_id_seq', (SELECT MAX(news_id) FROM travel_news), true) WHERE (SELECT MAX(news_id) FROM travel_news) IS NOT NULL;