PROGRAM Workers
  use mpi
  IMPLICIT NONE

  
  INTEGER, PARAMETER :: n=3
  REAL, DIMENSION(n) :: message
  INTEGER :: rang, nb_procs_ouvriers, nb_procs_chefs, rang_ouvrier,rang_maitre, code
  INTEGER :: inter_comm, intra_comm, nb_procs
  LOGICAL :: drapeau=.true.
  INTEGER, DIMENSION(MPI_STATUS_SIZE) :: statut

  CALL MPI_INIT(code)
  CALL MPI_COMM_SIZE(MPI_COMM_WORLD, nb_procs_ouvriers, code)
  PRINT *,'Nb proc in MPI_COMM_WORLD(Workers) : ',nb_procs_ouvriers

  
  CALL MPI_COMM_GET_PARENT(inter_comm, code)
  IF (inter_comm == MPI_COMM_NULL) PRINT *,'Erreur : pas de processus maitre'

  CALL MPI_COMM_REMOTE_SIZE(inter_comm, nb_procs_chefs, code)
  PRINT *,'Nb proc in inter_comm : ',nb_procs_chefs

  CALL MPI_INTERCOMM_MERGE(inter_comm, drapeau, intra_comm, code)

  CALL MPI_COMM_SIZE(intra_comm, nb_procs, code)
  print *, 'total nb of proc in  intra_comm', nb_procs

  CALL MPI_COMM_RANK(intra_comm, rang, code)
  PRINT *, "My rank  between workers proc : ", rang

  CALL MPI_FINALIZE(code)
END PROGRAM Workers
