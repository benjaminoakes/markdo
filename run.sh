docker build -t markdo .
docker run --rm -v $PWD:/src -i -t markdo
