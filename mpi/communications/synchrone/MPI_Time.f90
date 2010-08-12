!************************************************************************
!                                                                       !
!   Module : MPI_Times           (Version : 3.4)                        !
!                                                                       !
!   Goal   : Measure and print on stdout CPU and Elapsed user times     !
!            and the ratio CPU/Elapsed of MPI programs.                 !
!                                                                       !
!   Usage  : Insert a "USE MPI_TIMES" instruction inside each MPI       !
!            Fortran program unit to instrument, then make calls to     !
!            the MPI_TIME subroutine as shown in the example below :    !
!                                                                       !
!           PROGRAM foo                                                 !
!             USE MPI_TIMES                                             !
!             ...                                                       !
!             CALL MPI_INIT(ierr)                                       !
!                                                                       !
!             !... Set elapsed and CPU user times                       !
!             CALL MPI_TIME(0)                                          !
!             ...                                                       !
!             ... Instruction block to instrument ...                   !
!             ...                                                       !
!             !... Measure and print elapsed and CPU user times         !
!             CALL MPI_TIME(1)                                          !
!                                                                       !
!             CALL MPI_FINALIZE(ierr)                                   !
!           END PROGRAM foo                                             !
!                                                                       !
!  Notes   : 1) Standard Fortran 95 compiler has to be used to compile  !
!               MPI_TIMES module.                                       !
!                                                                       !
!            2) MPI_TIME subroutine is collective over all processes    !
!               of MPI_COMM_WORLD communicator.                         !
!                                                                       !
!            3) On some machines, default CPU user time may also        !
!               include MPI wait times on communication to complete.    !
!                                                                       !
!            4) If Te and Tc respectively denotes the elapsed and CPU   !
!               user times, then the ratio R=Tc/Te > 0 may lead to      !
!               different interpretations depending on R<1 or R=1       !
!               or R>1.                                                 !
!                                                                       !
!               a) If R<1, then wait time on communications and/or      !
!                  system load could be the reason of such performance. !
!                                                                       !
!               b) If R is close to 1 and no hybrid parallelization     !
!                  (e.g. MPI + OpenMP) is implemented, then wait time   !
!                  on communications and/or system load are far to be   !
!                  considered unless point 3) and then, one can assume  !
!                  that 99% of the time, processes are busy performing  !
!                  useful computations on dedicated processors.         !
!                                                                       !
!               c) If R>1, then process might has been multi-threaded   !
!                  during execution as what would happen in hybrid      !
!                  parallelization (e.g. MPI + OpenMP) on cluster       !
!                  of SMP nodes. In such case, R may reflect the speed  !
!                  up of the process.                                   !
!                                                                       !
!            5) On IBM SP machine, do not compile MPI_TIMES module      !
!               using "-qrealsize=8" switch. This will transform        !
!               MPI_WTIME function type from 8 to 16 bytes floating     !
!               point precision.                                        !
!                                                                       !
!            6) No special switch is needed to compile this file.       !
!               The following should be sufficient on many platforms:   !
!               f90 -c -Ipath_to_MPI_header_file MPI_Time.f90           !
!                                                                       !
!   Output : At normal termination of the MPI program, process of       !
!            rank 0 prints on stdout elapsed time, cpu time and ratio   !
!            cpu/elapsed of all MPI_COMM_WORLD processes.               !
!            The following is an output example from an execution       !
!            with 4 processes:                                          !
!                                                                       !
!............                                                           !
!  (C) January 2003, CNRS/IDRIS, FRANCE.                                !
!  MPI_Time (release 3.4) summary report:                               !
!                                                                       !
!  Process Rank | Elapsed Time (s) | CPU Time (s) | Ratio CPU/Elapsed   !
!  -------------|------------------|--------------|------------------   !
!     0         |     427.098      |     270.393  |      0.633          !
!     1         |     427.099      |     279.818  |      0.655          !
!     2         |     427.099      |     276.064  |      0.646          !
!     3         |     427.182      |     271.001  |      0.634          !
!  -------------|------------------|--------------|------------------   !
!  Total        |    1708.477      |    1097.275  |      2.569          !
!  -------------|------------------|--------------|------------------   !
!  Minimum      |     427.098      |     270.393  |      0.633          !
!  -------------|------------------|--------------|------------------   !
!  Maximum      |     427.182      |     279.818  |      0.655          !
!  -------------|------------------|--------------|------------------   !
!  Average      |     427.119      |     274.319  |      0.642          !
!  -------------|------------------|--------------|------------------   !
!                                                                       !
!  MPI_Time started on 13/11/2002 at 16:54:59 MET +01:00 from GMT       !
!  MPI_Time   ended on 13/11/2002 at 17:02:06 MET +01:00 from GMT       !
!............                                                           !
!                                                                       !
!   Author : Jalel Chergui ; E-mail: Jalel.Chergui@idris.fr             !
!                                                                       !
! Permission is garanted to copy and distribute this file or modified   !
! versions of this file for no fee, provided the copyright notice and   !
! this permission notice are preserved on all copies.                   !
!                                                                       !
! Copyright (C) January 2003, CNRS/IDRIS, FRANCE.                       !
!************************************************************************

