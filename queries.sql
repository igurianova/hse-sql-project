-- Топ популярных тэгов
SELECT t.id, name, count(*) as amount
FROM tags t
         INNER JOIN book2tag b2t on t.id = b2t.tag_id
GROUP BY t.id
ORDER BY amount DESC
LIMIT 10;

-- Статистика регистраций за год
SELECT to_char(reg_time, 'Month') as month,
       count(*)                   as count
FROM users
-- WHERE DATE_PART('year', reg_time) = '2021'
WHERE DATE_PART('year', reg_time) = DATE_PART('year', CURRENT_DATE)
GROUP BY month;

-- Топ популярных жанров
SELECT g.id, g.name, count(b2u.user_id) as buy_count
FROM genres g
         INNER JOIN books b on g.id = b.genre_id
         INNER JOIN book2user b2u on b.id = b2u.book_id
GROUP BY g.id
ORDER BY buy_count DESC
LIMIT 10;

-- Топ популярных книг для автора
SELECT concat_ws(' ', a.last_name, a.first_name) as author,
       b.title,
       b.price,
       b.is_bestseller,
       count(b2u.user_id)                        as buy_count
FROM authors a
         INNER JOIN books b on a.id = b.author_id
         INNER JOIN book2user b2u on b.id = b2u.book_id
WHERE concat_ws(' ', a.first_name, a.last_name) LIKE 'Ursulina Thorsby'
GROUP BY b.id, a.id
ORDER BY buy_count DESC
LIMIT 10;

-- Пользователи собравшие больше вего лайков
SELECT u.name                                    as commentator,
       u.contact,
       concat_ws(' ', a.last_name, a.first_name) as author,
       b.title,
       br.text,
       count(brl.user_id)                        as likes
FROM book_review br
         INNER JOIN book_review_like brl on br.id = brl.review_id
         INNER JOIN users u on br.user_id = u.id
         INNER JOIN books b on b.id = br.book_id
         INNER JOIN authors a on a.id = b.author_id
GROUP BY br.id, u.id, b.id, a.id
ORDER BY likes DESC
LIMIT 10;

-- Найти всех пользователей, которые зарегистрировались за последние 3 месяца
SELECT *
FROM users u
WHERE u.reg_time + interval '3 month' >= CURRENT_DATE;

-- Пользователь, который оставил больше всего отзывов?
SELECT u.id, name, count(br.id) as count
FROM book_review br
         INNER JOIN users u on u.id = br.user_id
GROUP BY u.id
ORDER BY count DESC
LIMIT 1;

-- В какой день января оставили больше всего отзывов?
SELECT DATE_PART('day', br.time) as day, count(br.id) as count
FROM book_review br
WHERE DATE_PART('month', br.time) = '1'
GROUP BY day
ORDER BY count DESC
LIMIT 1;

-- Топ 7 бестселлеров за текущий год?
SELECT b.id,
       b.title,
       b.is_bestseller,
       count(b2u.user_id) as buy_count
FROM books b
         INNER JOIN book2user b2u on b.id = b2u.book_id
WHERE b.is_bestseller = 1
  AND DATE_PART('year', b2u.time) = DATE_PART('year', CURRENT_DATE)
GROUP BY b.id
ORDER BY buy_count DESC
LIMIT 7;

-- Топ 5 пользователей, которые потратили больше всего денег при покупке книг
SELECT u.id, u.name, sum(b.price) as total_amount
FROM book2user b2u
         INNER JOIN users u on u.id = b2u.user_id
         INNER JOIN books b on b.id = b2u.book_id
GROUP BY u.id
ORDER BY total_amount DESC
LIMIT 5;
