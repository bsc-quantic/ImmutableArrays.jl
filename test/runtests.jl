using Test
using ImmutableArrays

@testset "Unit tests" begin
    arr = rand(Int, 8, 4)
    view = @view arr[1:4, 3:4]

    @testset "tests for $(typeof(x))" for x in [arr, view]
        immarr = ImmutableArray(x)

        @test all(splat(==), zip(immarr, x))
        @test parent(immarr) === x

        @testset "AbstractArray interface" begin
            @testset "$f" for f in [size, axes]
                @test f(immarr) == f(x)
            end
        end

        @testset "StridedArrays interface" begin
            @testset "$f" for f in [strides, y -> Base.unsafe_convert(Ptr{eltype(x)}, y), y -> Base.elsize(typeof(y))]
                @test f(immarr) == f(x)
            end
        end

        @testset "Iterator interface" begin
            @testset "$f" for f in [Base.IteratorEltype, Base.IteratorSize, eltype, length]
                @test f(immarr) == f(x)
            end
        end

        @testset "Indexing interface" begin
            @testset "$f" for f in [firstindex, lastindex]
                @test f(immarr) == f(x)
            end
        end
    end
end
