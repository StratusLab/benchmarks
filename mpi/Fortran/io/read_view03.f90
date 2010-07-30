program read_view03

  implicit none
  include 'mpif.h'

  integer, parameter                  :: nb_valeurs=10
  integer                             :: rang,descripteur,code, &
                                         motif_1,motif_2,motif_3, &
                                         nb_octets_entier
  integer(kind=MPI_OFFSET_KIND)       :: deplacement_initial=0
  integer, dimension(2)               :: longueurs,deplacements
  integer, dimension(nb_valeurs)      :: valeurs
  integer, dimension(MPI_STATUS_SIZE) :: statut

  call mpi_init(code)
  call mpi_comm_rank(MPI_COMM_WORLD,rang,code)

  call mpi_file_open(MPI_COMM_WORLD,"donnees.dat",MPI_MODE_RDONLY, &
                     MPI_INFO_NULL,descripteur,code)

  longueurs(1)=2
  longueurs(2)=0
  deplacements(1)=0
  deplacements(2)=4
  call mpi_type_indexed(2,longueurs,deplacements,MPI_INTEGER,motif_1,code)
  call mpi_type_commit(motif_1,code)

  longueurs(1)=2
  longueurs(2)=0
  deplacements(1)=2
  deplacements(2)=0
  call mpi_type_indexed(2,longueurs,deplacements,MPI_INTEGER,motif_2,code)
  call mpi_type_commit(motif_2,code)

  longueurs(1)=1
  longueurs(2)=0
  deplacements(1)=3
  deplacements(2)=0
  call mpi_type_indexed(2,longueurs,deplacements,MPI_INTEGER,motif_3,code)
  call mpi_type_commit(motif_3,code)

  deplacement_initial=0
  call mpi_file_set_view(descripteur,deplacement_initial,MPI_INTEGER,motif_1, &
                         "native",MPI_INFO_NULL,code)
  call mpi_file_read(descripteur,valeurs,4,MPI_INTEGER,statut,code)

  call mpi_file_set_view(descripteur,deplacement_initial,MPI_INTEGER,motif_2, &
                         "native",MPI_INFO_NULL,code)
  call mpi_file_read(descripteur,valeurs(5:7),3,MPI_INTEGER,statut,code)

  call mpi_type_size(MPI_INTEGER,nb_octets_entier,code)
  deplacement_initial=2*nb_octets_entier
  call mpi_file_set_view(descripteur,deplacement_initial,MPI_INTEGER,motif_3, &
                         "native",MPI_INFO_NULL,code)
  call mpi_file_read(descripteur,valeurs(8:10),3,MPI_INTEGER,statut,code)

  print *, "Lecture processus",rang,":",valeurs(:)

  call mpi_file_close(descripteur,code)
  call mpi_finalize(code)

end program read_view03
