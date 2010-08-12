program io_at

  implicit none
  include 'mpif.h'
  
 

  integer           :: nb_proc
  integer                :: nb_value,nb_value2
  integer                             :: i,rank,fh,fh2,code,nb_bytes_integer,nb_values,nb_values2
  integer(kind=MPI_OFFSET_KIND)       :: position_file, position_file2
  integer, pointer:: values(:)
  integer, pointer:: values2(:)
  integer, dimension(MPI_STATUS_SIZE) :: statut
  character(len=20)::parm, param, input_file,output_file, xmloutput_file
  real(kind=8)                       :: initial_time,final_time,final_time_max,t_cpu_0, cpu_time_max, t_cpu_1, t_cpu

  call getarg(1,parm)
  read(parm,*)nb_proc
  call getarg(2,input_file)
  read(input_file,*)nb_value
  call getarg(3,output_file)
  read(output_file,*)nb_value2
  
  call getarg(0,param)
  read(param,*)xmloutput_file
  xmloutput_file=trim(xmloutput_file)//".xml"
  
  call mpi_init(code)
  call mpi_comm_rank(MPI_COMM_WORLD,rank,code)
  
  call cpu_time(t_cpu_0)
  initial_time = MPI_WTIME()

  call mpi_type_size(MPI_INTEGER,nb_bytes_integer,code)
  


  nb_values=nb_value*1E6/(nb_proc*nb_bytes_integer) + 1
  nb_values2 = nb_value2*1E6/(nb_proc*nb_bytes_integer) + 1
  
  allocate(values(nb_values))

  allocate(values2(nb_values2))
  values2(:)= (/(i+rank*100,i=1,nb_values2)/)
  
  
  call mpi_file_open(MPI_COMM_WORLD,input_file,MPI_MODE_RDONLY, &
                     MPI_INFO_NULL,fh,code)
  call mpi_file_open(MPI_COMM_WORLD,output_file, &
                     ior(MPI_MODE_WRONLY,MPI_MODE_CREATE),MPI_INFO_NULL, &
                     fh2,code)
  call mpi_type_size(MPI_INTEGER,nb_bytes_integer,code)

  position_file=rank*nb_values*nb_bytes_integer
  position_file2=rank*nb_values2*nb_bytes_integer
 
  call mpi_file_read_at(fh,position_file,values,nb_values, &
                        MPI_INTEGER,statut,code)
  call mpi_file_write_at(fh2,position_file2,values2,nb_values2, &
                         MPI_INTEGER,statut,code)
  call mpi_file_close(fh,code)
  call mpi_file_close(fh2,code)
  deallocate(values)
  deallocate(values2)
  
  final_time = (MPI_WTIME() - initial_time)
  call cpu_time(t_cpu_1)
  t_cpu = t_cpu_1 - t_cpu_0
  call MPI_REDUCE(final_time,final_time_max,1,MPI_DOUBLE_PRECISION,MPI_MAX,0,MPI_COMM_WORLD,code)
  call MPI_REDUCE(t_cpu,cpu_time_max,1,MPI_DOUBLE_PRECISION,MPI_MAX,0,MPI_COMM_WORLD,code)
  print*, "cpu_time_max=",cpu_time_max
  print*, "final_time_max=",final_time_max
  print*, "rank=", rank 
 if (rank == 0) then
   print('("Elapsed time  : ",F6.3," seconds")'), final_time_max
   print('("CPU time  : ",F6.3," seconds")'), cpu_time_max
 endif
   

  ! Store results in XML File
  if (rank == 0) then
   print*, 'xmloutput_file=',xmloutput_file
  write(param,*) nb_proc
  open(10,file=xmloutput_file,access = 'append',status='unknown')
  write(10,*)'<benchmark name=''mpi_io''>'
   write(10,*)'    <parameters>'
    write(10,*) '       <nb_threads>'//trim(adjustl(param))//'</nb_threads>'
   write(10,*)'    </parameters>'
   write(10,*)'    <inputfile>'
    write(10,*) '       <name>'//trim(adjustl(input_file))//'</name>'
    write(10,*) '       <size unit=Mbytes>'//trim(adjustl(input_file))//'</size>'
   write(10,*)'    </inputfile>'
   write(10,*)'    <outputfile>'
    write(10,*) '       <name>'//trim(adjustl(output_file))//'</name>'
    write(10,*) '       <size unit=Mbytes>'//trim(adjustl(output_file))//'</size>'
   write(10,*)'    </outputfile>'
   write(10,*)'    <results>'
    write(10,'( a ,F8.3, a )')'       <elapsed_time unit=''sec''>',final_time_max,'</elapsed_time>'
   write(10,'( a ,F8.3, a )')'       <cpu_time unit=''sec''>',cpu_time_max,'</cpu_time>'
   write(10,*)'    </results>'
   write(10,*)'</benchmark>'
  close(10)
  endif

  call mpi_finalize(code)

end program io_at
