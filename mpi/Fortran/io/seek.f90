program seek

  implicit none
  include 'mpif.h'

  integer, parameter                  :: nb_valeurs=10
  integer                             :: rang,descripteur,nb_octets_entier,code
  integer(kind=MPI_OFFSET_KIND)       :: position_fichier
  integer, dimension(nb_valeurs)      :: valeurs
  integer, dimension(MPI_STATUS_SIZE) :: statut

  call mpi_init(code)
  call mpi_comm_rank(MPI_COMM_WORLD,rang,code)

  call mpi_file_open(MPI_COMM_WORLD,"data.dat",MPI_MODE_RDONLY, &
                     MPI_INFO_NULL,descripteur,code)

  call mpi_file_read(descripteur,valeurs,3,MPI_INTEGER,statut,code)

  call mpi_type_size(MPI_INTEGER,nb_octets_entier,code)
  position_fichier=8*nb_octets_entier
  call mpi_file_seek(descripteur,position_fichier,MPI_SEEK_CUR,code)
  call mpi_file_read(descripteur,valeurs(4:6),3,MPI_INTEGER,statut,code)

  position_fichier=4*nb_octets_entier
  call mpi_file_seek(descripteur,position_fichier,MPI_SEEK_SET,code)
  call mpi_file_read(descripteur,valeurs(7:10),4,MPI_INTEGER,statut,code)

  print *, "Lecture processus",rang,":",valeurs(:)

  call mpi_file_close(descripteur,code)
  call mpi_finalize(code)

end program seek
