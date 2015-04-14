select AVG(score) as avgScore
from postsQuality;
# 2.1249

/***
DELETED:
	select AVG(viewcount) as avgViewCount
	from postsQuality
	where posttypeid = 1;
	# 2411.5050
***/

select AVG(answercount) as avgAnsCount
from postsQuality
where posttypeid = 1;
# 1.3060


select AVG(commentcount) as avgCommentCount
from postsQuality;
# 1.2655


select AVG(favoritecount) as avgFavCount
from postsQuality
where posttypeid = 1;
# 0.6257


-- ----------------------------------------------------------
-- normrize the viewcount by devide by 1000
-- ref: http://stackoverflow.com/questions/11749120/mysql-query-divide-column-by-100
-- ----------------------------------------------------------
update postsQuality set viewcount = viewcount/1000;

select MAX(viewcount) as avgScore
from postsQuality;
# 1223


-- ----------------------------------------------------------
-- get the overall score of quality
-- ref: http://stackoverflow.com/questions/20062270/sql-query-to-get-the-sum-of-all-column-values-in-the-last-row-of-a-resultset-alo
-- ----------------------------------------------------------

select question.questionId as questionId, (question.questionQuality + answer.totalAnswerQuality) as overallQuality
from 
		# include all: score, answercount, commentcount, favoritecount for Question type
		(select id as questionId, (score + answercount + commentcount + favoritecount) as questionQuality
		from postsQuality
		where posttypeid = 1) as question
	join 
		## reduce by the same parentid
		(select questionId, sum(answerQuality) as totalAnswerQuality
		from 
			# include only: score, commnetcount for Answer type
			(select parentid as questionId, (score + commentcount) as answerQuality
			from postsQuality
			where posttypeid = 2) as individualAnswer
		group by questionId) as answer
	on question.questionId = answer.questionId;



-- ----------------------------------------------------------
-- Test
-- ----------------------------------------------------------
select questionId, sum(answerQuality) as totalAnswerQuality
from 
	(# include only: score, commnetcount for Answer type
	select parentid as questionId, (score + commentcount) as answerQuality
	from postsQuality
	where posttypeid = 2) as individualAnswer
group by questionId
having questionId = 3;


-- ----------------------------------------------------------
-- Validation
-- ----------------------------------------------------------
select id as questionId, (score + answercount + commentcount + favoritecount) as questionQuality
from postsQuality
where id = 3;


select parentid, (score + commentcount) as answerQuality
from postsQuality
where parentid = 3;