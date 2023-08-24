module ImmutableArrays

export ImmutableVector, ImmutableMatrix, ImmutableArray

struct ImmutableArray{T,N,A<:AbstractArray{T,N}} <: AbstractArray{T,N}
    parent::A

    ImmutableArray(parent::A) where {T,N,A<:AbstractArray{T,N}} = new{T,N,A}(parent)
end

const ImmutableVector{T,A} = ImmutableArray{T,1,A}
const ImmutableMatrix{T,A} = ImmutableArray{T,2,A}

Base.parent(arr::ImmutableArray) = arr.parent
Base.parent(::Type{ImmutableArray{T,N,A}}) where {T,N,A} = A

Base.size(arr::ImmutableArray) = size(parent(arr))
Base.@propagate_inbounds Base.getindex(arr::ImmutableArray, I...) = getindex(parent(arr), I...)
Base.IndexStyle(IA::Type{<:ImmutableArray}) = IndexStyle(parent(IA))

Base.strides(arr::ImmutableArray) = strides(parent(arr))
Base.unsafe_convert(P::Type{Ptr{T}}, arr::ImmutableArray) where {T} = Base.unsafe_convert(P, parent(arr))
Base.elsize(IA::Type{<:ImmutableArray}) = Base.elsize(parent(IA))

Base.convert(::Type{ImmutableArray{T,N,A}}, arr::A) where {T,N,A<:AbstractArray{T,N}} = ImmutableArray(arr)
Base.convert(::Type{ImmutableArray{T,N}}, arr::A) where {T,N,A<:AbstractArray{T,N}} = ImmutableArray(arr)
Base.convert(::Type{ImmutableArray{T}}, arr::A) where {T,A<:AbstractArray{T}} = ImmutableArray(arr)
Base.convert(::Type{ImmutableArray}, arr::A) where {A<:AbstractArray} = ImmutableArray(arr)

end
