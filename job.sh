cd $HOME

echo "##################################################################################################"
echo "Initiating process..."
echo "##################################################################################################"
folderName=stagingFolder_$(date +'%Y-%m-%d-%H-%M-%S')
pythonExecutable=fourbyfourallcase_parallel_cluster.py


echo "Execute Pre-processing actions..."
echo "##################################################################################################"

echo "Attempting to delete existing directory with name $foldername"
rm -rf $folderName

echo "Creating new directory with name $foldername"
mkdir $folderName
cd ./$folderName

echo "Cloning repository:"
git clone \
--single-branch \
--branch parallelized \
https://github.com/sujitnar/Electromagnetic-Response-tensor-graphene.git

echo "Clonning successful..!"
cd ./Electromagnetic-Response-tensor-graphene

echo "Zipping elec_mag-tensor.zip..."
zip -r elec_mag-tensor.zip . \
--exclude *.md* \
--exclude *.git* \
--exclude pyspark_submit.sh \
--exclude $pythonExecutable

echo "Preparing for executing spark jobs...Copying files"
cp ./elec_mag-tensor.zip $HOME/$folderName/elec_mag-tensor.zip
cp ./pyspark_submit.sh $HOME/$folderName/pyspark_submit.sh
cp ./$pythonExecutable $HOME/$folderName/$pythonExecutable

cd $HOME/$folderName

echo "Deleteing source code files..."
rm -rf ./Electromagnetic-Response-tensor-graphene

echo "Starting spark job...at $(date '+%d/%m/%Y %H:%M:%S')"
bash $HOME/$folderName/pyspark_submit.sh $HOME/$folderName $pythonExecutable elec_mag-tensor.zip
echo "Job complete ...at $(date '+%d/%m/%Y %H:%M:%S')"

echo "Post Processing cleanup"
rm -rf $HOME/$folderName