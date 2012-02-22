USE master 
GO

IF  EXISTS (SELECT name FROM sys.databases WHERE name = 'Blog')
  DROP DATABASE Blog
GO

CREATE DATABASE Blog
GO

USE Blog
GO

CREATE TABLE dbo.Article(
  Uri varchar(255) NOT NULL,
  Author varchar(100) NOT NULL,
  PublishedDate datetimeoffset(7) NOT NULL,
  Title varchar(255) NOT NULL,
  Body varchar(max) NOT NULL,
  CONSTRAINT PK_Article PRIMARY KEY CLUSTERED (Uri ASC))
GO

CREATE VIEW dbo.V_ArticleSummary AS
SELECT Author, PublishedDate, Title, Body AS Summary, Uri FROM dbo.Article
GO

CREATE VIEW dbo.V_Article AS
SELECT Body, Title, PublishedDate, Author, Uri FROM dbo.Article
GO

CREATE TABLE dbo.Comment(
  ArticleUri varchar(255) NOT NULL,
  Author varchar(100) NOT NULL,
  Body varchar(500) NOT NULL,
  PublishedDate datetimeoffset(7) NOT NULL)
GO

CREATE VIEW dbo.V_Comment AS
  SELECT ArticleUri, Author, Body, PublishedDate
  FROM dbo.Comment
GO

ALTER TABLE dbo.Comment WITH CHECK 
  ADD CONSTRAINT FK_Comment_Belongs_To_An_Article FOREIGN KEY(ArticleUri)
  REFERENCES dbo.Article (Uri)
GO

ALTER TABLE dbo.Comment CHECK CONSTRAINT FK_Comment_Belongs_To_An_Article
GO

INSERT INTO dbo.Article(Uri, Author, PublishedDate, Title, Body)
  SELECT N'lorem-ipsum-dolor-sit-amet', N'John Doe', '20120101 1:00:00.00 -7:00', N'Lorem ipsum dolor sit amet.', N'Lorem ipsum **dolor** sit amet, consectetur adipiscing elit. Morbi in urna eros. Sed ultricies magna tincidunt nisl ornare euismod. Donec vitae diam nunc. Cras vel pellentesque nulla. Donec non facilisis nisi. Nullam suscipit molestie eros, vitae porttitor tortor lobortis sit amet. Maecenas eget urna dui. Morbi nec augue tincidunt risus congue aliquam. <!--more--> _Integer_ et consequat ipsum. Vivamus sodales venenatis neque ut pretium. Nam aliquam libero ac tellus malesuada quis porttitor nisl vehicula. Maecenas quis nunc lorem. Pellentesque scelerisque risus eu magna elementum tristique. Phasellus sapien ante, rhoncus id mollis laoreet, volutpat et risus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus dictum tincidunt viverra. Phasellus bibendum eleifend aliquet. Maecenas in arcu velit. Duis sodales pellentesque pellentesque. In porta, turpis pharetra interdum molestie, eros magna aliquet velit, eget dapibus dui turpis ac mauris. Duis non leo vel diam commodo egestas. Proin varius, diam sit amet pretium elementum, neque arcu fringilla lacus, ac tempus nibh felis id nisl. Aenean vestibulum condimentum lectus, eu tincidunt magna dictum quis.'
GO

INSERT INTO dbo.Comment(ArticleUri, Author, Body, PublishedDate)
  SELECT N'lorem-ipsum-dolor-sit-amet', N'Bob Duck', N'Vivamus sodales venenatis neque ut pretium. Nam aliquam libero ac tellus malesuada quis porttitor nisl vehicula. Maecenas quis nunc lorem.', '20120101 12:00:00.000 -7:00' UNION ALL
  SELECT N'lorem-ipsum-dolor-sit-amet', N'Kong Doe', N'Sodales neque ut pretium. Nam ac tellus malesuada quis nisl vehicula. Maecenas quis nunc.', '20120102 12:00:00.000 -7:00' UNION ALL
  SELECT N'lorem-ipsum-dolor-sit-amet', N'Bob Duck', N'Vivamus sodales venenatis neque ut pretium. Nam aliquam libero ac tellus malesuada quis porttitor nisl vehicula. Maecenas quis nunc lorem.', '20120110 12:35:00.00 -7:00'
GO