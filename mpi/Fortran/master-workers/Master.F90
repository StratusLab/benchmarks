
PROGRAM Master
  use mpi
  IMPLICIT NONE

  INTEGER, PARAMETER :: n=3
  REAL, DIMENSION(n) :: message
  INTEGER :: rang, nb_procs_chefs, nb_procs_activer, rang_maitre=0, rang_ouvrier
  INTEGER :: inter_comm, intra_comm, nb_procs_total, nb_procs, code
  LOGICAL :: drapeau
  INTEGER, DIMENSION(MPI_STATUS_SIZE) :: statut

  CALL MPI_INIT(code)
  CALL MPI_COMM_SIZE(MPI_COMM_WORLD, nb_procs_chefs, code)
  PRINT *,'Nb procs in MPI_COMM_WORLD(Master) : ',nb_procs_chefs

  nb_procs_activer = 3

  rang_maitre=0

  CALL MPI_COMM_SPAWN("Workers", MPI_ARGV_NULL,nb_procs_activer,MPI_INFO_NULL, &
                      rang_maitre, MPI_COMM_WORLD, inter_comm, MPI_ERRCODES_IGNORE, code)

  drapeau=.false.
  CALL MPI_INTERCOMM_MERGE(inter_comm, drapeau, intra_comm, code)

  
  CALL MPI_COMM_SIZE(intra_comm, nb_procs, code)
  PRINT *,'procs nb in  intra_comm(Master) : ',nb_procs

  
  CALL MPI_COMM_RANK(intra_comm, rang, code)
  PRINT *, "My rank between Master proc : ", rang

  CALL MPI_FINALIZE(code)
END PROGRAM Master
