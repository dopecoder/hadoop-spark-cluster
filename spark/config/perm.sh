source .bashrc
chown hadoop /home/hadoop/sf/sort
chown hadoop /home/hadoop/sf/sort/gensort
chown hadoop /home/hadoop/sf/sort/valsort
chmod +x exec-hp.sh
chmod +x exec-sp.sh
chmod +x np_process.py
chmod +x run.sh
cd src
chmod +x build.sh
./build.sh
cd ..
su hadoop