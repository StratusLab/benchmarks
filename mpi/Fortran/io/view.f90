program view

  implicit none
  include 'mpif.h'

  integer                       :: rang,descripteur,type_elementaire,motif, &
                                   nb_octets_entier,code
  integer(kind=MPI_OFFSET_KIND) :: deplacement_initial
  integer, dimension(3)         :: longueurs,deplacements
  character(len=20)             :: representation
  logical                       :: defini

  call mpi_init(code)
  call mpi_comm_rank(MPI_COMM_WORLD,rang,code)

  call mpi_file_open(MPI_COMM_WORLD,"donnees.dat",MPI_MODE_RDONLY, &
                     MPI_INFO_NULL,descripteur,code)

  call mpi_file_get_view(descripteur,deplacement_initial,type_elementaire, &
                         motif,representation,code)
  if (rang == 0) print *,"Vue : type élémentaire", type_elementaire, &
                         "; motif",motif, &
                         "; déplacement initial",deplacement_initial, &
                         "; représentation",representation

  deplacements(1)=1
  deplacements(2)=4
  deplacements(3)=0
  longueurs(1)=2
  longueurs(2)=1
  longueurs(0)=0
  call mpi_type_indexed(3,longueurs,deplacements,MPI_INTEGER,motif,code)
  call mpi_type_commit(motif,code)

  call mpi_type_size(MPI_INTEGER,nb_octets_entier,code)

  deplacement_initial=2*nb_octets_entier
  call mpi_file_set_view(descripteur,deplacement_initial,MPI_INTEGER,motif, &
                         "native",MPI_INFO_NULL,code)
  call mpi_file_get_view(descripteur,deplacement_initial,type_elementaire, &
                         motif,representation,code)
  if (rang == 0) print *,"Vue : type élémentaire", type_elementaire, &
                         "; motif",motif, &
                         "; déplacement initial",deplacement_initial, &
                         "; représentation",representation

  call mpi_file_close(descripteur,code)
  call mpi_finalize(code)

end program view
