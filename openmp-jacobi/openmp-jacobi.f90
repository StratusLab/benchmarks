program jacobi
!$ use OMP_LIB
  implicit none

! Default Matrix Dimension 

  integer, parameter           :: n=1201, diag=800
  integer                      :: i, j, ir, t0, t1, iteration=0
  real(kind=8), dimension(n,n) :: a
  real(kind=8), dimension(n)   :: x, x_current, b
  real(kind=8)                 :: norme
  real(kind=8)                 :: norm
  real                         :: time, t_cpu_0, t_cpu_1, t_cpu
  character(len=20)::param,param1,param2,output_file
  !$ integer                     :: nb_tasks
  
  output_file="openmp-jacobi.xml"

   
  
 



  !$OMP PARALLEL
  !$ nb_tasks = OMP_GET_NUM_THREADS()
  !$OMP END PARALLEL
  !$ print '(//,3X,"Jacobi parallel Execution with ",i2," threads")',nb_tasks

  ! Initialisation 
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
        x_current(i) = 0.
        do j = 1, i-1
           x_current(i) = x_current(i) + a(i,j)*x(j)
        end do
        do j = i+1, n
           x_current(i) = x_current(i) + a(i,j)*x(j)
        end do
        x_current(i) = (b(i) - x_current(i))/a(i,i)
     end do
     !$OMP END PARALLEL DO

     ! Convergence test
     norm = maxval( abs(x(:) - x_current(:)) )/real(n,kind=8)
     if( (norm <= epsilon(1.0_8)) .or. (iteration >= n) ) exit Jaco

     x(:) = x_current(:)
  end do Jaco

  ! Final elapsed time
  call system_clock(count=t1, count_rate=ir)
  time=real(t1 - t0,kind=4)/real(ir,kind=4)

  ! Final CPU time 
  call cpu_time(t_cpu_1)
  t_cpu = t_cpu_1 - t_cpu_0


  ! Store results in XML File

  print*, 'output_file=',output_file
  write(param,*) iteration
  write(param1,*) n
  !$ write(param2,*) nb_tasks  
  open(10,file=output_file,access = 'append',status='unknown')
  write(10,*)'<benchmark name=''openmp_jacobi''>'
   write(10,*)'    <parameters>'
    !$ write(10,*) '       <nb_threads>'//trim(adjustl(param2))//'</nb_threads>'
    write(10,*) '       <nb_iterations>'//trim(adjustl(param))//'</nb_iterations>'
   write(10,*)'    </parameters>'
   write(10,*)'    <results>'
    write(10,'( a ,1PE10.3, a )')'       <elapsed_time unit=''sec''>',time,'</elapsed_time>'
    write(10,'( a ,1PE10.3, a )')'       <cpu_time unit=''sec''>',t_cpu,'</cpu_time>'
   write(10,*)'    </results>'
   write(10,*)'</benchmark>'
  close(10)

  ! Resultat
  print '(//,3X,"Systeme   : ",I5,/       &
           &,3X,"Iterations          : ",I4,/       &
           &,3X,"Norm               : ",1PE10.3,/  &
           &,3X,"Elapsed Time      : ",1PE10.3," sec.",/ &
           &,3X,"CPU Time          : ",1PE10.3," sec.",//)',n,iteration,norm,time,t_cpu

end program jacobi
