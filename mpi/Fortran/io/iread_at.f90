program iread_at

  implicit none
  include 'mpif.h'

  integer, parameter                  :: nb_valeurs=10
  integer                             :: i,nb_iterations=0,rang, &
                                         nb_octets_entier,descripteur, &
                                         requete,code
  integer(kind=MPI_OFFSET_KIND)       :: position_fichier
  integer, dimension(nb_valeurs)      :: valeurs
  integer, dimension(MPI_STATUS_SIZE) :: statut
  logical                             :: termine

  call mpi_init(code)
  call mpi_comm_rank(MPI_COMM_WORLD,rang,code)

  call mpi_file_open(MPI_COMM_WORLD,"donnees.dat",MPI_MODE_RDONLY, &
                     MPI_INFO_NULL,descripteur,code)

  call mpi_type_size(MPI_INTEGER,nb_octets_entier,code)
  position_fichier=rang*nb_valeurs*nb_octets_entier
  call mpi_file_iread_at(descripteur,position_fichier,valeurs,nb_valeurs, &
                         MPI_INTEGER,requete,code)

  do while (nb_iterations < 5000)
     nb_iterations=nb_iterations+1
     call mpi_test(requete,termine,statut,code)
     if (termine) exit
  end do
  print *,"Après",nb_iterations,"iterations, lecture processus",rang,":", &
          valeurs

  call mpi_file_close(descripteur,code)
  call mpi_finalize(code)

end program iread_at
