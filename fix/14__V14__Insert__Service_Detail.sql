-- =============================================================================
-- Dự án: Fellow4U
-- Nội dung: Dữ liệu mẫu (Seed Data) cho Module 3 - Service & Destination Detail
-- =============================================================================

-- 1. CẬP NHẬT NGÔN NGỮ CHO GUIDE (Guide_Languages)
-- -----------------------------------------------------------------------------
-- Anh Nguyễn: Tiếng Việt, Tiếng Anh
INSERT INTO guide_languages (guide_id, lang_id) VALUES 
((SELECT user_id FROM users WHERE email = 'anh.nguyen@fellow4u.com'), (SELECT lang_id FROM languages WHERE lang_code = 'vi')),
((SELECT user_id FROM users WHERE email = 'anh.nguyen@fellow4u.com'), (SELECT lang_id FROM languages WHERE lang_code = 'en'))
ON CONFLICT DO NOTHING;

-- Ji-won Park: Tiếng Hàn, Tiếng Anh, Tiếng Nhật
INSERT INTO guide_languages (guide_id, lang_id) VALUES 
((SELECT user_id FROM users WHERE email = 'jiwon.park@fellow4u.com'), (SELECT lang_id FROM languages WHERE lang_code = 'kr')),
((SELECT user_id FROM users WHERE email = 'jiwon.park@fellow4u.com'), (SELECT lang_id FROM languages WHERE lang_code = 'en')),
((SELECT user_id FROM users WHERE email = 'jiwon.park@fellow4u.com'), (SELECT lang_id FROM languages WHERE lang_code = 'jp'))
ON CONFLICT DO NOTHING;


-- 2. BẢNG GIÁ PHÂN TẦNG (Guide_Pricing)
-- -----------------------------------------------------------------------------
-- Anh Nguyễn (Đà Nẵng)
INSERT INTO guide_pricing (guide_id, min_travelers, max_travelers, price_per_hour) VALUES 
((SELECT user_id FROM users WHERE email = 'anh.nguyen@fellow4u.com'), 1, 2, 10.00),
((SELECT user_id FROM users WHERE email = 'anh.nguyen@fellow4u.com'), 3, 5, 15.00),
((SELECT user_id FROM users WHERE email = 'anh.nguyen@fellow4u.com'), 6, 10, 25.00)
ON CONFLICT DO NOTHING;

-- Ji-won Park (Seoul)
INSERT INTO guide_pricing (guide_id, min_travelers, max_travelers, price_per_hour) VALUES 
((SELECT user_id FROM users WHERE email = 'jiwon.park@fellow4u.com'), 1, 3, 20.00),
((SELECT user_id FROM users WHERE email = 'jiwon.park@fellow4u.com'), 4, 6, 35.00)
ON CONFLICT DO NOTHING;


