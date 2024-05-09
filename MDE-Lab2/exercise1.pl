/* student_name, unit, shift, grade */
student_unit(manuel,    mde,p1,13).
student_unit(alexandra, mde,p1,16).
student_unit(joana,     mde,p3,12).
student_unit(maria,     mde,p3,17).
student_unit(diogo,     mde,p2,9).
student_unit(jose,      mde,p5,18).
student_unit(rodrigo,   mde,p5,12).
student_unit(manuel,    mde,p1,11).
student_unit(anabela,   mde,p1,13).
student_unit(joana,     cee,p2,18).
student_unit(maria,     cee,p2,8).
student_unit(diogo,     cee,p2,11).

/* professor_name, unit, shift */
teaches(andre,mde,p4).
teaches(andre,mde,p3).
teaches(filipa,mde, p2).
teaches(filipa,mde, p5).
teaches(anabela,cee,p2).
teaches(anabela,cee,p1).
teaches(joao,prd,p1).
teaches(joao,prd,p2).

/* 1a */
students_by_shift(N,Unit,Shift):-
    student_unit(N,Unit,Shift,_).
/* 1b */
grade_threshold_by_shift(Name,Shift,Grade):-
    student_unit(Name,_,Shift,G),
    G>Grade.
/* 1c */
units_by_name(Name, Unit):-
    student_unit(Name, Unit,_,_).
/* 1d */
students_by_teacher(Teacher, Studens):-
    teaches(Teacher, UnitT, ShiftT),
    student_unit(Students, UnitS, ShiftS,_),
    ShiftT = ShiftS,
    UnitT = UnitS.
/* 1e */
teachers_by_student(Student,Teacher):-
    student_unit(Student, UnitS, ShiftS, _),
    teaches(Teacher, UnitT, ShiftT),
    UnitS = UnitT,
    ShiftS = ShiftT.

