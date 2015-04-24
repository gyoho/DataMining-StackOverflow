CREATE TABLE `cmpe239`.`similarity` (
  `Source` INT NOT NULL,
  `Target` INT NOT NULL,
  `Weight` DOUBLE NOT NULL);

LOAD DATA INFILE '/Users/gyoho/CosineBinScores_clean_pair.csv' 
INTO TABLE similarity 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

select * from similarity;

select *
from similarity
where Source != Target;

select *
from similarity
where Source = Target;