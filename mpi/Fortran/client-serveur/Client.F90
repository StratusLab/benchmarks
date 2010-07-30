
PROGRAM Client
  use mpi
  IMPLICIT NONE

  
  INTEGER, PARAMETER                  :: n=3
  REAL, DIMENSION(n)                  :: message
  INTEGER                             :: inter_comm, code
  INTEGER                             :: rang, rang_client, rang_serveur
  LOGICAL                             :: drapeau=.false.
  CHARACTER(LEN=MPI_MAX_PORT_NAME)    :: nom_de_port
  INTEGER, DIMENSION(MPI_STATUS_SIZE) :: statut

  CALL MPI_INIT(code)
  CALL MPI_COMM_RANK(MPI_COMM_WORLD, rang, code)

  rang_client=0
  
  PRINT *,"Je suis le processus client de rang : ",rang

  IF(rang == rang_client) THEN 
    PRINT *,"Calling MPI LOOKUP NAME: "
    CALL MPI_LOOKUP_NAME("service", MPI_INFO_NULL, nom_de_port, code)
    PRINT *,"Nom du port de connexion (Client) : ", nom_de_port
  END IF

  PRINT *,"Je suis le processus client de rang : ",rang

  CALL MPI_COMM_CONNECT(nom_de_port, MPI_INFO_NULL, rang_client, &
                        MPI_COMM_WORLD, inter_comm, code)
  PRINT *, "Connexion etablie avec le serveur..."

  IF (rang == rang_client) THEN
    CALL RANDOM_NUMBER(message)
    rang_serveur=0
    CALL MPI_SENDRECV_REPLACE(message, n, MPI_REAL, rang_serveur, 1111, &
                              rang_serveur, 1111, inter_comm, statut, code)
    print *, "Mon rang est : ",rang_client," message(:) : ", message(:)
  END IF

  CALL MPI_COMM_DISCONNECT(inter_comm, code)
  CALL MPI_FINALIZE(code)
END PROGRAM Client
