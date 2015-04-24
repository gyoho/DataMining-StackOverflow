CREATE TABLE `cmpe239`.`postLinkFinal` (
  `Source` INT NOT NULL,
  `Target` INT NOT NULL);

LOAD DATA INFILE '/Users/gyoho/Class/Data Mining/Project/DataMining-StackExchange/dataset/result-data/link_data_gephi.csv' 
INTO TABLE postLinkFinal 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


select *
from postLinkFinal
where Source <= 1207 and Target <= 1207
order by Source;

select * from postsQuality
where posttypeid = 1;