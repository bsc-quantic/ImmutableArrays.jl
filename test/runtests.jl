using Test
using ImmutableArrays

@testset "Unit tests" begin
    arr = rand(Int, 8, 4)
    view = @view arr[1:4, 3:4]
    t = (1, 2, 3, 4)

    @testset "tests for $(typeof(x))" for x in [arr, view]
        immarr = ImmutableArray(x)

        @test all(Base.splat(==), zip(immarr, x))
        @test parent(immarr) === x

        @testset "ImmutableArray(::ImmutableArray)" begin
            @test ImmutableArray(immarr) === immarr
        end

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

        @testset "convert" begin
            @test convert(ImmutableArray, x) == immarr
            @test convert(ImmutableArray{eltype(x)}, x) == immarr
            @test convert(ImmutableArray{eltype(x),ndims(x)}, x) == immarr
            @test convert(ImmutableArray{eltype(x),ndims(x),typeof(x)}, x) == immarr
        end
    end

    @testset "tests for NTuple{N,Int} where {N}" begin
        immarr = ImmutableArray(t)

        @test all(Base.splat(==), zip(immarr, t))
        @test parent(immarr) == [t...]

        @testset "Iterator interface" begin
            @testset "$f" for f in [Base.IteratorEltype, eltype, length]
                @test f(immarr) == f(t)
            end

            @testset "Base.IteratorSize" begin
                @test Base.IteratorSize(immarr) === Base.HasShape{1}()
            end
        end

        @testset "Indexing interface" begin
            @testset "$f" for f in [firstindex, lastindex]
                @test f(immarr) == f(t)
            end
        end

        @testset "convert" begin
            @test convert(ImmutableVector, t) == immarr
            @test convert(ImmutableVector{eltype(t)}, t) == immarr
            @test convert(ImmutableVector{eltype(t),Vector{eltype(t)}}, t) == immarr
        end
    end
end
