program CommunicationSynchrone
 implicit none
 include 'mpif.h'
 integer, parameter                 :: na=256, nb=200,m=2048, etiquette=1111
 real, dimension(na,na)             :: a
 real, dimension(nb,nb)             :: b
 real, dimension(na)                :: pivota
 real, dimension(nb)                :: pivotb
 real, dimension(m,m)               :: c
 integer                            :: nb_procs, rang, code, info, rcode
 integer, dimension(MPI_STATUS_SIZE):: statut
 real(kind=8)                       :: temps_debut,temps_fin,temps_fin_max
 
 call MPI_INIT(code)
 call MPI_COMM_SIZE(MPI_COMM_WORLD,nb_procs,code)
 call MPI_COMM_RANK(MPI_COMM_WORLD,rang,code)
 call RANDOM_NUMBER(a) ! Generateur de nombres aleatoires entre 0 et 1
 call RANDOM_NUMBER(b)
 call RANDOM_NUMBER(c)

 temps_debut = MPI_WTIME()
 if (rang == 0) then
!*** send message...
   call MPI_SSEND(c,m*m,MPI_REAL,1,etiquette,MPI_COMM_WORLD,code)
!*** factorisation LU using LAPACK
   call sgetrf(na, na, a, na, pivota, info)
!*** modify C table ...
   c(1:nb,1:nb) = matmul(a(1:nb,1:nb),b)
 elseif (rang == 1) then
!*** calcul ...
   call sgetrf(na, na, a, na, pivota, info)
!*** receive the  message ...
   call MPI_RECV(c,m*m,MPI_REAL,0,etiquette,MPI_COMM_WORLD,statut,code)
!*** calcul  ...
   a(:,:) = transpose(c(1:na,1:na))
!*** calcul 
   call sgetrf(nb, nb, b, nb, pivotb, info)
 end if
 temps_fin = (MPI_WTIME() - temps_debut)
 call MPI_REDUCE(temps_fin,temps_fin_max,1,MPI_DOUBLE_PRECISION,MPI_MAX,0,MPI_COMM_WORLD,code)
 if (rang == 0) &
   print('("Execution time  : ",F6.3," seconds")'), temps_fin_max
 call MPI_FINALIZE(code)
end program CommunicationSynchrone
