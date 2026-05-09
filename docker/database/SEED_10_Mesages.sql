-- =============================================================================
-- SEED 10: Messaging System (Module 10)
-- Mô tả: Phòng chat (Chat Rooms), Tin nhắn (Messages), và Trạng thái đọc
-- =============================================================================

-- 1. Tạo phòng chat (Chat Rooms) dựa trên các Booking đã tồn tại
-- Room 1: Emily <-> Anh Nguyen (Cho tour Da Nang)
INSERT INTO chat_rooms (booking_id, participant_one_id, participant_two_id, last_message_preview, last_message_at)
SELECT 
    b.booking_id,
    LEAST(b.traveler_id, b.guide_id), -- Đảm bảo thứ tự ID nhất quán
    GREATEST(b.traveler_id, b.guide_id),
    'See you at the airport!',
    CURRENT_TIMESTAMP - INTERVAL '1 hour'
FROM bookings b
JOIN users u_traveler ON b.traveler_id = u_traveler.user_id
JOIN users u_guide ON b.guide_id = u_guide.user_id
WHERE u_traveler.email = 'emily@example.com' 
AND u_guide.email = 'anh.nguyen@fellow4u.com'
ON CONFLICT (booking_id) DO NOTHING;

-- Room 2: Minh Tran <-> Ji-won Park (Cho tour Seoul)
INSERT INTO chat_rooms (booking_id, participant_one_id, participant_two_id, last_message_preview, last_message_at)
SELECT 
    b.booking_id,
    LEAST(b.traveler_id, b.guide_id),
    GREATEST(b.traveler_id, b.guide_id),
    'Can we change the meeting point?',
    CURRENT_TIMESTAMP - INTERVAL '30 minutes'
FROM bookings b
JOIN users u_traveler ON b.traveler_id = u_traveler.user_id
JOIN users u_guide ON b.guide_id = u_guide.user_id
WHERE u_traveler.email = 'minh.tran@example.com' 
AND u_guide.email = 'jiwon.park@fellow4u.com'
ON CONFLICT (booking_id) DO NOTHING;

-- 2. Thêm tin nhắn mẫu (Messages)
-- Lấy ID phòng chat vừa tạo để insert tin nhắn

-- Tin nhắn cho Room 1 (Emily & Anh)
INSERT INTO messages (room_id, sender_id, content, message_type, is_read, created_at)
SELECT 
    cr.room_id,
    u_guide.user_id, -- Guide gửi trước
    'Hello Emily! I will be waiting for you at Terminal 1 with a sign.',
    'text',
    TRUE,
    CURRENT_TIMESTAMP - INTERVAL '2 hours'
FROM chat_rooms cr
JOIN bookings b ON cr.booking_id = b.booking_id
JOIN users u_guide ON b.guide_id = u_guide.user_id
JOIN users u_traveler ON b.traveler_id = u_traveler.user_id
WHERE u_traveler.email = 'emily@example.com' AND u_guide.email = 'anh.nguyen@fellow4u.com'
ON CONFLICT DO NOTHING;

INSERT INTO messages (room_id, sender_id, content, message_type, is_read, created_at)
SELECT 
    cr.room_id,
    u_traveler.user_id, -- Traveler trả lời
    'Great! See you at the airport!',
    'text',
    FALSE, -- Chưa đọc để test badge thông báo
    CURRENT_TIMESTAMP - INTERVAL '1 hour'
FROM chat_rooms cr
JOIN bookings b ON cr.booking_id = b.booking_id
JOIN users u_guide ON b.guide_id = u_guide.user_id
JOIN users u_traveler ON b.traveler_id = u_traveler.user_id
WHERE u_traveler.email = 'emily@example.com' AND u_guide.email = 'anh.nguyen@fellow4u.com'
ON CONFLICT DO NOTHING;

-- Tin nhắn cho Room 2 (Minh & Ji-won)
INSERT INTO messages (room_id, sender_id, content, message_type, is_read, created_at)
SELECT 
    cr.room_id,
    u_traveler.user_id,
    'Hi Ji-won, can we change the meeting point to Myeongdong Station instead?',
    'text',
    TRUE,
    CURRENT_TIMESTAMP - INTERVAL '45 minutes'
FROM chat_rooms cr
JOIN bookings b ON cr.booking_id = b.booking_id
JOIN users u_guide ON b.guide_id = u_guide.user_id
JOIN users u_traveler ON b.traveler_id = u_traveler.user_id
WHERE u_traveler.email = 'minh.tran@example.com' AND u_guide.email = 'jiwon.park@fellow4u.com'
ON CONFLICT DO NOTHING;

INSERT INTO messages (room_id, sender_id, content, message_type, is_read, created_at)
SELECT 
    cr.room_id,
    u_guide.user_id,
    'Sure, that works for me. See you there!',
    'text',
    FALSE,
    CURRENT_TIMESTAMP - INTERVAL '30 minutes'
FROM chat_rooms cr
JOIN bookings b ON cr.booking_id = b.booking_id
JOIN users u_guide ON b.guide_id = u_guide.user_id
JOIN users u_traveler ON b.traveler_id = u_traveler.user_id
WHERE u_traveler.email = 'minh.tran@example.com' AND u_guide.email = 'jiwon.park@fellow4u.com'
ON CONFLICT DO NOTHING;

-- 3. Reset Sequences
SELECT setval('chat_rooms_room_id_seq', (SELECT MAX(room_id) FROM chat_rooms));
SELECT setval('messages_message_id_seq', (SELECT MAX(message_id) FROM messages));