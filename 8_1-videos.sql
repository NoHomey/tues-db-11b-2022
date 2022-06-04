CREATE TABLE User(
    id    INT PRIMARY KEY,
    email VARCHAR(128)
);

CREATE TABLE Channel(
    id           INT PRIMARY KEY,
    user         INT,
    channel_name VARCHAR(128)
);

CREATE TABLE Video(
    id         INT PRIMARY KEY,
    channel    INT,
    video_name VARCHAR(128)
);

CREATE TABLE Watch(
    id       INT PRIMARY KEY,
    video    INT,
    user     INT,
    watch_at TIMESTAMP
);

INSERT INTO User(id, email) VALUES (1, "gosho@abv.bg"), (2, "pesho@gmail.com"), (3, "ivan@gmail.com");

INSERT INTO Channel(id, user, channel_name) VALUES (1, 1, "GoshoTV"), (2, 1, "GoshoMTV");

INSERT INTO Video(id, channel, video_name) VALUES (1, 1, "Kodene"), (2, 1, "Bazi"), (3, 1, "Izpit");

INSERT INTO Watch(id, video, user, watch_at) VALUES (1, 1, 2, CURRENT_TIMESTAMP), (2, 2, 2, CURRENT_TIMESTAMP), (3, 2, 3, CURRENT_TIMESTAMP);

-- Get all the users whos emails are at gmail.com
SELECT
    User.email
FROM User
WHERE User.email LIKE '%@gmail.com';

-- Count the channels of every user.
SELECT
    User.email,
-- If we do COUNT(*) than Users without Channels will have channels equal to 1
-- instead of 0 because COUNT(*) counts the number of records!!!
    COUNT(Channel.id) as channels
FROM User LEFT JOIN Channel ON User.id = Channel.user
GROUP BY User.id;

-- The same as above but without taking advantage of dependent columns which is
-- not supported by all SQL DBs.
SELECT
    User.email,
    Channels.channels
FROM User JOIN (
    SELECT
        User.id as user,
        COUNT(Channel.id) as channels
    FROM User LEFT JOIN Channel ON User.id = Channel.user
    GROUP BY User.id
) AS Channels ON Channels.user = User.id;

-- Same as above but by using a WITH statement for a CTE.
WITH
    Channels AS (
    SELECT
        User.id as user,
        COUNT(Channel.id) as channels
    FROM User LEFT JOIN Channel ON User.id = Channel.user
    GROUP BY User.id
)
SELECT
    User.email,
    Channels.channels
FROM User JOIN Channels ON Channels.user = User.id;

-- Return all the videos that are not watched.
SELECT
    Video.video_name
FROM Video
WHERE NOT EXISTS (
    SELECT *
    FROM Watch
    WHERE Watch.video = Video.id
);

-- Same as above but with a JOIN instead of sub-query.
SELECT
    Video.video_name
FROM Video LEFT JOIN Watch ON Watch.video = Video.id
WHERE Watch.video IS NULL

-- Get all the channels that do not have a watched video.
SELECT
    Channel.channel_name
FROM Channel
WHERE NOT EXISTS (
    SELECT *
    FROM Watch JOIN Video ON Watch.video = Video.id
    WHERE Video.channel = Channel.id
);

-- Get all the watches for watched videos only
SELECT
    video as video_id,
    COUNT(*) as watches
FROM Watch
GROUP BY video;

-- Get the most watched uploaded video(s) of every user.
WITH
    Watches AS (
        SELECT
            video as video_id,
            COUNT(*) as watches
        FROM Watch
        GROUP BY video
    ),
    Videos AS (
        SELECT
            User.id as user_id,
            Video.id as video_id
        FROM User
        JOIN Channel ON Channel.user = User.id
        JOIN Video ON Video.channel = Channel.id
        
    ),
    UserWatched AS (
        SELECT
            Videos.user_id as user_id,
            Videos.video_id as video_id,
            Watches.watches as watched
        FROM Videos JOIN Watches ON Videos.video_id = Watches.video_id
    ),
    MostWatched AS (
        SELECT
            *
        FROM UserWatched
        WHERE UserWatched.watched = (
            SELECT
                MAX(T.watched)
            FROM UserWatched AS T
            WHERE T.user_id = UserWatched.user_id
        )
    )
SELECT
    User.email as email,
    Video.video_name as video_name,
    MostWatched.watched as watches
FROM MostWatched
JOIN User ON MostWatched.user_id = User.id
JOIN Video ON MostWatched.video_id = Video.id;

-- Same as above but only with 2 CTEs.
WITH
    VideoWatches AS (
        SELECT
            Channel.id as channel,
            Video.id   as video,
            COUNT(*)   as watches
        FROM Watch
        JOIN Video   ON Watch.video   = Video.id
        JOIN Channel ON Video.channel = Channel.id
        GROUP BY Video.id
    ),
    MostWatched AS (
        SELECT
            VideoWatches.channel as channel,
            VideoWatches.video   as video,
            VideoWatches.watches as watches
        FROM
            VideoWatches
        WHERE VideoWatches.watches=(SELECT MAX(T.watches) FROM VideoWatches AS T WHERE T.channel = VideoWatches.channel)
    )
SELECT
    Channel.channel_name as channel,
    Video.video_name     as video,
    MostWatched.watches  as watches
FROM MostWatched
JOIN Video   ON MostWatched.video   = Video.id
JOIN Channel ON MostWatched.channel = Channel.id;
