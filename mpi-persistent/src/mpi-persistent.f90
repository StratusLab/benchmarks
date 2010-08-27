program mpi_persistent
 implicit none
 include 'mpif.h'
 integer, parameter                 :: na=2256,nb=2200,m=22048,tag=1111
 real, dimension(na,na)             :: a
 real, dimension(nb,nb)             :: b
 real, dimension(na)                :: pivota
 real, dimension(nb)                :: pivotb
 real, dimension(m,m)               :: c
 integer                            :: nb_procs,rank,code,info,rcode,k
 integer, dimension(MPI_STATUS_SIZE):: statut
 real(kind=8)                       :: initial_time,final_time
 real(kind=8)                       :: final_time_max_asynchrone
 real(kind=8)                       :: final_time_max_persistant, t_cpu_0, cpu_time_max_persistant, cpu_time_max_asynchrone, &
                                       t_cpu_1, t_cpu
 character(len=30)::param,param1,param2,output_file
 
  output_file="mpi-persistent.xml"


 call MPI_INIT(code)
 call MPI_COMM_SIZE(MPI_COMM_WORLD,nb_procs,code)
 call MPI_COMM_RANK(MPI_COMM_WORLD,rank,code)

 call RANDOM_NUMBER(a) 
 call RANDOM_NUMBER(b)
 call RANDOM_NUMBER(c)
 
 call cpu_time(t_cpu_0)
 initial_time = MPI_WTIME()
 if (rank == 0) then
   do k = 1, 20
     call MPI_ISSEND(c,m*m,MPI_REAL,1,tag,MPI_COMM_WORLD,rcode,code)
     call sgetrf(na, na, a, na, pivota, info)
     call MPI_WAIT(rcode,statut,code)
     c(1:nb,1:nb) = matmul(a(1:nb,1:nb),b)
   end do
 elseif (rank == 1) then
   do k = 1, 20 
     call sgetrf(na, na, a, na, pivota, info)
     call MPI_IRECV(c,m*m,MPI_REAL,0,tag,MPI_COMM_WORLD,rcode,code)
     call sgetrf(nb, nb, b, nb, pivotb, info)
     call MPI_WAIT(rcode,statut,code)   
     a(:,:) = transpose(c(1:na,1:na))
   end do
 end if
 final_time = (MPI_WTIME() - initial_time)
 call cpu_time(t_cpu_1)
 t_cpu = t_cpu_1 - t_cpu_0
 call MPI_REDUCE(t_cpu,cpu_time_max_asynchrone,1,MPI_DOUBLE_PRECISION,MPI_MAX,0,MPI_COMM_WORLD,code)
 call MPI_REDUCE(final_time,final_time_max_asynchrone,1,MPI_DOUBLE_PRECISION,&
      MPI_MAX,0,MPI_COMM_WORLD,code)
 if (rank == 0) then
  print('("asynchrone mode, Elapsed time : ",F8.3," sec.")'),  final_time_max_asynchrone
  print('("asynchrone mode, CPU time  : ",F8.3," seconds")'), cpu_time_max_asynchrone
 endif
 call MPI_BARRIER(MPI_COMM_WORLD,code)

 call RANDOM_NUMBER(a) 
 call RANDOM_NUMBER(b)
 call RANDOM_NUMBER(c)

 call cpu_time(t_cpu_0)
 initial_time = MPI_WTIME()
 if (rank == 0) then
   call MPI_SSEND_INIT(c,m*m,MPI_REAL,1,tag,MPI_COMM_WORLD,rcode,code)
   do k = 1, 20
     call MPI_START(rcode,code)
     call sgetrf(na, na, a, na, pivota, info)
     call MPI_WAIT(rcode,statut,code)
     c(1:nb,1:nb) = matmul(a(1:nb,1:nb),b)
   end do
   call MPI_REQUEST_FREE(rcode,code)
 elseif (rank == 1) then
   call MPI_RECV_INIT(c,m*m,MPI_REAL,0,tag,MPI_COMM_WORLD,rcode,code)
   do k = 1, 20
     call sgetrf(na, na, a, na, pivota, info)
     call MPI_START(rcode,code)
     call sgetrf(nb, nb, b, nb, pivotb, info)
     call MPI_WAIT(rcode,statut,code)   
     a(:,:) = transpose(c(1:na,1:na))
   end do
   call MPI_REQUEST_FREE(rcode,code)
 end if
 final_time = (MPI_WTIME() - initial_time)
 call cpu_time(t_cpu_1)
 t_cpu = t_cpu_1 - t_cpu_0
 call MPI_REDUCE(final_time,final_time_max_persistant,1,MPI_DOUBLE_PRECISION,&
      MPI_MAX,0,MPI_COMM_WORLD,code)
 call MPI_REDUCE(t_cpu,cpu_time_max_persistant,1,MPI_DOUBLE_PRECISION,MPI_MAX,0,MPI_COMM_WORLD,code)
 if (rank == 0) then
  print('("persistent mode, Elapsed time  : ",F8.3," sec.")'), final_time_max_persistant
  print('("persistent mode, CPU time  : ",F8.3," sec.")'), cpu_time_max_persistant
 endif

  ! Store results in XML File
  if (rank == 0) then
   print*, 'output_file=',output_file
  write(param2,*) nb_procs
  open(10,file=output_file,access = 'append',status='unknown')
  write(10,*)'<benchmark name=''mpi_persistant''>'
   write(10,*)'    <parameters>'
    write(10,*) '       <nb_threads>'//trim(adjustl(param2))//'</nb_threads>'
   write(10,*)'    </parameters>'
   write(10,*)'    <results>'
    write(10,'( a ,F8.3, a )')'       <elapsed_time unit=''sec''>',final_time_max_asynchrone,'</elapsed_time>'
   write(10,'( a ,F8.3, a )')'       <cpu_time unit=''sec''>',cpu_time_max_asynchrone,'</cpu_time>'
   write(10,*)'    </results>'
   write(10,*)'</benchmark>'
   write(10,*)'<benchmark name=''mpi_asynchronous''>'
   write(10,*)'    <parameters>'
    write(10,*) '       <nb_threads>'//trim(adjustl(param2))//'</nb_threads>'
   write(10,*)'    </parameters>'
   write(10,*)'    <results>'
    write(10,'( a ,F8.3, a )')'       <elapsed_time unit=''sec''>',final_time_max_persistant,'</elapsed_time>'
   write(10,'( a ,F8.3, a )')'       <cpu_time unit=''sec''>',cpu_time_max_persistant,'</cpu_time>'
   write(10,*)'    </results>'
   write(10,*)'</benchmark>'
  close(10)
  endif 

 call MPI_FINALIZE(code)
end program mpi_persistent
