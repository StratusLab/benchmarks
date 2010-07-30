program jacobi
!$ use OMP_LIB
  implicit none

! Default Matrix Dimension 
#ifndef VAL_N
#define VAL_N 1201
#endif
#ifndef VAL_D
#define VAL_D 800
#endif

  integer, parameter           :: n=VAL_N, diag=VAL_D
  integer                      :: i, j, ir, t0, t1, iteration=0
  real(kind=8), dimension(n,n) :: a
  real(kind=8), dimension(n)   :: x, x_courant, b
  real(kind=8)                 :: norme
  real                         :: temps, t_cpu_0, t_cpu_1, t_cpu
!$ integer                     :: nb_tasks

  !$OMP PARALLEL
  !$ nb_tasks = OMP_GET_NUM_THREADS()
  !$OMP END PARALLEL
  !$ print '(//,3X,"Jacobi parallel Execution with ",i2," threads")',nb_tasks

  ! Initialisation d
  call random_number(a)
  call random_number(b)

  
  forall (i=1:n) a(i,i)=a(i,i)+diag

  ! initial solution 
   x(:) = 1.0_8

  ! Initial  CPU time  
  call cpu_time(t_cpu_0)

  ! reference elapsed time.
  call system_clock(count=t0, count_rate=ir)

  ! Jacobi Resolution Method
  Jaco : do
     iteration = iteration + 1

     !$OMP PARALLEL DO SCHEDULE(RUNTIME)
     do i = 1, n
        x_courant(i) = 0.
        do j = 1, i-1
           x_courant(i) = x_courant(i) + a(i,j)*x(j)
        end do
        do j = i+1, n
           x_courant(i) = x_courant(i) + a(i,j)*x(j)
        end do
        x_courant(i) = (b(i) - x_courant(i))/a(i,i)
     end do
     !$OMP END PARALLEL DO

     ! Convergence test
     norme = maxval( abs(x(:) - x_courant(:)) )/real(n,kind=8)
     if( (norme <= epsilon(1.0_8)) .or. (iteration >= n) ) exit Jaco

     x(:) = x_courant(:)
  end do Jaco

  ! Final elapsed time
  call system_clock(count=t1, count_rate=ir)
  temps=real(t1 - t0,kind=4)/real(ir,kind=4)

  ! Final CPU time 
  call cpu_time(t_cpu_1)
  t_cpu = t_cpu_1 - t_cpu_0

  ! Resultat
  print '(//,3X,"Systeme   : ",I5,/       &
           &,3X,"Iterations          : ",I4,/       &
           &,3X,"Norm               : ",1PE10.3,/  &
           &,3X,"Elapsed Time      : ",1PE10.3," sec.",/ &
           &,3X,"CPU Time          : ",1PE10.3," sec.",//)',n,iteration,norme,temps,t_cpu
end program jacobi
