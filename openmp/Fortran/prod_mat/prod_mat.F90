program prod_mat
!$ use OMP_LIB
  implicit none

! Default matrix dimension
#ifndef VAL_M
#define VAL_M 701
#endif
#ifndef VAL_N
#define VAL_N 801
#endif
  
  integer, parameter           :: m=VAL_M, n=VAL_N
  real(kind=8), dimension(m,n) :: a
  real(kind=8), dimension(n,m) :: b
  real(kind=8), dimension(m,m) :: c
  integer                      :: i, j, k, ir, t1, t2
  real                         :: temps, t_cpu_0, t_cpu_1, t_cpu
!$ integer                     :: nb_tasks

  !$OMP PARALLEL
  !$ nb_tasks = OMP_GET_NUM_THREADS()
  !$OMP END PARALLEL
  !$ print '(//,3X,"Execution prod_mat en parallele avec ",i2," threads")',nb_tasks

  ! Initial CPU Time 
  call cpu_time(t_cpu_0)

  ! Reference elapsed time.
  call system_clock(count=t1, count_rate=ir)

  !$OMP PARALLEL
  ! Matrix Intialisation.
  !$OMP DO SCHEDULE(RUNTIME)
  do j = 1, n
    do i = 1, m
      a(i,j) = real(i+j,kind=8)
    end do
  end do
  !$OMP END DO NOWAIT

  !$OMP DO SCHEDULE(RUNTIME)
  do j = 1, m
    do i = 1, n
      b(i,j) = real(i-j,kind=8)
    end do
  end do
  !$OMP END DO NOWAIT

  !$OMP DO SCHEDULE(RUNTIME)
  do j = 1, m
    do i = 1, m
      c(i,j) = 0.0_8
    end do
  end do
  !$OMP END DO

  ! Matrix product
  !$OMP DO SCHEDULE(RUNTIME)
  do j = 1, m
    do k = 1, n
      do i = 1, m
        c(i,j) = c(i,j) + a(i,k) * b(k,j)
      end do
    end do
  end do
  !$OMP END DO
  !$OMP END PARALLEL

  ! Final elapsed time
  call system_clock(count=t2, count_rate=ir)
  temps=real(t2 - t1,kind=4)/real(ir,kind=4)

  ! Final CPU Time 
  call cpu_time(t_cpu_1)
  t_cpu = t_cpu_1 - t_cpu_0

  ! Results Print.
  print '(//,3X,"m and n values   : ",I5,I5/,              &
           & 3X,"elapsed time       : ",1PE10.3," sec.",/, &
           & 3X,"CPU time           : ",1PE10.3," sec.",/, &
           & 3X,"partial result    : ",2(1PE10.3,1X)," ... ",2(1PE10.3,1X),//)', &
           m,n,temps,t_cpu,c(2,2),c(3,3),c(m-2,m-2),c(m-1,m-1)
end program prod_mat
