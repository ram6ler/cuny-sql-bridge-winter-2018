DROP SCHEMA IF EXISTS week2_assignment;
CREATE SCHEMA week2_assignment;
USE week2_assignment;

-- Problem 1
DROP TABLE IF EXISTS videos;
CREATE TABLE videos (
    video_id INT UNSIGNED PRIMARY KEY,
    title TEXT NOT NULL,
    length INT UNSIGNED,
    url TEXT NOT NULL
);

-- Videos uploaded by YouTube user Simon Sez IT arbitrarily chosen.
INSERT INTO videos
(video_id, title, length, url)
VALUES
(
  1,
  'Part 1 - Introduction to MySQL and Database', 
  10, 
  'https://www.youtube.com/watch?v=JcRvy-4rf1Y&list=PLzj7TwUeMQ3ga_sHmm6-CmJjgwCAeTKgA'
),
(
  2,
  'Part 2 - MySQL Architecture and Installation of MySQL', 
  16, 
  'https://www.youtube.com/watch?v=YpHxFnRONC8&list=PLzj7TwUeMQ3ga_sHmm6-CmJjgwCAeTKgA&index=2'
),
(
  3,
  'Part 3 - Installation Demo - Part 1', 
  4, 
  'https://www.youtube.com/watch?v=MExiTXmIl7w&list=PLzj7TwUeMQ3ga_sHmm6-CmJjgwCAeTKgA&index=3'
),
(
  4,
  'Part 4 - Installation Demo - Part 2', 
  10, 
  'https://www.youtube.com/watch?v=ByhUq1M-E1w&list=PLzj7TwUeMQ3ga_sHmm6-CmJjgwCAeTKgA&index=4'
),
(
  5,
  'Part 5 - Database Design', 
  9, 
  'https://www.youtube.com/watch?v=xMFCAMa_4UE&list=PLzj7TwUeMQ3ga_sHmm6-CmJjgwCAeTKgA&index=5'
);

-- Problem 2
DROP TABLE IF EXISTS reviewers;
CREATE TABLE reviewers (
  review_id INT UNSIGNED PRIMARY KEY,
  video_id INT UNSIGNED,
  name TEXT,
  rating INT UNSIGNED,
  review TEXT
);

-- Output of script random-reviews.dart. ----------
INSERT INTO reviewers
  (review_id, video_id, name, rating, review)
