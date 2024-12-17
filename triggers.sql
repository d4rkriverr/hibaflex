-- Limit the Number of Favorite Videos to 300
CREATE TRIGGER LimitUserFavorites
    BEFORE INSERT ON UserFavoriteVideo FOR EACH ROW
        BEGIN
            DECLARE favoriteCount INT;
            SELECT
                COUNT(*) INTO favoriteCount
            FROM
                UserFavoriteVideo
            WHERE
                UserID = NEW.UserID;

            IF favoriteCount >= 300 THEN SIGNAL SQLSTATE '45000'
                SET
                    MESSAGE_TEXT = 'A user cannot have more than 300 favorite videos.';
            END IF;
        END;

-- Archive a Video When It Is Deleted
CREATE TRIGGER ArchiveVideoOnDelete
    AFTER DELETE ON Video FOR EACH ROW
        BEGIN
            INSERT INTO ArchivedVideo (VideoID, ArchivedAt, Reason)
            VALUES (OLD.VideoID, NOW(), 'Video removed from the site');
        END;

-- Limit the Number of Video Watches to 3 per Minute
CREATE TRIGGER LimitUserWatchRate
    BEFORE INSERT ON UserWatchHistory FOR EACH ROW
        BEGIN
            DECLARE recentViews INT;

            SELECT COUNT(*) INTO recentViews 
            FROM UserWatchHistory 
            WHERE UserID = NEW.UserID 
            AND WatchDate > NOW() - INTERVAL 1 MINUTE;
            
            IF recentViews >= 3 THEN
                SIGNAL SQLSTATE '45000' 
                SET MESSAGE_TEXT = 'A user cannot start more than 3 video watches per minute.';
            END IF;
        END;

-- Maintain Video Popularity Statistics
CREATE TRIGGER UpdateVideoPopularity
    AFTER INSERT ON UserWatchHistory FOR EACH ROW
        BEGIN
            INSERT INTO VideoPopularity (VideoID, ViewsLastTwoWeeks, TotalViews)
            VALUES (NEW.VideoID, 1, 1)
            ON DUPLICATE KEY UPDATE 
                ViewsLastTwoWeeks = ViewsLastTwoWeeks + 1,
                TotalViews = TotalViews + 1;
        END;

-- Automatically Archive Expired Videos
CREATE TRIGGER ArchiveExpiredVideos
    BEFORE UPDATE ON Video FOR EACH ROW
        BEGIN
            IF NEW.AvailableUntil < NOW() THEN
                INSERT INTO ArchivedVideo (VideoID, ArchivedAt, Reason)
                VALUES (OLD.VideoID, NOW(), 'Video expired');
                SET NEW.Archived = TRUE;
            END IF;
        END;

-- Automatically Add New Videos to the Newsletter
CREATE TRIGGER AddVideoToNewsletter
    AFTER INSERT ON Video FOR EACH ROW
        BEGIN
            INSERT INTO Newsletter (Content)
            VALUES (CONCAT('New video available: ', NEW.Title, ' (', NEW.ReleaseDate, ')'));
        END;
