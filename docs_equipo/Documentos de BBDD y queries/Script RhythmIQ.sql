-- 1. Creamos el esquema
CREATE SCHEMA RhythmIQ;
USE RhythmIQ;


-- 2. Creamos las entidades/tablas principales

CREATE TABLE Album (
    album_id INT PRIMARY KEY AUTO_INCREMENT,
    album_name VARCHAR(200) NOT NULL,
    album_type VARCHAR(100),
    total_tracks INT,
    album_release_date DATE,
    label VARCHAR(200)
);

CREATE TABLE Artist (
    artist_id INT PRIMARY KEY AUTO_INCREMENT,
    artist_name VARCHAR(200) NOT NULL,
    artist_popularity INT,
    artist_followers BIGINT
);

CREATE TABLE Tag (
    tag_id INT PRIMARY KEY AUTO_INCREMENT,
    tags VARCHAR(200) NOT NULL UNIQUE
);

CREATE TABLE Genre (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(200) NOT NULL UNIQUE
);

CREATE TABLE Track (
    track_id INT PRIMARY KEY AUTO_INCREMENT,
    track_name VARCHAR(200) NOT NULL,
    track_release_date DATE,
    track_popularity INT,
    track_year YEAR,
    collaboration BOOLEAN,
    genre_extracted VARCHAR(200),
    listeners BIGINT,
    playcount BIGINT,
    album_id INT,
    FOREIGN KEY (album_id) REFERENCES Album(album_id)
        ON UPDATE CASCADE 
        ON DELETE SET NULL
);


-- 3. Creamos las tablas intermedias para cubrir las relaciones(N:M)

CREATE TABLE Track_Artist (
    track_id INT NOT NULL,
    artist_id INT NOT NULL,
    is_main_artist BOOLEAN, -- 1 es main artist y 0 el colaborador
    PRIMARY KEY (track_id, artist_id),
    FOREIGN KEY (track_id) REFERENCES Track(track_id)
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
        ON UPDATE CASCADE 
        ON DELETE CASCADE
);

CREATE TABLE Track_Tag (
    track_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (track_id, tag_id),
    FOREIGN KEY (track_id) REFERENCES Track(track_id)
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES Tag(tag_id)
        ON UPDATE CASCADE 
        ON DELETE CASCADE
);

CREATE TABLE Artist_Genre (
    artist_id INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (artist_id, genre_id),
    FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
        ON UPDATE CASCADE 
        ON DELETE CASCADE
);

SELECT * FROM album;
SELECT * FROM artist;
SELECT * FROM genre;
SELECT * FROM tag;
SELECT * FROM track;
SELECT * FROM track_artist;
SELECT * FROM track_tag;
SELECT * FROM artist_genre;