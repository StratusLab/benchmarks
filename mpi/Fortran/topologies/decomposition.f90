!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -*- Mode: F90 -*- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!! decomposition.f90 --- Creation d'une topologie cartesienne comportant 
!!                       4 domaines suivant x et 2 suivant y, periodique en y.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


PROGRAM decomposition
  IMPLICIT NONE
  INCLUDE 'mpif.h'
  INTEGER                  :: rang_ds_topo,nb_procs
  INTEGER                  :: code,comm2d
  INTEGER,DIMENSION(4)     :: voisin
  INTEGER,PARAMETER        :: N=1,  E=2, S=3, W=4
  INTEGER,PARAMETER        :: ndims =2
  INTEGER,DIMENSION(ndims) :: dims
  LOGICAL,DIMENSION(ndims) :: periods
  INTEGER,DIMENSION(ndims) :: coords
  LOGICAL                  :: reorganisation

  !Initialisation de MPI
  CALL MPI_INIT(code)

  !Connaitre le nombre total de processus 
  CALL MPI_COMM_SIZE(MPI_COMM_WORLD,nb_procs,code)

  !Connaitre le nombre de processus suivant x et y
  dims(:) = 0
  CALL MPI_DIMS_CREATE(nb_procs,ndims,dims,code)

  !Creation de la grille 2D periodique en y
  periods(1)= .false.
  periods(2)= .true.
  reorganisation = .false.

  CALL MPI_CART_CREATE(MPI_COMM_WORLD,ndims,dims,periods,reorganisation,&
       comm2d,code)

  !Initialisation du tableau voisin a la valeur MPI_PROC_NULL
  voisin(:) = MPI_PROC_NULL

  !Recherche de mes voisins Ouest et Est
  CALL MPI_CART_SHIFT(comm2d,0,1,voisin(W),voisin(E),code)

  !Recherche de mes voisins Sud et Nord
  CALL MPI_CART_SHIFT(comm2d,1,1,voisin(S),voisin(N),code)
  
  !Connaitre mes coordonnées dans la topologie
  CALL MPI_COMM_RANK(comm2d,rang_ds_topo,code)
  CALL MPI_CART_COORDS(comm2d,rang_ds_topo,ndims,coords,code)
  
  print *,"processeur : ",rang_ds_topo,"mes processeurs voisins sont ",voisin       

  !Desactivation de MPI
  CALL MPI_FINALIZE(code)

END PROGRAM decomposition
