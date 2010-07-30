PROGRAM Serveur
  use mpi
  IMPLICIT NONE

  INTEGER, PARAMETER                  :: n=3
  REAL, DIMENSION(n)                  :: message
  INTEGER                             :: inter_comm, code
  INTEGER                             :: rang, rang_serveur, rang_client
  CHARACTER(LEN=MPI_MAX_PORT_NAME)    :: nom_de_port
  INTEGER, DIMENSION(MPI_STATUS_SIZE) :: statut

  CALL MPI_INIT(code)
  CALL MPI_COMM_RANK(MPI_COMM_WORLD, rang, code)

  rang_serveur=0
  IF(rang == rang_serveur) THEN
      !... Fournir un nom  de port pour l'etablissement d'un lien de communication.
      CALL MPI_OPEN_PORT(MPI_INFO_NULL, nom_de_port, code)
      PRINT *,"Nom du port de connexion : ", nom_de_port
      CALL MPI_PUBLISH_NAME("service", MPI_INFO_NULL, nom_de_port, code)
  END IF

  PRINT *,"Je suis le processus serveur de rang : ",rang

  !... Le processus "rang_serveur" est en attente de connexion.
  CALL MPI_COMM_ACCEPT(nom_de_port, MPI_INFO_NULL, rang_serveur, &
                       MPI_COMM_WORLD, inter_comm, code)

  PRINT *, "Connexion etablie avec le client..."
  CALL MPI_COMM_DISCONNECT(inter_comm,code)

  IF(rang == rang_serveur) THEN
     CALL RANDOM_NUMBER(message)
     rang_client=0
     CALL MPI_SENDRECV_REPLACE(message, n, MPI_REAL, rang_client, 1111, &
                               rang_client, 1111, inter_comm, statut, code)
     PRINT *, "Mon rang : ",rang_serveur," message(:) : ", message(:)
     CALL MPI_UNPUBLISH_NAME("service", MPI_INFO_NULL, nom_de_port, code)
     CALL MPI_CLOSE_PORT(nom_de_port, code)
  END IF

  
  CALL MPI_FINALIZE(code)
END PROGRAM Serveur
