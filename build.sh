
if [[ $# -lt 1 ]]; then
do
    echo "Please mention the config : 1-Large 1-Small 4-Small"
    exit
done


if [[ $# -eq 2 ]]; then
do
    ./cluster-${2}.sh stop
done

cp workers-${1} spark/config/workers

cd scalabase
./build.sh
cd ../spark
./build.sh
cd ..
./cluster-${1}.sh deploy