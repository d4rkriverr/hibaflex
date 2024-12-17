--  Number of Views per Category in Last Two Weeks
SELECT
    v.Category,
    COUNT(*) AS ViewsCount
FROM
    UserWatchHistory h
    JOIN Video v ON h.VideoID = v.VideoID
WHERE
    h.WatchDate >= NOW () - INTERVAL 2 WEEK
GROUP BY
    v.Category;

-- Per User: Subscriptions, Favorites, and Views
SELECT
    u.ID AS UserID,
    COUNT(DISTINCT s.ShowID) AS Subscriptions,
    COUNT(DISTINCT f.VideoID) AS Favorites,
    COUNT(h.ID) AS VideosWatched
FROM
    User u
    LEFT JOIN UserShowSubscription s ON u.ID = s.UserID
    LEFT JOIN UserFavoriteVideo f ON u.ID = f.UserID
    LEFT JOIN UserWatchHistory h ON u.ID = h.UserID
GROUP BY
    u.ID;

-- Views by Country and Their Differences
SELECT
    v.VideoID,
    COUNT(
        CASE
            WHEN u.Country = 'France' THEN 1
        END
    ) AS FrenchViews,
    COUNT(
        CASE
            WHEN u.Country = 'Germany' THEN 1
        END
    ) AS GermanViews,
    ABS(
        COUNT(
            CASE
                WHEN u.Country = 'France' THEN 1
            END
        ) - COUNT(
            CASE
                WHEN u.Country = 'Germany' THEN 1
            END
        )
    ) AS ViewDifference
FROM
    UserWatchHistory h
    JOIN User u ON h.UserID = u.ID
    JOIN Video v ON h.VideoID = v.VideoID
GROUP BY
    v.VideoID
ORDER BY
    ViewDifference DESC;

-- Popular Episodes in Shows
SELECT
    e.EpisodeID,
    e.Title,
    s.Name AS ShowName,
    COUNT(h.ID) AS EpisodeViews,
    AVG(COUNT(h.ID)) OVER (
        PARTITION BY
            e.ShowID
    ) AS AverageViews
FROM
    Episode e
    JOIN Show s ON e.ShowID = s.ShowID
    JOIN UserWatchHistory h ON e.EpisodeID = h.VideoID
GROUP BY
    e.EpisodeID,
    e.Title,
    s.Name,
    e.ShowID
HAVING
    COUNT(h.ID) >= 2 * AVG(COUNT(h.ID)) OVER (
        PARTITION BY
            e.ShowID
    );

-- Top 10 Video Pairs in Histories
SELECT
    h1.VideoID AS VideoA,
    h2.VideoID AS VideoB,
    COUNT(*) AS PairCount
FROM
    UserWatchHistory h1
    JOIN UserWatchHistory h2 ON h1.UserID = h2.UserID
    AND h1.VideoID < h2.VideoID
GROUP BY
    h1.VideoID,
    h2.VideoID
ORDER BY
    PairCount DESC
LIMIT
    10;