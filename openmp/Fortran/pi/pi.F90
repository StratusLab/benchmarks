program pi

!$ use OMP_LIB
  implicit none

! Dimension par defaut de la taille des matrices
#ifndef VAL_N
#define VAL_N 30000000
#endif

  integer, parameter :: n=VAL_N
  real(kind=8)       :: f, x, a, h, Pi_estime, Pi_calcule, ecart
  real               :: temps, t_cpu_0, t_cpu_1, t_cpu
  integer            :: i, ir, t1, t2,k
!$ integer           :: nb_tasks
 
  ! Fonction instruction a integrer
  f(a) = 4.0_8 / ( 1.0_8 + a*a )

  !$OMP PARALLEL
  !$ nb_tasks = OMP_GET_NUM_THREADS()
  !$OMP END PARALLEL
  !$ print '(//,3X,"pi parallel execution with ",i2," threads")',nb_tasks

  ! Estimated value of  Pi
  Pi_estime = acos(-1.0_8)

  ! Interval Length.
  h = 1.0_8 / real(n,kind=8)

  ! initial CPU time
  call cpu_time(t_cpu_0)

  ! reference elapsed time.
  call system_clock(count=t1, count_rate=ir)

  do k=1,1
  ! Pi claculus
  Pi_calcule = 0.0_8
  !$OMP PARALLEL DO PRIVATE(x) REDUCTION(+ : Pi_calcule) SCHEDULE(RUNTIME)
  do i = 1, n
    x = h * ( real(i,kind=8) - 0.5_8 )
    Pi_calcule = Pi_calcule + f(x)
  end do
  !$OMP END PARALLEL DO
  Pi_calcule = h * Pi_calcule
  enddo
  ! final  elapsed time 
  call system_clock(count=t2, count_rate=ir)
  temps=real(t2 - t1,kind=4)/real(ir,kind=4)

  ! final  CPU time 
  call cpu_time(t_cpu_1)
  t_cpu = t_cpu_1 - t_cpu_0

  ! Error.
  ecart = abs(Pi_estime - Pi_calcule)

  ! results.
  print '(//,3X,"Nb intervals       : ",I10,/  &
           &,3X,"| Pi_estimated - Pi_calculated | : ",1PE10.3,/  &
           &,3X,"Elapsed time             : ",1PE10.3," sec.",/ &
           &,3X,"CPU time                  : ",1PE10.3," sec.",//)',n,ecart,temps, t_cpu
end program pi
