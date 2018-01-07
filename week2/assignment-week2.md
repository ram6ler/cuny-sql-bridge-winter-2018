# Assignment 2

## Problem 1

> **Videos table.** Create one table to keep track of the videos. This table should include a unique ID, the title of the video, the length in minutes, and the URL. Populate the table with at least three related videos from YouTube or other publicly available resources.

I arbitrarily chose a set of video tutorials posted on YouTube by user *Simon Sez IT*.

```sql
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
```

The *videos* table now looks like:

|video_id|title|length|url|
|:--:|:--|:--|:--|
|1|Part 1 - Introduction to MySQL and Database|10|[https://www.youtube.com/watch?v=JcRvy-4rf1Y&list=PLzj7TwUeMQ3ga_sHmm6-CmJjgwCAeTKgA](https://www.youtube.com/watch?v=JcRvy-4rf1Y&list=PLzj7TwUeMQ3ga_sHmm6-CmJjgwCAeTKgA)|
|2|Part 2 - MySQL Architecture and Installation of MySQL|16|[https://www.youtube.com/watch?v=YpHxFnRONC8&list=PLzj7TwUeMQ3ga_sHmm6-CmJjgwCAeTKgA&index=2](https://www.youtube.com/watch?v=YpHxFnRONC8&list=PLzj7TwUeMQ3ga_sHmm6-CmJjgwCAeTKgA&index=2)|
|3|Part 3 - Installation Demo - Part 1|4|[https://www.youtube.com/watch?v=MExiTXmIl7w&list=PLzj7TwUeMQ3ga_sHmm6-CmJjgwCAeTKgA&index=3](https://www.youtube.com/watch?v=MExiTXmIl7w&list=PLzj7TwUeMQ3ga_sHmm6-CmJjgwCAeTKgA&index=3)|
|4|Part 4 - Installation Demo - Part 2|10|[https://www.youtube.com/watch?v=ByhUq1M-E1w&list=PLzj7TwUeMQ3ga_sHmm6-CmJjgwCAeTKgA&index=4](https://www.youtube.com/watch?v=ByhUq1M-E1w&list=PLzj7TwUeMQ3ga_sHmm6-CmJjgwCAeTKgA&index=4)|
|5|Part 5 - Database Design|9|[https://www.youtube.com/watch?v=xMFCAMa_4UE&list=PLzj7TwUeMQ3ga_sHmm6-CmJjgwCAeTKgA&index=5](https://www.youtube.com/watch?v=xMFCAMa_4UE&list=PLzj7TwUeMQ3ga_sHmm6-CmJjgwCAeTKgA&index=5)|

## Problem 2

> **Create and populate Reviewers table.** Create a second table that provides at least two user reviews for each of at least two of the videos. These should be imaginary reviews that include columns for the user’s name (“Asher”, “Cyd”, etc.), the rating (which could be NULL, or a number between 0 and 5), and a short text review (“Loved it!”). There should be a column that links back to the ID column in the table of videos.

### Creating the table

The following query creates a table called *reviewers* that is related to *videos* via the *video_id* foreign key.

```sql
DROP TABLE IF EXISTS reviewers;
CREATE TABLE reviewers (
  review_id INT UNSIGNED PRIMARY KEY,
  video_id INT UNSIGNED,
  name TEXT,
  rating INT UNSIGNED,
  review TEXT
);
```

### Adding imaginary data

I wrote a [Dart script](random-reviews.dart) that generated SQL code to add 50 arbitrary, randomly generated dummy-review entries to the table. An excerpt form a sample output of the script is:

```sql
-- Output of script random-reviews.dart. ----------
INSERT INTO reviewers
  (review_id, video_id, name, rating, review)
VALUES
(1, 1, 'Bob', 4, 'An amazing tutorial that makes me want to weep with anger.'),
(2, 1, 'Bob', 4, 'An amazing tutorial that makes me want to throw up with happiness.'),
(3, 1, 'Jane', 5, 'A mediocre tutorial that makes me want to weep with exhilharation.'),
(4, 1, 'Jane', 1, 'A wonderful tutorial that makes me want to turn religious with sadness.'),
(5, 1, 'Vivian', 2, 'A spellbinding tutorial that makes me want to dance with exhilharation.'),

...

(46, 3, 'Sue', 1, 'A wonderful tutorial that makes me want to weep with happiness.'),
(47, 3, 'Bob', 4, 'A terrible tutorial that makes me want to weep with exasperation.'),
(48, 1, 'Sue', 1, 'A terrible tutorial that makes me want to giggle with exasperation.'),
(49, 5, 'Bob', 2, 'A mediocre tutorial that makes me want to throw up with exasperation.'),
(50, 3, 'Bob', 5, 'A terrible tutorial that makes me want to giggle with exhilharation.');
-- End of script's output. -------------------------
```

After executing the generated script above, the table *reviewers* has 50 rows, the first and last five being:

|review_id|video_id|name|rating|review|
|:--:|:--:|:--|:--|:--|
|1|1|Bob|4|An amazing tutorial that makes me want to weep with anger.|
|2|1|Bob|4|An amazing tutorial that makes me want to throw up with happiness.|
|3|1|Jane|5|A mediocre tutorial that makes me want to weep with exhilharation.|
|4|1|Jane|1|A wonderful tutorial that makes me want to turn religious with sadness.|
|5|1|Vivian|2|A spellbinding tutorial that makes me want to dance with exhilharation.|
|...|...|...|...|...|
|46|3|Sue|1|A wonderful tutorial that makes me want to weep with happiness.|
|47|3|Bob|4|A terrible tutorial that makes me want to weep with exasperation.|
|48|1|Sue|1|A terrible tutorial that makes me want to giggle with exasperation.|
|49|5|Bob|2|A mediocre tutorial that makes me want to throw up with exasperation.|
|50|3|Bob|5|A terrible tutorial that makes me want to giggle with exhilharation.|

## Problem 3

> **Report on Video Reviews.** Write a JOIN statement that shows information from both tables.

For this problem I chose to aggregate the folowing data for each of the tutorials:

* The number of reviews.
* The mean rating.
* The number of reviews that contained the word *wonderful*.

I did this via the following query:

```sql
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
```

Which output:

|title|reviews|mean_rating|wonderful|
|:--|:--|:--|:--|
|Part 1 - Introduction to MySQL and Database|15|3.2000|5|
|Part 2 - MySQL Architecture and Installation of MySQL|6|2.1667|1|
|Part 3 - Installation Demo - Part 1|10|3.1000|4|
|Part 4 - Installation Demo - Part 2|12|3.5833|5|
|Part 5 - Database Design|7|3.1429|1|

