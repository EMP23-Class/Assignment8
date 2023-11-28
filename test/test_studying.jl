@testset "study" begin
    
    ret = Assignment8.optimize_studying([73.1, 77.1, 80], [0.93, 0.93, 0.93], 21, 0.000001);
    @test all(ret.grades .≈ 3.0)
    @test all(ret.scores .≈ 83.0)
    @test ret.hours ≈ [10.645161290322585, 6.344086021505382, 3.225806451612903]

    ret = Assignment8.optimize_studying([89.0, 67.5, 67.9], [0.4, 1.2, 1.1], 21, 0.000001);
    @test ret.hours ≈ [2.5, 12.916666666666668, 4.636363636363579]
    @test ret.scores ≈ [90.0, 83.0, 72.99999999999994]
    @test ret.grades ≈  [3.7, 3.0, 2.0]

    ret = Assignment8.optimize_studying([59.0, 57.5, 57.9], [0.4, 1.2, 1.1], 20, 0.1);
    @test ret.grades ≈ [0.7, 2.0, 0.7]
    @test ret.scores ≈ [60, 73.0, 60]
    @test ret.hours ≈ [2.5, 12.916666666666679, 1.909090909091]
    
    ret = Assignment8.optimize_studying([59.0, 57.5, 57.9], [0.4, 1.2, 1.1], 20, 100.0);
    @test isapprox(ret.grades, zeros(3); atol=1e-6)
    @test ret.scores ≈ [59.0, 57.5, 57.9]
    @test isapprox(ret.hours, zeros(3); atol=1e-6)
    
    ret = Assignment8.optimize_studying([59.0, 62, 65, 68, 71], [0.1, 0.1, 0.1, 0.1, 0.1], 20, 100.0);
    @test isapprox(ret.grades, [0.0, 0.7, 1.0, 1.3, 1.7]; atol=1e-6)
    
    ret = Assignment8.optimize_studying([59.5, 88, 88], [0.1, 0.5, 0.6], 20, 0.1);
    @test ret.grades ≈ [0.7, 3.3, 3.7] || ret.grades ≈ [0.7, 3.7, 3.7]
end
