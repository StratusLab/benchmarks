program read_view02

  implicit none
  include 'mpif.h'

  integer, parameter                  :: nb_valeurs=10
  integer                             :: rang,descripteur,motif,code
  integer(kind=MPI_OFFSET_KIND)       :: deplacement_initial
  integer, dimension(2)               :: longueurs,deplacements
  integer, dimension(nb_valeurs)      :: valeurs
  integer, dimension(MPI_STATUS_SIZE) :: statut

  call mpi_init(code)
  call mpi_comm_rank(MPI_COMM_WORLD,rang,code)

  call mpi_file_open(MPI_COMM_WORLD,"donnees.dat",MPI_MODE_RDONLY, &
                     MPI_INFO_NULL,descripteur,code)

  if (rang == 0) then
     deplacements(1)=0
     deplacements(2)=4
     longueurs(1)=2
     longueurs(2)=0
  else
     deplacements(1)=2
     deplacements(2)=0
     longueurs(1)=2
     longueurs(2)=0
  end if
  call mpi_type_indexed(2,longueurs,deplacements,MPI_INTEGER,motif,code)
  call mpi_type_commit(motif,code)

  deplacement_initial=0
  call mpi_file_set_view(descripteur,deplacement_initial,MPI_INTEGER,motif, &
                         "native",MPI_INFO_NULL,code)

  call mpi_file_read(descripteur,valeurs,nb_valeurs,MPI_INTEGER,statut,code)

  print *, "Lecture processus",rang,":",valeurs(:)

  call mpi_file_close(descripteur,code)
  call mpi_finalize(code)

end program read_view02
