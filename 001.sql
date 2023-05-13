select s.name student, g.name grade, c.code, t.name teacher, gl.domain_id, sg.goal_id
from teachers_classes tc, teachers_grades tg, classes_grades cg, 
students s, teachers t, classes c, grades g, 
students_goals sg, goals gl
where 0=0
and tc.teacher_id = tg.teacher_id
and tc.teacher_id = t.id
and tc.class_id = cg.class_id
and tc.class_id = c.id
and tg.grade_id = cg.grade_id
and tg.grade_id = s.grade_id
and tg.grade_id = g.id
and sg.student_id = s.id
and gl.id = sg.goal_id
and s.id = 320
order by t.id, c.id
;
-----
select s.id student_id, tc.teacher_id, sg.goal_id, gl.domain_id, tc.class_id, tg.grade_id
from teachers_classes tc, teachers_grades tg, classes_grades cg, 
students s, teachers t, classes c, grades g, 
students_goals sg, goals gl
where 0=0
and tc.teacher_id = tg.teacher_id
and tc.teacher_id = t.id
and tc.class_id = cg.class_id
and tc.class_id = c.id
and tg.grade_id = cg.grade_id
and tg.grade_id = s.grade_id
and tg.grade_id = g.id
and sg.student_id = s.id
and gl.id = sg.goal_id
order by t.id, c.id
;
-----
