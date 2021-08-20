select z.contest_id, z.hacker_id, z.name, z.u, z.q, z.a, z.b from 
(select c.contest_id, c.hacker_id, c.name, sum(x.total_views) as a, sum(x.total_unique_views) as b, sum(x.total_submissions) as u, sum(x.total_accepted_submissions) as q from Contests c
inner join Colleges co on co.contest_id = c.contest_id
inner join Challenges ch on ch.college_id = co.college_id
inner join 
(
    (select v.total_views, v.total_unique_views, 0 as total_submissions, 0 as total_accepted_submissions, v.challenge_id from view_stats v)
union all
(select 0 as total_views, 0 as total_unique_views, w.total_submissions, w.total_accepted_submissions, w.challenge_id from submission_stats w)
    ) x on x.challenge_id = ch.challenge_id
group by c.contest_id) z
where z.a+z.b+z.u+z.q > 0
order by z.contest_id;