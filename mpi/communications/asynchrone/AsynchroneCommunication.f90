program CommunicationAsynchrone
 implicit none
 include 'mpif.h'
 integer, parameter                 :: na=1956,nb=900,m=9048,tag=911
 real, dimension(na,na)             :: a
 real, dimension(nb,nb)             :: b
 real, dimension(na)                :: pivota
 real, dimension(nb)                :: pivotb
 real, dimension(m,m)               :: c
 integer                            :: nb_procs,rank,code,info,rcode
 integer, dimension(MPI_STATUS_SIZE):: statut
 real(kind=8)                       :: initial_time,final_time,final_time_max,t_cpu_0, cpu_time_max, t_cpu_1, t_cpu
 character(len=30)::param,param1,param2,output_file

  call getarg(0,param)
  read(param,*)output_file
  output_file=trim(output_file)//".xml"


 call MPI_INIT(code)
 call MPI_COMM_SIZE(MPI_COMM_WORLD,nb_procs,code)
 call MPI_COMM_RANK(MPI_COMM_WORLD,rank,code)
 call RANDOM_NUMBER(a) 
 call RANDOM_NUMBER(b)
 call RANDOM_NUMBER(c)
 
 call cpu_time(t_cpu_0)
 initial_time = MPI_WTIME()
 if (rank == 0) then
   call MPI_ISSEND(c,m*m,MPI_REAL,1,tag,MPI_COMM_WORLD,rcode,code)
   call sgetrf(na, na, a, na, pivota, info)
   call MPI_WAIT(rcode,statut,code)
   c(1:nb,1:nb) = matmul(a(1:nb,1:nb),b)
 elseif (rank == 1) then
   call sgetrf(na, na, a, na, pivota, info)
   call MPI_IRECV(c,m*m,MPI_REAL,0,tag,MPI_COMM_WORLD,rcode,code)
   call sgetrf(nb, nb, b, nb, pivotb, info)
   call MPI_WAIT(rcode,statut,code)   
   a(:,:) = transpose(c(1:na,1:na))
 end if
 final_time = (MPI_WTIME() - initial_time)
 call cpu_time(t_cpu_1)
 t_cpu = t_cpu_1 - t_cpu_0
 call MPI_REDUCE(final_time,final_time_max,1,MPI_DOUBLE_PRECISION,MPI_MAX,0,MPI_COMM_WORLD,code)
 call MPI_REDUCE(t_cpu,cpu_time_max,1,MPI_DOUBLE_PRECISION,MPI_MAX,0,MPI_COMM_WORLD,code)
 if (rank == 0) then 
   print('("Elapsed time  : ",F8.3," seconds")'), final_time_max
   print('("CPU time  : ",F8.3," seconds")'), cpu_time_max
 endif
 
 ! Store results in XML File
  if (rank == 0) then
   print*, 'output_file=',output_file
  write(param2,*) nb_procs
  open(10,file=output_file,access = 'append',status='unknown')
  write(10,*)'<benchmark name=''mpi_asynchrone''>'
   write(10,*)'    <parameters>'
    write(10,*) '       <nb_threads>'//trim(adjustl(param2))//'</nb_threads>'
   write(10,*)'    </parameters>'
   write(10,*)'    <results>'
    write(10,'( a ,F6.3, a )')'       <elapsed_time unit=''sec''>',final_time_max,'</elapsed_time>'
   write(10,'( a ,F6.3, a )')'       <cpu_time unit=''sec''>',cpu_time_max,'</cpu_time>'
   write(10,*)'    </results>'
   write(10,*)'</benchmark>'
  close(10)
  endif

 call MPI_FINALIZE(code)
end program CommunicationAsynchrone
