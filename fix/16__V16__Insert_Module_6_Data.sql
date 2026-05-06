-- =============================================================================
-- Dự án: Fellow4U
-- Nội dung: Gộp dữ liệu mẫu (Seed Data) cho Module 6 - Categories & More
-- =============================================================================

-- 1. KHỞI TẠO BANNER CHO TRANG DANH MỤC (App_Banners)
-- -----------------------------------------------------------------------------
INSERT INTO app_banners (page_type, title_text, subtitle_text, image_url, is_active) VALUES 
('Guides_More', 'Private Local Guides', 'Find the perfect companion for your journey', 'https://www.agoda.com/wp-content/uploads/2019/05/Gyeongbokgung-palace-Seoul-architecture-view.jpg', TRUE),
('Tours_More', 'Discovery Tours', 'Authentic experiences curated by locals', 'https://ohdidi.vn/uploads/static/NEWS/blog/du%20lich%20da%20nang%20hoi%20an/du_lich_da_nang_hoi_an_2.png', TRUE)
ON CONFLICT DO NOTHING;


-- 2. KHỞI TẠO CÁC BỘ SƯU TẬP (Collections)
-- -----------------------------------------------------------------------------
-- Gộp tất cả các bộ sưu tập từ cả 2 nguồn
INSERT INTO collections (name, slug, description, item_type, is_public) VALUES 
('Best Guides in Da Nang', 'best-guides', 'Discover the most experienced and high-rated local guides in your destination.', 'guide', TRUE),
('Featured Tours 2026', 'featured-tours', 'Explore our hand-picked selection of the most amazing journeys across the country.', 'tour', TRUE),
('Top Rated Guides', 'top-rated-guides', 'Our most loved local experts based on traveler reviews.', 'guide', TRUE),
('Culture Experts', 'culture-experts', 'Guides who specialize in history, art, and local traditions.', 'guide', TRUE),
('Best Beach Tours', 'best-beach-tours', 'Explore the most beautiful coastlines in Vietnam and beyond.', 'tour', TRUE),
('Hidden Gems', 'hidden-gems', 'Uncover secrets that typical tourists never see.', 'tour', TRUE)
ON CONFLICT (slug) DO UPDATE SET 
    name = EXCLUDED.name, 
    description = EXCLUDED.description;


-- 3. GẮN GUIDE VÀO BỘ SƯU TẬP (Collection_Guides)
-- -----------------------------------------------------------------------------
INSERT INTO collection_guides (collection_id, guide_id, sort_order) VALUES 
-- Mappings cho 'best-guides'
((SELECT collection_id FROM collections WHERE slug = 'best-guides'), (SELECT user_id FROM users WHERE email = 'anh.nguyen@fellow4u.com'), 1),
((SELECT collection_id FROM collections WHERE slug = 'best-guides'), (SELECT user_id FROM users WHERE email = 'jiwon.park@fellow4u.com'), 2),
-- Mappings cho 'top-rated-guides'
((SELECT collection_id FROM collections WHERE slug = 'top-rated-guides'), (SELECT user_id FROM users WHERE email = 'anh.nguyen@fellow4u.com'), 1),
((SELECT collection_id FROM collections WHERE slug = 'top-rated-guides'), (SELECT user_id FROM users WHERE email = 'jiwon.park@fellow4u.com'), 2),
-- Mappings cho 'culture-experts'
((SELECT collection_id FROM collections WHERE slug = 'culture-experts'), (SELECT user_id FROM users WHERE email = 'jiwon.park@fellow4u.com'), 1)
ON CONFLICT DO NOTHING;


-- 4. GẮN TOUR VÀO BỘ SƯU TẬP (Collection_Tours)
-- -----------------------------------------------------------------------------
INSERT INTO collection_tours (collection_id, tour_id, sort_order) VALUES 
-- Mappings cho 'featured-tours' (Sử dụng subquery để đảm bảo lấy đúng ID)
((SELECT collection_id FROM collections WHERE slug = 'featured-tours'), (SELECT tour_id FROM tours WHERE title = 'Da Nang - Hoi An 3 Days Adventure'), 1),
((SELECT collection_id FROM collections WHERE slug = 'featured-tours'), (SELECT tour_id FROM tours WHERE title = 'Explore Seoul Like a Local'), 2),
-- Mappings cho 'best-beach-tours'
((SELECT collection_id FROM collections WHERE slug = 'best-beach-tours'), (SELECT tour_id FROM tours WHERE title = 'Da Nang - Hoi An 3 Days Adventure'), 1),
-- Mappings cho 'hidden-gems'
((SELECT collection_id FROM collections WHERE slug = 'hidden-gems'), (SELECT tour_id FROM tours WHERE title = 'Explore Seoul Like a Local'), 1),
((SELECT collection_id FROM collections WHERE slug = 'hidden-gems'), (SELECT tour_id FROM tours WHERE title = 'Street Food Paradise in Saigon'), 2)
ON CONFLICT DO NOTHING;


-- 5. CẬP NHẬT SEQUENCE (Để tránh lỗi ID cho các thao tác INSERT tiếp theo)
-- -----------------------------------------------------------------------------
SELECT setval('app_banners_banner_id_seq', (SELECT MAX(banner_id) FROM app_banners), true) WHERE (SELECT MAX(banner_id) FROM app_banners) IS NOT NULL;
SELECT setval('collections_collection_id_seq', (SELECT MAX(collection_id) FROM collections), true) WHERE (SELECT MAX(collection_id) FROM collections) IS NOT NULL;