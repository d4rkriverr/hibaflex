-- Optimize UserWatchHistory:
CREATE INDEX idx_user_watch_history_userid ON UserWatchHistory (UserID, WatchDate);

-- Optimize VideoPopularity:
CREATE INDEX idx_video_popularity_views ON VideoPopularity (ViewsLastTwoWeeks);