MODULE MPI_TIMES
  IMPLICIT NONE
  PRIVATE

  !... Shared variables
  INTEGER, PARAMETER              :: p = SELECTED_REAL_KIND(12)
  REAL(kind=p)                    :: Eoverhead, Coverhead
  REAL(kind=p), DIMENSION(2)      :: Etime, Ctime
  INTEGER, DIMENSION(8)           :: values
  CHARACTER(LEN=8), DIMENSION(2)  :: date
  CHARACTER(LEN=10), DIMENSION(2) :: time
  CHARACTER(LEN=5)                :: zone

  PUBLIC :: MPI_Time

  CONTAINS

  SUBROUTINE MPI_Time(flag)
    IMPLICIT NONE

    !... MPI Header files
    INCLUDE "mpif.h"

    !... Input dummy parameter
    INTEGER, INTENT(IN) :: flag

    !... Local variables
    INTEGER                                 :: rank, nb_procs, i, code
    INTEGER, ALLOCATABLE, DIMENSION(:)      :: All_Rank
    REAL(KIND=p), ALLOCATABLE, DIMENSION(:) :: All_Etime, All_Ctime, All_Ratio
    REAL(KIND=p)                            :: Total_Etime,Total_Ctime,Total_Ratio,&
                                               Max_Etime, Max_Ctime, Max_Ratio, &
                                               Min_Etime, Min_Ctime, Min_Ratio, &
                                               Avg_Etime, Avg_Ctime, Avg_Ratio, &
                                               dummy
    CHARACTER(LEN=128), dimension(8) :: lignes
    CHARACTER(LEN=128)               :: hline, start_date, final_date
    CHARACTER(LEN=2048)              :: fmt

    SELECT CASE(flag)
      CASE(0)

        !... Compute clock overhead
        Eoverhead = MPI_WTIME()
        Eoverhead = MPI_WTIME() - Eoverhead
        CALL CPU_TIME(dummy)
        CALL CPU_TIME(Coverhead)
        if (dummy < 0.0_p) &
          PRINT *,"Warning, MPI_TIME: CPU user time is not available on this machine."
        Coverhead = Coverhead - dummy
        CALL MPI_COMM_RANK(MPI_COMM_WORLD, rank, code)
        !... Start of timings on "date & time"
        IF ( rank == 0 ) &
           CALL DATE_AND_TIME(date(1),time(1),zone,values)
        !... Start elapsed and CPU time counters
        Etime(1) = MPI_WTIME()
        CALL CPU_TIME(Ctime(1))

      CASE(1)
        !... Final CPU and elapsed times
        CALL CPU_TIME(Ctime(2))
        Etime(2) = MPI_WTIME() - Etime(1) - Eoverhead - Coverhead
        Ctime(2) = Ctime(2) - Ctime(1) - Coverhead
        !... Gather all times
        CALL MPI_COMM_RANK(MPI_COMM_WORLD, rank, code)
        CALL MPI_COMM_SIZE(MPI_COMM_WORLD, nb_procs, code)
        IF ( rank == 0) ALLOCATE(All_Etime(nb_procs), &
                                 All_Ctime(nb_procs), &
                                 All_Ratio(nb_procs), &
                                 All_Rank(nb_procs) )
        CALL MPI_GATHER(Etime(2), 1, MPI_DOUBLE_PRECISION,  &
                        All_Etime, 1, MPI_DOUBLE_PRECISION, &
                        0, MPI_COMM_WORLD, code)
        CALL MPI_GATHER(Ctime(2), 1, MPI_DOUBLE_PRECISION,  &
                        All_Ctime, 1, MPI_DOUBLE_PRECISION, &
                        0, MPI_COMM_WORLD, code)
        IF ( rank == 0) THEN
          All_Rank(:) = (/ (i,i=0,nb_procs-1) /)

          !... Compute elapse user time
          Total_Etime = SUM(All_Etime(:))
          Avg_Etime   = Total_Etime/REAL(nb_procs,KIND=p)
          Max_Etime   = MAXVAL(All_Etime(:))
          Min_Etime   = MINVAL(All_Etime(:))
          IF( Min_Etime <= 0.0_p ) THEN
            PRINT *,"Warning, MPI_TIME: Measured elapsed user time seems to be too short"
            PRINT *,"compared to the clock precision. Timings could be erroneous."
          END IF

          !... Compute CPU user time
          Total_Ctime = SUM(All_Ctime(:))
          Avg_Ctime   = Total_Ctime/REAL(nb_procs,KIND=p)
          Max_Ctime   = MAXVAL(All_Ctime(:))
          Min_Ctime   = MINVAL(All_Ctime(:))
          IF( Min_Ctime <= 0.0_p ) THEN
            PRINT *,"Warning, MPI_TIME: Measured CPU user time seems to be too short"
            PRINT *,"compared to the clock precision. Timings could be erroneous."
          END IF

          !... Compute cpu/elapsed ratio
          All_Ratio(:) = All_Ctime(:) / All_Etime(:)
          Total_Ratio  = SUM(All_Ratio(:))
          Avg_Ratio    = Total_Ratio/REAL(nb_procs,KIND=p)
          Max_Ratio    = MAXVAL(All_Ratio(:))
          Min_Ratio    = MINVAL(All_Ratio(:))

          !... End of timings on "date & time"
          CALL DATE_AND_TIME(date(2),time(2),zone,values)

          !... Output Format
          hline    ='10X,13("-"),"|",18("-"),"|",14("-"),"|",18("-"),/,'
          lignes(1)='(//,10X,"(C) January 2003, CNRS/IDRIS, FRANCE.",/,'
          lignes(2)='10X,"MPI_Time (release 3.4) summary report:",//,'
          lignes(3)='10X,"Process Rank |"," Elapsed Time (s) |"," CPU Time (s) |"," Ratio CPU/Elapsed",/,'
          lignes(4)='    (10X,I4,9(" "),"|",F12.3,6(" "),"|",F12.3,2(" "),"|",4(" "),F7.3,/),'
          WRITE(lignes(4)(1:4),'(I4)') nb_procs
          lignes(5)='10X,"Total        |",F12.3,6(" "),"|",F12.3,2(" "),"|",4(" "),F7.3,/,'
          lignes(6)='10X,"Minimum      |",F12.3,6(" "),"|",F12.3,2(" "),"|",4(" "),F7.3,/,'
          lignes(7)='10X,"Maximum      |",F12.3,6(" "),"|",F12.3,2(" "),"|",4(" "),F7.3,/,'
          lignes(8)='10X,"Average      |",F12.3,6(" "),"|",F12.3,2(" "),"|",4(" "),F7.3,/,'
          start_date='/,10X,"MPI_Time started on ",2(A2,"/"),A4," at ",2(A2,":"),A2," MET ",A3,":",A2," from GMT",/,'
          final_date='10X,  "MPI_Time   ended on ",2(A2,"/"),A4," at ",2(A2,":"),A2," MET ",A3,":",A2," from GMT",//)'
          fmt=TRIM(lignes(1))//TRIM(lignes(2))//TRIM(lignes(3))//           &
            & TRIM(hline)//TRIM(lignes(4))//TRIM(hline)//TRIM(lignes(5))//  &
            & TRIM(hline)//TRIM(lignes(6))//TRIM(hline)//TRIM(lignes(7))//  &
            & TRIM(hline)//TRIM(lignes(8))//TRIM(hline)//TRIM(start_date)// &
            & TRIM(final_date)
          WRITE(*, TRIM(fmt)) &
              (All_rank(i),All_Etime(i),All_Ctime(i),All_Ratio(i),i=1, nb_procs), &
              Total_Etime,  Total_Ctime,  Total_Ratio,  &
              Min_Etime,    Min_Ctime,    Min_Ratio,    &
              Max_Etime,    Max_Ctime,    Max_Ratio,    &
              Avg_Etime,    Avg_Ctime,    Avg_Ratio,    &
              date(1)(7:8), date(1)(5:6), date(1)(1:4), &
              time(1)(1:2), time(1)(3:4), time(1)(5:6), &
              zone(1:3),    zone(4:5),                  &
              date(2)(7:8), date(2)(5:6), date(2)(1:4), &
              time(2)(1:2), time(2)(3:4), time(2)(5:6), &
              zone(1:3),    zone(4:5)
          DEALLOCATE(All_Etime, All_Ctime, All_Ratio, All_rank)
        END IF

      CASE DEFAULT
        PRINT *,"Error, MPI_TIME: Invalid input parameter"

    END SELECT
  END SUBROUTINE MPI_Time
END MODULE MPI_TIMES