-- 3. ĐỊA ĐIỂM THAM QUAN CHI TIẾT (Attractions)
-- -----------------------------------------------------------------------------
-- Đà Nẵng Attractions
INSERT INTO attractions (location_id, name, address, description, image_url) VALUES 
((SELECT location_id FROM locations WHERE city_name = 'Da Nang'), 'Cầu Rồng (Dragon Bridge)', 'An Hải Tây, Sơn Trà, Đà Nẵng', 'Biểu tượng của sự thịnh vượng, phun lửa và nước vào cuối tuần.', 'https://images2.thanhnien.vn/528068263637045248/2025/6/18/the-legend-danang-1-17502421275011965589401.jpg'),
((SELECT location_id FROM locations WHERE city_name = 'Da Nang'), 'Ngũ Hành Sơn (Marble Mountains)', 'Hòa Hải, Ngũ Hành Sơn, Đà Nẵng', 'Quần thể 5 ngọn núi đá vôi với các hang động và chùa chiền cổ kính.', 'https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/08/Nui-Ngu-Hanh-Son.png'),
((SELECT location_id FROM locations WHERE city_name = 'Da Nang'), 'Cộng Cà Phê', '98-96 Bạch Đằng, Đà Nẵng', 'Quán cà phê phong cách bao cấp nổi tiếng, view sông Hàn.', 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/10/b2/1f/5a/come-at-night-with-less.jpg?w=900&h=500&s=1')
ON CONFLICT DO NOTHING;

-- Seoul Attractions
INSERT INTO attractions (location_id, name, address, description, image_url) VALUES 
((SELECT location_id FROM locations WHERE city_name = 'Seoul'), 'Gyeongbokgung Palace', '161 Sajik-ro, Jongno-gu, Seoul', 'Cung điện lớn nhất và quan trọng nhất của triều đại Joseon.', 'https://www.agoda.com/wp-content/uploads/2019/05/Gyeongbokgung-palace-Seoul-architecture-view.jpg'),
((SELECT location_id FROM locations WHERE city_name = 'Seoul'), 'Bukchon Hanok Village', 'Jongno-gu, Seoul', 'Làng cổ lưu giữ hàng trăm ngôi nhà truyền thống Hàn Quốc.', 'https://vj-prod-website-cms.s3.ap-southeast-1.amazonaws.com/t1-1715750175103.jpg')
ON CONFLICT DO NOTHING;


-- 4. HỆ THỐNG ĐÁNH GIÁ (Reviews)
-- -----------------------------------------------------------------------------
INSERT INTO reviews (guide_id, author_id, rating, comment) VALUES 
((SELECT user_id FROM users WHERE email = 'anh.nguyen@fellow4u.com'), (SELECT user_id FROM users WHERE email = 'emily@example.com'), 5, 'Anh is the best! She showed us places we could never find on Google Maps. The food was amazing!'),
((SELECT user_id FROM users WHERE email = 'anh.nguyen@fellow4u.com'), (SELECT user_id FROM users WHERE email = 'minh.tran@example.com'), 4, 'Rất nhiệt tình, am hiểu lịch sử địa phương. Highly recommend!'),
((SELECT user_id FROM users WHERE email = 'jiwon.park@fellow4u.com'), (SELECT user_id FROM users WHERE email = 'emily@example.com'), 5, 'Perfect palace tour. Her English is excellent and she knows all the best photo spots.')
ON CONFLICT DO NOTHING;


-- 5. KHO TƯ LIỆU GUIDE (Portfolio Media)
-- -----------------------------------------------------------------------------
INSERT INTO guide_portfolio_media (guide_id, media_url, media_type, title, display_order) VALUES 
((SELECT user_id FROM users WHERE email = 'anh.nguyen@fellow4u.com'), 'https://thanhnien.mediacdn.vn/Uploaded/ngocthanh/2016_03_23/9x01_YGEO.jpg?width=500', 'image', 'Street Food Tour with US guests', 1),
((SELECT user_id FROM users WHERE email = 'anh.nguyen@fellow4u.com'), 'https://cdn.fellow4u.com/portfolio/anh_video_intro.mp4', 'video', 'Introduction to Da Nang', 2),
((SELECT user_id FROM users WHERE email = 'jiwon.park@fellow4u.com'), 'https://www.paratime.vn/wp-content/uploads/2019/09/timestudio.vn-headshot-eye-glasses-02.jpg', 'image', 'Traditional Hanbok Experience', 1)
ON CONFLICT DO NOTHING;


-- 6. CẬP NHẬT SEQUENCE (Tránh lỗi ID khi insert bằng tay sau này)
-- -----------------------------------------------------------------------------
SELECT setval('guide_pricing_price_id_seq', (SELECT MAX(price_id) FROM guide_pricing), true) WHERE (SELECT MAX(price_id) FROM guide_pricing) IS NOT NULL;
SELECT setval('reviews_review_id_seq', (SELECT MAX(review_id) FROM reviews), true) WHERE (SELECT MAX(review_id) FROM reviews) IS NOT NULL;
SELECT setval('attractions_attraction_id_seq', (SELECT MAX(attraction_id) FROM attractions), true) WHERE (SELECT MAX(attraction_id) FROM attractions) IS NOT NULL;
SELECT setval('guide_portfolio_media_media_id_seq', (SELECT MAX(media_id) FROM guide_portfolio_media), true) WHERE (SELECT MAX(media_id) FROM guide_portfolio_media) IS NOT NULL;