select count(1) from video v
inner join documentary d on d.video_id = v.id
where series_id is null;


select count(1) from series s
where type_series_id = 1;

select count(1) from reproduction r
inner join video_language vl on vl.id = r.video_language_id
inner join video v on v.id = vl.video_id
inner join serie s on v.id = s.video_id;

select count(1) from reproduction r
inner join video_language vl on vl.id = r.video_language_id
inner join video v on v.id = vl.video_id
inner join movie m on v.id = m.video_id;

select count(1) from reproduction r
inner join video_language vl on vl.id = r.video_language_id
inner join video v on v.id = vl.video_id
inner join documentary d on v.id = d.video_id;


select count(1) from download d
inner join video_language vl on vl.id = d.video_language_id
inner join video v on v.id = vl.video_id
inner join serie s on v.id = s.video_id;

select count(1) from download d
inner join video_language vl on vl.id = d.video_language_id
inner join video v on v.id = vl.video_id
inner join movie m on v.id = m.video_id;

select count(1) from download d
inner join video_language vl on vl.id = d.video_language_id
inner join video v on v.id = vl.video_id
inner join documentary d on v.id = d.video_id;

