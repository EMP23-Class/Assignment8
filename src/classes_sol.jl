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
    scores = value.(S)
end
