# Le modèle E/A (Entity-Association)
In the E/A model, we represent the system with entities, their attributes, 
and the relationships between them.

# Entities and Attributes:
  User
  
      ID (Primary Key)  
      Login
      Password
      FirstName
      LastName
      DateOfBirth
      Email
      SubscribedToNewsletter
    
  Show

      ID (Primary Key)
      Name
      Category

  Episode
  
      ID (Primary Key)
      ShowID (Foreign Key referencing Show)
      Title
      Description
      Duration
      ReleaseDate

  Video
  
      ID (Primary Key)
      EpisodeID (Foreign Key referencing Episode)
      AvailableUntil
      Archived
      LanguageAvailable
      ImageFormat
      Country

  UserShowSubscription
  
      UserID (Foreign Key referencing User)
      ShowID (Foreign Key referencing Show)
      SubscriptionDate

  UserFavoriteVideo
  
      UserID (Foreign Key referencing User)
      VideoID (Foreign Key referencing Video)

  UserWatchHistory
  
      UserID (Foreign Key referencing User)
      VideoID (Foreign Key referencing Video)
      WatchDate

  VideoSuggestion
  
      UserID (Foreign Key referencing User)
      VideoID (Foreign Key referencing Video)
      SuggestedDate

# Relationships:
  - User-Show Subscription: A user can subscribe to many shows. This creates a many-to-many relationship between User and Show.
  - User-Favorite Video: A user can add multiple videos to their favorites. This creates a many-to-many relationship between User and Video.
  - User-Video Watch History: A user can watch many videos, and each video can be watched by many users. This is another many-to-many relationship between User and Video.
  - Video-Show: A show can have multiple episodes, and each episode will have one or more videos, which are related to the Video entity.
  - Video-Category: Each video belongs to a category. A video may have a Category field, or you can link them in a many-to-many relationship.
  - User-Video Suggestions: A user can receive multiple video suggestions based on their subscriptions and favorites.

# E/A Model Diagram:
  Here’s a simplified diagram of the entities and their relationships:
  User -----< UserShowSubscription >----- Show -----< Episode >-----< Video >-----< Category >  
    |                                    |                             |                     |  
    |                                    |                             |                     |  
    |                                    |                             |                     |  
    |                                    |                             |                     |  
    v                                    v                             v                     v  
  UserFavoriteVideo               UserWatchHistory               VideoSuggestion         Category  
