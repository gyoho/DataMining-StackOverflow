CREATE TABLE `cmpe239`.`nodeQuality` (
  `Id` INT NOT NULL,
  `Size` INT NOT NULL);

LOAD DATA INFILE '/Users/gyoho/Class/Data\ Mining/Project/DataMining-StackExchange/dataset/gephi-data/quality_result_gephi-300.csv' 
INTO TABLE nodeQuality 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Test --
select * from nodeQuality;


CREATE TABLE `cmpe239`.`nodeLabel` (
  `Id` INT NOT NULL,
  `Label` TEXT NOT NULL);

LOAD DATA INFILE '/Users/gyoho/Class/Data\ Mining/Project/Dataset-AskUbuntu/data/questions-300.csv' 
INTO TABLE nodeLabel 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Test --
select * from nodeLabel;


select nodeQuality.Id, nodeLabel.Label, nodeQuality.Size
from nodeQuality, nodeLabel
where nodeQuality.Id = nodeLabel.Id;