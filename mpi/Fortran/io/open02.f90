program open02

  implicit none
  include 'mpif.h'

  integer           :: rang,descripteur,attribut,longueur,code
  character(len=80) :: libelle
  logical           :: defini

  call mpi_init(code)
  call mpi_comm_rank(MPI_COMM_WORLD,rang,code)

  call mpi_file_open(MPI_COMM_WORLD,"fichier.txt", &
                     ior(MPI_MODE_RDWR,MPI_MODE_CREATE),MPI_INFO_NULL, &
                     descripteur,code)

  call mpi_file_get_info(descripteur,attribut,code)
  call mpi_info_get_valuelen(attribut,"cb_nodes",longueur,defini,code)
  if (defini) then
     call mpi_info_get(attribut,"cb_nodes",longueur,libelle,defini,code)
     if (rang == 0) print *,"Fichier `fichier.txt' sur ", &
                            libelle(1:longueur)," processus"
  end if

  call mpi_info_free(attribut,code)
  call mpi_file_close(descripteur,code)
  call mpi_finalize(code)

end program open02
