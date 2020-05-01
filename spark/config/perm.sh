chown hadoop /home/hadoop/sf/sort
chown hadoop /home/hadoop/sf/sort/gensort
chown hadoop /home/hadoop/sf/sort/valsort
chmod +x run.sh
cd src
chmod +x build.sh
./build.sh
cd ..
su hadoop