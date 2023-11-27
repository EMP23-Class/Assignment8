"""
Finds an optimal study schedule.

Specifically, let N be the number of classes taken, which is the length of "initial_scores" and "efficiency_multipliers".
The initial score for each class is the grade percentage you would get without any studying, e.g. 74.3
The efficiency multiplier is the factor that determines how time spent studying is likely to increase class score. 
Specifically, score_after_studying = initial_score + efficiency_multiplier * hours_alloted_to_class

The grade that is assigned for each class is given by the following table:

A  : 93 ≤ s
A- : 90 ≤ s < 93
B+ : 87 ≤ s < 90
B  : 83 ≤ s < 87
B- : 80 ≤ s < 83
C+ : 77 ≤ s < 80
C  : 73 ≤ s < 77
C- : 70 ≤ s < 73
D+ : 67 ≤ s < 70
D  : 63 ≤ s < 67
D- : 60 ≤ s < 63
F  :      s < 60

The grade points that are assigned for each grade are given by the following table:

A  : 4.0
A- : 3.7
B+ : 3.3
B  : 3.0
B- : 2.7
C+ : 2.3
C  : 2.0
C- : 1.7
D+ : 1.3
D  : 1.0
D- : 0.7
F  : 0.0

Your goal is to choose the time spent studying for each class, so that sum(hours_for_each_class) ≤ total_study_time,
and that the function
    sum(grade_points_for_each_class) - laziness_factor * sum(hours_for_each_class) 
is maximized.

Note that the time spent per class can be fractional (doesn't need to be whole hour chunks), but in order to properly represent 
grade scores, and the relationship to grade points, you will need to use binary or integer variables.

Returns a named tuple
(; grades, hours, scores)
where e.g. grades = [3.0, 2.7, 1.7] is a vector of grade points assigned for each class.
      e.g. hours  = [8.2432, 7.112, 1.34] is a vector of hours spent studying on each class.
      e.g. scores = [83.1, 81.1, 70.0] is a vector of grade scores received in each class.
"""
function optimize_studying(initial_scores, efficiency_multipliers, total_study_time, laziness_factor)
    N = length(initial_scores)
    @assert N == length(efficiency_multipliers)
    @assert N > 0
    @assert all(0 .< efficiency_multipliers)
    @assert all(0 .≤ initial_scores .≤ 100)
    @assert 0 ≤ total_study_time
    @assert laziness_factor > 0

    grades = zeros(N) # Fix me
    hours = zeros(N) # fix me
    scores = zeros(N) # fix me
    (; grades, hours, scores, params=(; initial_scores, efficiency_multipliers, total_study_time, laziness_factor))
end

