program gradient_conjugue
!$ use OMP_LIB
  implicit none

! Default Matrix dimension 
#ifndef VAL_N
#define VAL_N 4201
#endif

  integer, parameter           :: n=VAL_N
  integer                      :: i, j, ir, t0, t1, iteration=0
  real(kind=8), dimension(n,n) :: a
  real(kind=8), dimension(n)   :: x, b, pr, z, r, p, q
  real(kind=8)                 :: norme, rho, rho_ancien, alpha, beta, gamma
  real                         :: temps, t_cpu_0, t_cpu_1, t_cpu
!$ integer                     :: nb_tasks

  !$OMP PARALLEL
  !$ nb_tasks = OMP_GET_NUM_THREADS()
  !$OMP END PARALLEL
  !$ print '(//,3X,"cg parallel execution with ",i2," threads")',nb_tasks

  ! Initialisation 
  call random_number(a)
  call random_number(b)

  ! initial CPU time 
  call cpu_time(t_cpu_0)

  ! reference elapsed time .
  call system_clock(count=t0, count_rate=ir)

  !$OMP PARALLEL

  
  !$OMP WORKSHARE
  forall (i=2:n, j=1:n-1, i>j) a(j,i) = a(i,j)

  
  forall (i=1:n) a(i,i) = a(i,i) + 800.0_8

  
  forall (i=1:n) pr(i) = a(i,i)

  ! Initial 
  x(:) = 1.0_8

  ! initial error
  r(:) = b(:) - matmul(a(:,:),x(:))
  !$OMP END WORKSHARE

  ! gradient conjuguate resolution method
  do
     !$OMP SINGLE
     rho = 0.0_8 ; gamma = 0.0_8
     iteration = iteration + 1
     !$OMP END SINGLE

     !$OMP DO REDUCTION(+:rho) SCHEDULE(RUNTIME)
     do i = 1, n
        z(i) = r(i) / pr(i)
        rho = rho + r(i)*z(i)
     end do
     !$OMP END DO

     if (iteration > 1) then
        !$OMP SINGLE
        beta = rho / rho_ancien
        !$OMP END SINGLE
        !$OMP DO SCHEDULE(RUNTIME)
        do i = 1, n
           p(i) = z(i) + beta*p(i)
        end do
        !$OMP END DO
     else
        !$OMP DO SCHEDULE(RUNTIME)
        do i = 1, n
           p(i) = z(i)
        end do
        !$OMP END DO
     end if

     !$OMP DO REDUCTION(+:gamma) SCHEDULE(RUNTIME)
     do i = 1, n
        q(i)  = sum(a(i,:)*p(:))
        gamma = gamma  + p(i)*q(i)
     end do
     !$OMP END DO

     !$OMP SINGLE
     alpha = rho / gamma
     !$OMP END SINGLE

     !$OMP DO SCHEDULE(RUNTIME)
     do i = 1, n
        x(i) = x(i) + alpha * p(i)
        r(i) = r(i) - alpha * q(i)
     end do
     !$OMP END DO

     !convergence test
     !$OMP WORKSHARE
     norme = maxval( abs( r(:) ) )/real(n,kind=8)
     !$OMP END WORKSHARE
     if( (norme <= 10*epsilon(1.0_8)) .or. (iteration >= n) ) exit
     !$OMP SINGLE
     rho_ancien = rho
     !$OMP END SINGLE
  end do
!$OMP END PARALLEL

  ! final elapsed time.
  call system_clock(count=t1, count_rate=ir)
  temps=real(t1 - t0,kind=4)/real(ir,kind=4)

  ! final CPU time 
  call cpu_time(t_cpu_1)
  t_cpu = t_cpu_1 - t_cpu_0

  ! results
  print '(//,3X,"system size      : ",I6,/  &
           &,3X,"Iterations          : ",I4,/       &
           &,3X,"residu     : ",1PE10.3,/  &
           &,3X,"elapsed time      : ",1PE10.3," sec.",/ &
           &,3X,"CPU time          : ",1PE10.3," sec.",//)',n,iteration,norme,temps,t_cpu

end program gradient_conjugue
