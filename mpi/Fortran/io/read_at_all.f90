program read_at_all

  implicit none
  include 'mpif.h'

  integer, parameter                  :: nb_valeurs=10
  integer                             :: rang,descripteur,code,nb_octets_entier
  integer(kind=MPI_OFFSET_KIND)       :: position_fichier_fichier
  integer, dimension(nb_valeurs)      :: valeurs
  integer, dimension(MPI_STATUS_SIZE) :: statut

  call mpi_init(code)
  call mpi_comm_rank(MPI_COMM_WORLD,rang,code)

  call mpi_file_open(MPI_COMM_WORLD,"donnees.dat",MPI_MODE_RDONLY, &
                     MPI_INFO_NULL,descripteur,code)

  call mpi_type_size(MPI_INTEGER,nb_octets_entier,code)

  position_fichier=rang*nb_valeurs*nb_octets_entier

  call mpi_file_read_at_all(descripteur,position_fichier,valeurs,nb_valeurs, &
                            MPI_INTEGER,statut,code)

  print *, "Lecture processus",rang,": ",valeurs(:)

  call mpi_file_close(descripteur,code)
  call mpi_finalize(code)

end program read_at_all
