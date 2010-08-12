program prod_mat
!$ use OMP_LIB
  implicit none

  integer:: m, n
  real(kind=8), pointer:: a(:,:)
  real(kind=8), pointer:: b(:,:)
  real(kind=8), pointer:: c(:,:)
  integer                      :: i, j, k, ir, t1, t2
  real                         :: time, t_cpu_0, t_cpu_1, t_cpu
  character(len=20)::param,param1,param2,output_file


  !$ integer                     :: nb_tasks
  !$OMP PARALLEL
  !$ nb_tasks = OMP_GET_NUM_THREADS()
  !$OMP END PARALLEL
  !$ print '(//,3X,"prod_mat parallel execution with ",i2," threads")',nb_tasks 
  


  call getarg(0,param)
  read(param,*)output_file
  output_file=trim(output_file)//".xml"
  print*, 'output_file=',output_file
     
  call getarg(1,param)
  read(param,*)m
  call getarg(2,param)
  read(param,*)n
  allocate(a(m,n))
  allocate(b(n,m))
  allocate(c(m,m))


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
  time=real(t2 - t1,kind=4)/real(ir,kind=4)

  ! Final CPU Time 
  call cpu_time(t_cpu_1)
  t_cpu = t_cpu_1 - t_cpu_0
  


 ! Store results in XML File

  write(param,*) m
  write(param1,*) n
  !$ write(param2,*) nb_tasks  
  open(10,file=output_file,access = 'append',status='unknown')
  write(10,*)'<benchmark name=''openmp_prod_mat''>'
   write(10,*)'    <parameters>'
    !$ write(10,*) '       <nb_threads>'//trim(adjustl(param2))//'</nb_threads>'
   write(10,*)'    </parameters>'
   write(10,*)'    <results>'
    write(10,'( a ,1PE10.3, a )')'       <elapsed_time unit=''sec''>',time,'</elapsed_time>'
    write(10,'( a ,1PE10.3, a )')'       <cpu_time unit=''sec''>',t_cpu,'</cpu_time>'
   write(10,*)'    </results>'
   write(10,*)'</benchmark>'
  close(10)   
  



  ! Results Print.
  print '(//,3X,"m and n values   : ",I5,I5/,              &
           & 3X,"elapsed time       : ",1PE10.3," sec.",/, &
           & 3X,"CPU time           : ",1PE10.3," sec.",/, &
           & 3X,"partial result    : ",2(1PE10.3,1X)," ... ",2(1PE10.3,1X),//)', &
           m,n,time,t_cpu,c(2,2),c(3,3),c(m-2,m-2),c(m-1,m-1)
  deallocate(a)
  deallocate(b)
  deallocate(c)
end program prod_mat
