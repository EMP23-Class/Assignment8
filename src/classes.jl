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
    
    model = Model(HiGHS.Optimizer)

    @variable(model, Z[1:N, 1:6], Bin) # Grade components ( represented using binary map )
    @variable(model, G[1:N]) # Grades
    @variable(model, S[1:N]) # Scores
    @variable(model, H[1:N] ≥ 0) # Hours applied to each class
    @objective(model, Max, sum(G) - laziness_factor * sum(H))
    for i in 1:N
        @constraint(model, G[i] == 0 * Z[i, 1] + 2 * Z[i, 2] + 1 * Z[i, 3] + 0.3 * Z[i, 4] + 0.4 * Z[i, 5] + 0.3 * Z[i, 6])
        @constraint(model, S[i] == initial_scores[i] + H[i] * efficiency_multipliers[i])

        @constraint(model, S[i] ≥ 53 * Z[i,1] + 20 * Z[i, 2] + 10 * Z[i, 3] + 4 * Z[i, 4] + 3 * Z[i, 5] + 3 *  Z[i, 6])
        @constraint(model, Z[i,1] ≥ Z[i,2])
        @constraint(model, Z[i,1] ≥ Z[i,3])
        @constraint(model, Z[i,1] ≥ Z[i,4])
        @constraint(model, Z[i,1] ≥ Z[i,5])
        @constraint(model, Z[i,1] ≥ Z[i,6])
        @constraint(model, Z[i,5] ≤ Z[i,4])
        @constraint(model, Z[i,6] ≤ Z[i,5])
        @constraint(model, Z[i,4] ≤ (Z[i,2] + Z[i,3] + Z[i,5]))
    end
    @constraint(model, sum(H) ≤ total_study_time)
    optimize!(model)
    grades = value.(G)
    hours = value.(H)
    scores = value.(S)
    (; grades, hours, scores, params=(; initial_scores, efficiency_multipliers, total_study_time, laziness_factor))
end

