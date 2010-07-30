program dependance
!$ use OMP_LIB
  implicit none
  integer, parameter             :: nx=VAL_NX, ny=VAL_NY
  real(kind=8), dimension(nx,ny) :: V, W
  integer                        :: i, j, k, ir, t1, t2
  real                           :: temps, t_cpu_0, t_cpu_1, t_cpu, norme
  !$ integer                     :: nb_taches, rang, imin, imax
  !$ integer, dimension(:), allocatable :: tab_sync

  ! Affichage du nombre de taches actives
  !$OMP PARALLEL
  !$ nb_taches = OMP_GET_NUM_THREADS()
  !$OMP END PARALLEL
  !$ print '(//,3X,"Execution dependance en parallele avec ",i2," threads")',nb_taches

  ! Intialisation des matrices V et W
  do i = 1, nx
    do j = 1, ny
      V(i,j) = real(i+j,kind=8)/(nx+ny)
      W(i,j) = real(i+j,kind=8)/(nx+ny)
    end do
  end do

  ! Temps CPU de calcul initial.
  call cpu_time(t_cpu_0)

  ! Temps elapsed de reference.
  call system_clock(count=t1, count_rate=ir)

  ! Allocation et initialisation du tableau tab_sync
  ! qui gere la synchronisation entre les differents threads
  !$ allocate(tab_sync(0:nb_taches-1))
  !$ tab_sync(0:nb_taches-1) = 1

  ! Boucles avec dependance
  !$OMP PARALLEL private(i,j,rang,imin,imax) shared(tab_sync)
  !$ rang = OMP_GET_THREAD_NUM()
  do j = 2, ny
     ! Synchronisation des threads
     !$     if (rang /= 0) then
     !$        do
     !$OMP FLUSH(tab_sync) 
     !$           if (tab_sync(rang-1)>=tab_sync(rang)+1) exit
     !$        enddo
     !$OMP FLUSH(V)     
     !$     endif
     !$OMP DO SCHEDULE(STATIC)
     do i = 2, nx
        V(i,j) =( V(i,j) + V(i-1,j) + V(i,j-1))/3
     end do
     !$OMP END DO NOWAIT
     ! Mis a jour du tableau tab_sync
     !$     tab_sync(rang) = tab_sync(rang) + 1
     !$OMP FLUSH(tab_sync,V)
  end do
  !$OMP END PARALLEL

  ! Temps elapsed final
  call system_clock(count=t2, count_rate=ir)
  temps=real(t2 - t1,kind=4)/real(ir,kind=4)

  ! Temps CPU de calcul final
  call cpu_time(t_cpu_1)
  t_cpu = t_cpu_1 - t_cpu_0

  ! Verification de la justesse de la parallelisation
  ! Ne pas modifier cette partie SVP
  do j = 2, ny
     do i = 2, nx
        W(i,j) =( W(i,j) + W(i-1,j) + W(i,j-1))/3
     end do
  end do
  norme = 0.0
  do j = 2, ny
     do i = 2, nx
        norme = norme + (V(i,j)-W(i,j))*(V(i,j)-W(i,j))
     end do
  end do

  ! Impression du resultat.
  print '(//,3X,"Valeurs de nx et ny : ",I5,I5/,              &
           & 3X,"Temps elapsed       : ",1PE10.3," sec.",/, &
           & 3X,"Temps CPU           : ",1PE10.3," sec.",/, &
           & 3X,"Norme (PB si /= 0)  : ",1PE10.3,//)', &
           nx,ny,temps,t_cpu,norme
end program dependance
