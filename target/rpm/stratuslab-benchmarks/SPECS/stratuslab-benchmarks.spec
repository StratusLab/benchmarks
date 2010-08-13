Name: stratuslab-benchmarks
Version: 1.0
Release: 0.20100813.122622
Summary: StratusLab Benchmarks
License: Apache
Vendor: StratusLab
URL: http://opennebula.org/
Group: System
Packager: StratusLab
Requires: openmpi
autoprov: yes
autoreq: yes
BuildRoot: /home/mairaj/benchmarks/target/rpm/stratuslab-benchmarks/buildroot

%description
This package contains a series of StratusLab benchmarks used to determine
the performance of virtualized resources using representative applications.

%install
if [ -e $RPM_BUILD_ROOT ];
then
  mv /home/mairaj/benchmarks/target/rpm/stratuslab-benchmarks/tmp-buildroot/* $RPM_BUILD_ROOT
else
  mv /home/mairaj/benchmarks/target/rpm/stratuslab-benchmarks/tmp-buildroot $RPM_BUILD_ROOT
fi

%files

%attr(755,root,root) /usr/libexec/cpu_intensive
%attr(755,root,root) /usr/libexec/mpi-standard
%attr(755,root,root) /usr/libexec/mpi-sync
%attr(755,root,root) /usr/libexec/io-mpi-io
%attr(755,root,root) /usr/libexec/io-bonnie++
%attr(755,root,root) /usr/libexec/openmp-jacobi_para
%attr(755,root,root) /usr/libexec/openmp-matrix_para
%attr(755,root,root) /usr/libexec/io-mpi-o
%attr(755,root,root) /usr/libexec/openmp-jacob_seq
%attr(755,root,root) /usr/libexec/zcav
%attr(755,root,root) /usr/libexec/mpi-async
%attr(755,root,root) /usr/libexec/io-stress
%attr(755,root,root) /usr/libexec/openmp-matrix_seq
%attr(755,root,root) /usr/libexec/openmp-cg_para
%attr(755,root,root) /usr/libexec/mpi-persistent
%attr(755,root,root) /usr/libexec/io-mpi-i
%attr(755,root,root) /usr/libexec/openmp-cg_seq
%attr(755,root,root) /usr/bin/io-mpi.sh
%attr(755,root,root) /usr/bin/kepler_install.sh
%attr(755,root,root) /usr/bin/mpi-sync.sh
%attr(755,root,root) /usr/bin/kepler-nogui.sh
%attr(755,root,root) /usr/bin/cpu_intensive.sh
%attr(755,root,root) /usr/bin/mpi-standard.sh
%attr(755,root,root) /usr/bin/mpi-persistent.sh
%attr(755,root,root) /usr/bin/openmp-jacobi.sh
%attr(755,root,root) /usr/bin/openmp-cg.sh
%attr(755,root,root) /usr/bin/openmp-matrix.sh
