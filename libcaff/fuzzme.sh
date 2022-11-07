mkdir -p afl_out
docker build -t libcaff-fuzz .
docker run --rm -it --tmpfs /tmp -v $PWD/afl_out:/afl_out libcaff-fuzz