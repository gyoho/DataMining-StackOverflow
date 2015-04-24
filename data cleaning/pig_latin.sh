<ref: http://stackoverflow.com/questions/22434300/possible-to-use-hcatalog-with-xml-doing-etl-on-cloudera-vm>
<ref: http://stackoverflow.com/questions/22627693/pig-not-loading-data-into-hcatalog-table-hortonworks-sandbox>

items = LOAD '/user/cloudera/posts.xml' USING org.apache.pig.piggybank.storage.XMLLoader('row') AS (row:chararray);

data = FOREACH items GENERATE
REGEX_EXTRACT(row, 'Id="([^"]*)"', 1) AS id:int,
REGEX_EXTRACT(row, 'PostTypeId="([^"]*)"', 1) AS postTypeId:int,
REGEX_EXTRACT(row, 'AcceptedAnswerId="([^"]*)"', 1) AS acceptedAnswerId:int,
REGEX_EXTRACT(row, 'ParentId="([^"]*)"', 1) AS parentId:int,
REGEX_EXTRACT(row, 'Score="([^"]*)"', 1) AS score:int,
REGEX_EXTRACT(row, 'ViewCount="([^"]*)"', 1) AS viewCount:int,
REGEX_EXTRACT(row, 'AnswerCount="([^"]*)"', 1) AS answerCount:int,
REGEX_EXTRACT(row, 'CommentCount="([^"]*)"', 1) AS commentCount:int,
REGEX_EXTRACT(row, 'FavoriteCount="([^"]*)"', 1) AS favoriteCount:int;

// debug
DUMP data

// local
STORE data INTO '/user/cloudera/reuslt_posts' USING PigStorage();

// Hcatalog: create the table manually before loading the data
STORE data INTO 'posts_table' USING org.apache.hcatalog.pig.HCatStorer();



__________________________________________________________________________________________________________
__________________________________________________________________________________________________________


items = LOAD '/user/cloudera/comment_link_data.xml' USING org.apache.pig.piggybank.storage.XMLLoader('row') AS (row:chararray);

data = FOREACH items GENERATE
REGEX_EXTRACT(row, 'PostId="([^"]*)"', 1) AS postId:int,
REGEX_EXTRACT(row, 'Text="([^"]*)"', 1) AS relatedPostId:int,
REGEX_EXTRACT(row, 'UserId="([^"]*)"', 1) AS userId:int;

STORE data INTO '/user/cloudera/result_comment_link' USING PigStorage();


__________________________________________________________________________________________________________
__________________________________________________________________________________________________________


items = LOAD '/user/cloudera/postLinks.xml' USING org.apache.pig.piggybank.storage.XMLLoader('row') AS (row:chararray);

data = FOREACH items GENERATE
REGEX_EXTRACT(row, 'PostId="([^"]*)"', 1) AS postId:int,
REGEX_EXTRACT(row, 'RelatedPostId="([^"]*)"', 1) AS relatedPostId:int,
REGEX_EXTRACT(row, 'LinkTypeId="([^"]*)"', 1) AS linkTypeId:int;

STORE data INTO '/user/cloudera/result_postLinks' USING PigStorage();


__________________________________________________________________________________________________________
__________________________________________________________________________________________________________


** Used MySQL because it's fast**
// copy to local
$ hadoop fs -copyToLocal /user/cloudera/reuslt_posts/* ~/Downloads/dataset/

// append the result data
$ cat part-m-00000 part-m-00001 part-m-00002 part-m-00003 > posts_quality.txt

// add header
$ sed -i '1i header1, header2, ...' <filename>