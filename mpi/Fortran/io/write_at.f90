program write_at

  implicit none
  include 'mpif.h'

  integer, parameter                  :: nb_valeurs=10
  integer                             :: i,rang,descripteur,code,nb_octets_entier
  integer(kind=MPI_OFFSET_KIND)       :: position_fichier
  integer, dimension(nb_valeurs)      :: valeurs
  integer, dimension(MPI_STATUS_SIZE) :: statut


  call mpi_init(code)
  call mpi_comm_rank(MPI_COMM_WORLD,rang,code)

  valeurs(:)= (/(i+rang*100,i=1,nb_valeurs)/)
  print *, "Processus",rang, ": ",valeurs(:)

  call mpi_file_open(MPI_COMM_WORLD,"data.dat", &
                     ior(MPI_MODE_WRONLY,MPI_MODE_CREATE),MPI_INFO_NULL, &
                     descripteur,code)

  call mpi_type_size(MPI_INTEGER,nb_octets_entier,code)

  position_fichier=rang*nb_valeurs*nb_octets_entier

  call mpi_file_write_at(descripteur,position_fichier,valeurs,nb_valeurs, &
                         MPI_INTEGER,statut,code)

  call mpi_file_close(descripteur,code)
  call mpi_finalize(code)

end program write_at
