FROM aflplusplus/aflplusplus AS libcaff-fuzz

COPY . /libcaff
WORKDIR /libcaff

ENV AFL_LLVM_ALLOWLIST=/libcaff/afl_allowlist.txt
ENV AFL_USE_ASAN=1
ENV AFL_LLVM_LAF_ALL=1
ENV AFL_TMPDIR=/tmp

RUN mkdir -p build && \
    cd build && \
    cmake -DLIBCAFF_STATIC=ON -DCMAKE_C_COMPILER=afl-clang-lto -DCMAKE_CXX_COMPILER=afl-clang-lto++ .. && \
	cmake --build .

CMD afl-fuzz -i example_crafted -o /afl_out -- build/caffrunner @@ /tmp/caff.png