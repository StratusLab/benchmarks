program CommunicationAsynchrone
 implicit none
 include 'mpif.h'
 integer, parameter                 :: na=2256,nb=2200,m=22048,etiquette=1111
 real, dimension(na,na)             :: a
 real, dimension(nb,nb)             :: b
 real, dimension(na)                :: pivota
 real, dimension(nb)                :: pivotb
 real, dimension(m,m)               :: c
 integer                            :: nb_procs,rang,code,info,rcode
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
!*** J'envoi un gros message ...
   call MPI_ISSEND(c,m*m,MPI_REAL,1,etiquette,MPI_COMM_WORLD,rcode,code)
!*** Je calcule : factorisation LU avec LAPACK
   call sgetrf(na, na, a, na, pivota, info)
!*** Ce calcul modifie le contenu du tableau C ...
   call MPI_WAIT(rcode,statut,code)
   c(1:nb,1:nb) = matmul(a(1:nb,1:nb),b)
 elseif (rang == 1) then
!*** Je calcule ...
   call sgetrf(na, na, a, na, pivota, info)
!*** Je recois le gros message ...
   call MPI_IRECV(c,m*m,MPI_REAL,0,etiquette,MPI_COMM_WORLD,rcode,code)
!*** Ce calcul est independant du message recu ...
   call sgetrf(nb, nb, b, nb, pivotb, info)
!*** Ce calcul dépend du message précédent ...
   call MPI_WAIT(rcode,statut,code)   
   a(:,:) = transpose(c(1:na,1:na))
 end if
 temps_fin = (MPI_WTIME() - temps_debut)
 call MPI_REDUCE(temps_fin,temps_fin_max,1,MPI_DOUBLE_PRECISION,MPI_MAX,0,MPI_COMM_WORLD,code)
 if (rang == 0) &
   print('("execution time  : ",F6.3," secondes")'), temps_fin_max
 call MPI_FINALIZE(code)
end program CommunicationAsynchrone
