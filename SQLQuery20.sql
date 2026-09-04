
CREATE DATABASE RaceDayDB;
GO

USE RaceDayDB;
GO


CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Organiser', 'Participant'))
);
GO


CREATE TABLE UserProfiles (
    ProfileID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    ContactNumber NVARCHAR(20) NULL,
    DateOfBirth DATE NULL
);
GO


CREATE TABLE Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500) NULL,
    EventDate DATETIME NOT NULL,
    Location NVARCHAR(100) NOT NULL,
    OrganiserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID)
);
GO


CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL FOREIGN KEY REFERENCES Events(EventID) ON DELETE CASCADE,
    CategoryName NVARCHAR(50) NOT NULL,
    DistanceKm DECIMAL(5,2) NOT NULL
);
GO


CREATE TABLE Enrolments (
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL FOREIGN KEY REFERENCES Events(EventID),
    ParticipantID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    CategoryID INT NOT NULL FOREIGN KEY REFERENCES Categories(CategoryID),
    EnrolmentDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- 6. Results Table
CREATE TABLE Results (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL FOREIGN KEY REFERENCES Enrolments(EnrolmentID) ON DELETE CASCADE,
    FinishTime TIME NULL,
    Position INT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Registered' CHECK (Status IN ('Registered', 'Completed', 'DidNotFinish'))
);
GO


INSERT INTO Users (Username, Email, PasswordHash, Role) VALUES
('org_john', 'john@raceday.co.za', 'hashed_pw_1', 'Organiser'),
('org_sarah', 'sarah@raceday.co.za', 'hashed_pw_2', 'Organiser'),
('part_mike', 'mike@gmail.com', 'hashed_pw_3', 'Participant'),
('part_lindiwe', 'lindiwe@gmail.com', 'hashed_pw_4', 'Participant');
GO

INSERT INTO UserProfiles (UserID, FirstName, LastName, ContactNumber, DateOfBirth) VALUES
(1, 'John', 'Smith', '0821234567', '1980-05-12'),
(2, 'Sarah', 'Connor', '0839876543', '1985-09-23'),
(3, 'Mike', 'Dlamini', '0723334444', '1992-03-15'),
(4, 'Lindiwe', 'Khumalo', '0765556677', '1995-11-04');
GO

INSERT INTO Events (Title, Description, EventDate, Location, OrganiserID) VALUES
('Two Oceans Warm-up Run', 'A scenic 10km and 21km road run through the peninsula.', '2026-10-15 06:00:00', 'Cape Town', 1),
('Soweto Spring Marathon', 'Annual community road running event celebrating heritage.', '2026-11-05 05:30:00', 'Soweto, Johannesburg', 1),
('Durban Beachfront Dash', 'Fast and flat coastal 5km and 10km event.', '2026-12-01 07:00:00', 'Durban Promenade', 2);
GO

INSERT INTO Categories (EventID, CategoryName, DistanceKm) VALUES
(1, '10km Road Run', 10.00),
(1, '21km Half Marathon', 21.10),
(2, '10km Fun Run', 10.00),
(2, 'Full Marathon', 42.20),
(3, '5km Dash', 5.00),
(3, '10km Challenge', 10.00);
GO

INSERT INTO Enrolments (EventID, ParticipantID, CategoryID, EnrolmentDate) VALUES
(1, 3, 1, '2026-09-01 10:00:00'),
(1, 4, 2, '2026-09-02 11:30:00'),
(2, 3, 4, '2026-09-03 09:15:00');
GO

INSERT INTO Results (EnrolmentID, FinishTime, Position, Status) VALUES
(1, '00:45:20', 12, 'Completed'),
(2, '01:58:45', 45, 'Completed');
GO
    