VALUES
(1, 1, 'Bob', 4, 'An amazing tutorial that makes me want to weep with anger.'),
(2, 1, 'Bob', 4, 'An amazing tutorial that makes me want to throw up with happiness.'),
(3, 1, 'Jane', 5, 'A mediocre tutorial that makes me want to weep with exhilharation.'),
(4, 1, 'Jane', 1, 'A wonderful tutorial that makes me want to turn religious with sadness.'),
(5, 1, 'Vivian', 2, 'A spellbinding tutorial that makes me want to dance with exhilharation.'),
(6, 4, 'Jane', 4, 'A wonderful tutorial that makes me want to dance with happiness.'),
(7, 2, 'Jane', 3, 'A terrible tutorial that makes me want to dance with exasperation.'),
(8, 4, 'Sue', 5, 'A wonderful tutorial that makes me want to giggle with exasperation.'),
(9, 2, 'Bob', 4, 'A mediocre tutorial that makes me want to weep with exasperation.'),
(10, 1, 'Bob', 5, 'A wonderful tutorial that makes me want to dance with anger.'),
(11, 3, 'Bob', 5, 'A terrible tutorial that makes me want to weep with exhilharation.'),
(12, 2, 'Jane', 1, 'A mediocre tutorial that makes me want to weep with anger.'),
(13, 3, 'Bob', 4, 'A terrible tutorial that makes me want to throw up with anger.'),
(14, 4, 'Sue', 3, 'A mediocre tutorial that makes me want to turn religious with exasperation.'),
(15, 4, 'Jack', 5, 'A wonderful tutorial that makes me want to giggle with sadness.'),
(16, 1, 'Sue', 3, 'A wonderful tutorial that makes me want to weep with exhilharation.'),
(17, 1, 'Bob', 2, 'A wonderful tutorial that makes me want to turn religious with exhilharation.'),
(18, 4, 'Jack', 5, 'An amazing tutorial that makes me want to throw up with exhilharation.'),
(19, 5, 'Jane', 4, 'A terrible tutorial that makes me want to dance with exasperation.'),
(20, 1, 'Bob', 3, 'A spellbinding tutorial that makes me want to turn religious with exhilharation.'),
(21, 4, 'Vivian', 5, 'A wonderful tutorial that makes me want to giggle with anger.'),
(22, 4, 'Vivian', 4, 'A mediocre tutorial that makes me want to dance with sadness.'),
(23, 5, 'Vivian', 5, 'A terrible tutorial that makes me want to throw up with exasperation.'),
(24, 2, 'Bob', 3, 'A mediocre tutorial that makes me want to giggle with anger.'),
(25, 4, 'Bob', 5, 'An amazing tutorial that makes me want to weep with exhilharation.'),
(26, 3, 'Jane', 1, 'A wonderful tutorial that makes me want to giggle with exhilharation.'),
(27, 4, 'Jack', 4, 'A wonderful tutorial that makes me want to weep with exasperation.'),
(28, 2, 'Bob', 1, 'A wonderful tutorial that makes me want to turn religious with happiness.'),
(29, 3, 'Vivian', 3, 'A terrible tutorial that makes me want to giggle with happiness.'),
(30, 1, 'Jane', 3, 'A spellbinding tutorial that makes me want to weep with exhilharation.'),
(31, 4, 'Vivian', 1, 'A spellbinding tutorial that makes me want to dance with happiness.'),
(32, 2, 'Vivian', 1, 'A spellbinding tutorial that makes me want to weep with exasperation.'),
(33, 5, 'Jane', 3, 'An amazing tutorial that makes me want to dance with happiness.'),
(34, 1, 'Sue', 5, 'A terrible tutorial that makes me want to turn religious with happiness.'),
(35, 5, 'Jane', 2, 'A mediocre tutorial that makes me want to throw up with happiness.'),
(36, 1, 'Vivian', 3, 'A terrible tutorial that makes me want to turn religious with happiness.'),
(37, 4, 'Sue', 1, 'A mediocre tutorial that makes me want to giggle with sadness.'),
(38, 3, 'Bob', 1, 'A spellbinding tutorial that makes me want to throw up with exasperation.'),
(39, 5, 'Sue', 4, 'A wonderful tutorial that makes me want to weep with sadness.'),
(40, 1, 'Vivian', 5, 'A wonderful tutorial that makes me want to dance with exasperation.'),
(41, 4, 'Vivian', 1, 'A mediocre tutorial that makes me want to turn religious with exhilharation.'),
(42, 5, 'Sue', 2, 'A spellbinding tutorial that makes me want to giggle with anger.'),
(43, 3, 'Jane', 4, 'A wonderful tutorial that makes me want to weep with anger.'),
(44, 1, 'Vivian', 2, 'A spellbinding tutorial that makes me want to turn religious with exhilharation.'),
(45, 3, 'Sue', 3, 'A wonderful tutorial that makes me want to weep with sadness.'),
(46, 3, 'Sue', 1, 'A wonderful tutorial that makes me want to weep with happiness.'),
(47, 3, 'Bob', 4, 'A terrible tutorial that makes me want to weep with exasperation.'),
(48, 1, 'Sue', 1, 'A terrible tutorial that makes me want to giggle with exasperation.'),
(49, 5, 'Bob', 2, 'A mediocre tutorial that makes me want to throw up with exasperation.'),
(50, 3, 'Bob', 5, 'A terrible tutorial that makes me want to giggle with exhilharation.');
-- End of script's output. -------------------------

-- Problem 3
-- Number of reviews, mean score and number of reviews that contained
-- the word wonderful for each video.
SELECT 
    videos.title,
    COUNT(*) AS 'reviews',
    AVG(reviewers.rating) AS 'mean_rating',
    SUM(
      CASE
        WHEN reviewers.review LIKE('%wonderful%') THEN 1
        ELSE 0
	  END
    ) AS wonderful
FROM
    videos
        LEFT JOIN
    reviewers ON videos.video_id = reviewers.video_id
GROUP BY videos.video_id;
