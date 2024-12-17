CREATE TABLE
    User (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Login VARCHAR(100) UNIQUE NOT NULL,
        Password VARCHAR(255) NOT NULL,
        FirstName VARCHAR(100),
        LastName VARCHAR(100),
        DateOfBirth DATE,
        Email VARCHAR(255) UNIQUE NOT NULL,
        SubscribedToNewsletter BOOLEAN DEFAULT FALSE
    );

CREATE TABLE
    UserCategoryPreference (
        UserID INT NOT NULL,
        Category VARCHAR(100) NOT NULL,
        PRIMARY KEY (UserID, Category),
        FOREIGN KEY (UserID) REFERENCES User (ID)
    );

CREATE TABLE
    UserShowSubscription (
        UserID INT NOT NULL,
        ShowID INT NOT NULL,
        PRIMARY KEY (UserID, ShowID),
        FOREIGN KEY (UserID) REFERENCES User (ID),
        FOREIGN KEY (ShowID) REFERENCES Show (ID)
    );

CREATE TABLE
    UserFavoriteVideo (
        UserID INT NOT NULL,
        VideoID INT NOT NULL,
        PRIMARY KEY (UserID, VideoID),
        FOREIGN KEY (UserID) REFERENCES User (ID),
        FOREIGN KEY (VideoID) REFERENCES Video (ID)
    );

CREATE TABLE
    UserWatchHistory (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        UserID INT NOT NULL,
        VideoID INT NOT NULL,
        WatchDate DATETIME NOT NULL,
        FOREIGN KEY (UserID) REFERENCES User (ID),
        FOREIGN KEY (VideoID) REFERENCES Video (ID)
    );

-- #####################################################
CREATE TABLE
    Show (
        ShowID SERIAL PRIMARY KEY,
        Name VARCHAR(100) NOT NULL,
        Category VARCHAR(50) NOT NULL
    );

CREATE TABLE
    Episode (
        EpisodeID SERIAL PRIMARY KEY,
        ShowID INT NOT NULL,
        Title VARCHAR(100) NOT NULL,
        Description TEXT,
        Duration INTERVAL NOT NULL,
        ReleaseDate DATE NOT NULL,
        FOREIGN KEY (ShowID) REFERENCES Show (ShowID) ON DELETE CASCADE
    );

CREATE TABLE
    Video (
        VideoID SERIAL PRIMARY KEY,
        EpisodeID INT NOT NULL,
        AvailableUntil DATE NOT NULL,
        Archived BOOLEAN DEFAULT FALSE,
        LanguageAvailable BOOLEAN DEFAULT FALSE,
        ImageFormat VARCHAR(20) NOT NULL,
        Country VARCHAR(50) NOT NULL,
        FOREIGN KEY (EpisodeID) REFERENCES Episode (EpisodeID) ON DELETE CASCADE,
        CHECK (AvailableUntil >= ReleaseDate + INTERVAL '7 days')
    );

-- #####################################
CREATE TABLE
    ArchivedVideo (
        ArchivedVideoID SERIAL PRIMARY KEY,
        VideoID INT UNIQUE NOT NULL,
        ArchivedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        Reason VARCHAR(255),
        FOREIGN KEY (VideoID) REFERENCES Video (VideoID)
    );

CREATE TABLE
    UserPreferences (
        UserID INT NOT NULL,
        Category VARCHAR(100) NOT NULL,
        PriorityLevel INT DEFAULT 1,
        PRIMARY KEY (UserID, Category),
        FOREIGN KEY (UserID) REFERENCES User (ID)
    );

CREATE TABLE
    VideoPopularity (
        VideoID INT PRIMARY KEY,
        ViewsLastTwoWeeks INT DEFAULT 0,
        TotalViews INT DEFAULT 0,
        FOREIGN KEY (VideoID) REFERENCES Video (VideoID)
    );

CREATE TABLE
    Newsletter (
        NewsletterID SERIAL PRIMARY KEY,
        CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        Content TEXT
    );