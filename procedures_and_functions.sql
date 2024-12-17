--  Convert Video to JSON
CREATE FUNCTION VideoToJson (videoID INT) RETURNS JSON BEGIN RETURN (
    SELECT
        JSON_OBJECT (
            'VideoID',
            VideoID,
            'Title',
            Title,
            'Description',
            Description,
            'ReleaseDate',
            ReleaseDate,
            'Duration',
            Duration,
            'Country',
            Country
        )
    FROM
        Video
    WHERE
        VideoID = videoID
);

END;

-- Generate Newsletter Content
CREATE PROCEDURE GenerateNewsletter () BEGIN
INSERT INTO
    Newsletter (Content)
SELECT
    CONCAT (
        'This week new videos: ',
        GROUP_CONCAT (Title SEPARATOR ', ')
    )
FROM
    Video
WHERE
    ReleaseDate >= NOW () - INTERVAL 7 DAY;

END;

-- Suggest Popular Videos
CREATE PROCEDURE SuggestPopularVideos (userID INT) BEGIN
SELECT
    v.VideoID,
    v.Title,
    COUNT(h.ID) AS Popularity
FROM
    Video v
    JOIN UserPreferences p ON v.Category = p.Category
    JOIN UserWatchHistory h ON v.VideoID = h.VideoID
WHERE
    h.WatchDate >= NOW () - INTERVAL 2 WEEK
    AND p.UserID = userID
GROUP BY
    v.VideoID
ORDER BY
    Popularity DESC
LIMIT
    10;

END;