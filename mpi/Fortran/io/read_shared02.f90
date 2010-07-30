program read_shared02

  implicit none
  include 'mpif.h'

  integer                             :: rang,descripteur,code
  integer, parameter                  :: nb_valeurs=10
  integer, dimension(nb_valeurs)      :: valeurs
  integer, dimension(MPI_STATUS_SIZE) :: statut

  call mpi_init(code)
  call mpi_comm_rank(MPI_COMM_WORLD,rang,code)

  call mpi_file_open(MPI_COMM_WORLD,"donnees.dat",MPI_MODE_RDONLY, &
                     MPI_INFO_NULL,descripteur,code)

  call mpi_file_read_shared(descripteur,valeurs,4,MPI_INTEGER,statut,code)
  call mpi_barrier(MPI_COMM_WORLD,code)
  call mpi_file_read_shared(descripteur,valeurs(5:10),6,MPI_INTEGER,statut,code)

  print *, "Lecture processus ",rang, ": ",valeurs(:)

  call mpi_file_close(descripteur,code)
  call mpi_finalize(code)

end program read_shared02
