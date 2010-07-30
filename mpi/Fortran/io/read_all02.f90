program read_all02

  implicit none
  include 'mpif.h'

  integer, parameter                  :: nb_valeurs=10
  integer                             :: rang,descripteur,indice1,indice2,code
  integer, dimension(nb_valeurs)      :: valeurs=0
  integer, dimension(MPI_STATUS_SIZE) :: statut

  call mpi_init(code)
  call mpi_comm_rank(MPI_COMM_WORLD,rang,code)

  call mpi_file_open(MPI_COMM_WORLD,"donnees.dat",MPI_MODE_RDONLY, &
                     MPI_INFO_NULL,descripteur,code)

  if (rang == 0) then
     indice1=3
     indice2=6
  else
     indice1=5
     indice2=9
  end if

  call mpi_file_read_all(descripteur,valeurs(indice1:indice2), &
                         indice2-indice1+1,MPI_INTEGER,statut,code)

  print *, "Lecture processus",rang,": ",valeurs(:)

  call mpi_file_close(descripteur,code)
  call mpi_finalize(code)

end program read_all02
