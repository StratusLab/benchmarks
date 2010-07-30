program read01

  implicit none
  include 'mpif.h'

  integer, parameter                  :: nb_valeurs=10
  integer                             :: rang,descripteur,code
  integer, dimension(nb_valeurs)      :: valeurs
  integer, dimension(MPI_STATUS_SIZE) :: statut

  call mpi_init(code)
  call mpi_comm_rank(MPI_COMM_WORLD,rang,code)

  call mpi_file_open(MPI_COMM_WORLD,"donnees.dat",MPI_MODE_RDONLY, &
                     MPI_INFO_NULL,descripteur,code)

  call mpi_file_read(descripteur,valeurs,6,MPI_INTEGER,statut,code)
  call mpi_file_read(descripteur,valeurs(7:10),4,MPI_INTEGER,statut,code)

  print *, "Lecture processus",rang,": ",valeurs(:)

  call mpi_file_close(descripteur,code)
  call mpi_finalize(code)

end program read01
