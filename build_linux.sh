#Script to process a .love file from a working game build
#Main folder must contain a working game build

MAIN_FOLDER="."
FILES_FOLDER="files"
TITLE="Kermesse"

cd $FILES_FOLDER
zip -9 -r $TITLE.love .
mv $TITLE.love ../
love "../$TITLE.love"