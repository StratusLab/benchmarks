program open01

  implicit none
  include 'mpif.h'

  integer           :: descripteur,code

  call mpi_init(code)

  call mpi_file_open(MPI_COMM_WORLD,"fichier.txt", &
                     ior(MPI_MODE_RDWR,MPI_MODE_CREATE),MPI_INFO_NULL, &
                     descripteur,code)

  call mpi_file_close(descripteur,code)
  call mpi_finalize(code)

end program open01
