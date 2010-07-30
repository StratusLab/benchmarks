!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -*- Mode: F90 -*- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!! persistant.f90 --- communications persistantes
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

program CommunicationPersistante
 implicit none
 include 'mpif.h'
 integer, parameter                 :: na=2256,nb=2200,m=22048,etiquette=1111
 real, dimension(na,na)             :: a
 real, dimension(nb,nb)             :: b
 real, dimension(na)                :: pivota
 real, dimension(nb)                :: pivotb
 real, dimension(m,m)               :: c
 integer                            :: nb_procs,rang,code,info,rcode,k
 integer, dimension(MPI_STATUS_SIZE):: statut
 real(kind=8)                       :: temps_debut,temps_fin
 real(kind=8)                       :: temps_fin_max_asynchrone
 real(kind=8)                       :: temps_fin_max_persistant
 
 call MPI_INIT(code)
 call MPI_COMM_SIZE(MPI_COMM_WORLD,nb_procs,code)
 call MPI_COMM_RANK(MPI_COMM_WORLD,rang,code)

 call RANDOM_NUMBER(a) ! Generateur de nombres aleatoires entre 0 et 1
 call RANDOM_NUMBER(b)
 call RANDOM_NUMBER(c)

!*** En mode asynchrone...
 temps_debut = MPI_WTIME()
 if (rang == 0) then
   do k = 1, 20
!*** J'envoie un gros message ...
     call MPI_ISSEND(c,m*m,MPI_REAL,1,etiquette,MPI_COMM_WORLD,rcode,code)
!*** Je calcule : factorisation LU avec LAPACK
     call sgetrf(na, na, a, na, pivota, info)
!*** Ce calcul modifie le contenu du tableau C ...
     call MPI_WAIT(rcode,statut,code)
     c(1:nb,1:nb) = matmul(a(1:nb,1:nb),b)
!    print*,c(1,1),c(100,100),c(1000,1000),c(m,m)
   end do
 elseif (rang == 1) then
   do k = 1, 20 
!*** Je calcule ...
     call sgetrf(na, na, a, na, pivota, info)
!*** Je recois le gros message ...
     call MPI_IRECV(c,m*m,MPI_REAL,0,etiquette,MPI_COMM_WORLD,rcode,code)
!*** Ce calcul est independant du message recu ...
     call sgetrf(nb, nb, b, nb, pivotb, info)
!*** Ce calcul depend du message precedent ...
     call MPI_WAIT(rcode,statut,code)   
     a(:,:) = transpose(c(1:na,1:na))
   end do
 end if
 temps_fin = (MPI_WTIME() - temps_debut)
 call MPI_REDUCE(temps_fin,temps_fin_max_asynchrone,1,MPI_DOUBLE_PRECISION,&
      MPI_MAX,0,MPI_COMM_WORLD,code)
 if (rang == 0) &
  print('("Temps en mode asynchrone : ",F8.3," sec.")'), &
            &   temps_fin_max_asynchrone

 call MPI_BARRIER(MPI_COMM_WORLD,code)

 call RANDOM_NUMBER(a) ! Generateur de nombres aleatoires entre 0 et 1
 call RANDOM_NUMBER(b)
 call RANDOM_NUMBER(c)

!*** En mode persistant...
 temps_debut = MPI_WTIME()
 if (rang == 0) then
   call MPI_SSEND_INIT(c,m*m,MPI_REAL,1,etiquette,MPI_COMM_WORLD,rcode,code)
   do k = 1, 20
!*** J'envoie un gros message ...
     call MPI_START(rcode,code)
!*** Je calcule : factorisation LU avec LAPACK
     call sgetrf(na, na, a, na, pivota, info)
!*** Ce calcul modifie le contenu du tableau C ...
     call MPI_WAIT(rcode,statut,code)
     c(1:nb,1:nb) = matmul(a(1:nb,1:nb),b)
!    print*,c(1,1),c(100,100),c(1000,1000),c(m,m)
   end do
   call MPI_REQUEST_FREE(rcode,code)
 elseif (rang == 1) then
   call MPI_RECV_INIT(c,m*m,MPI_REAL,0,etiquette,MPI_COMM_WORLD,rcode,code)
   do k = 1, 20
!*** Je calcule ...
     call sgetrf(na, na, a, na, pivota, info)
!*** Je recois le gros message ...
     call MPI_START(rcode,code)
!*** Ce calcul est independant du message recu ...
     call sgetrf(nb, nb, b, nb, pivotb, info)
!*** Ce calcul depend du message precedent ...
     call MPI_WAIT(rcode,statut,code)   
     a(:,:) = transpose(c(1:na,1:na))
   end do
   call MPI_REQUEST_FREE(rcode,code)
 end if
 temps_fin = (MPI_WTIME() - temps_debut)
 call MPI_REDUCE(temps_fin,temps_fin_max_persistant,1,MPI_DOUBLE_PRECISION,&
      MPI_MAX,0,MPI_COMM_WORLD,code)
 if (rang == 0) &
  print('("Temps en mode persistant : ",F8.3," sec.")'), &
             &  temps_fin_max_persistant
!***

 call MPI_FINALIZE(code)
end program CommunicationPersistante
