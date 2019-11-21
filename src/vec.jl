
struct PetscVec #<: AbstractMatrix{PetscScalar}
    vec::Ref{Ptr{Cvoid}}
    function PetscVec()
        vec = Ref{Ptr{Cvoid}}()
        new(vec)
    end
end

function VecCreateSeqWithArray(
        comm::MPI.Comm,
        bs::Int,
        n::Int,
        array::Vector{PetscScalar},
        vec::PetscVec)
    @check_if_loaded
    error = ccall( 
        VecCreateSeqWithArray_ptr[],
            PetscErrorCode,
                (MPI.Comm,
                PetscInt,
                PetscInt,
                Ptr{PetscScalar},
                Ptr{Cvoid}),
            comm, bs, n, array, vec.vec)
    @assert iszero(error)
end

function VecDestroy(vec::PetscVec)
    error = ccall( 
            (:VecDestroy, PETSC_LIB), 
            PetscErrorCode, 
                (Ptr{Cvoid},), 
            vec.vec)
    @assert iszero(error)
end

function VecView(vec::PetscVec,viewer::PetscViewer=C_NULL)
  error = ccall( ( :VecView,  PETSC_LIB), PetscErrorCode, (Ptr{Cvoid},Int64),vec.vec[],viewer);
end
