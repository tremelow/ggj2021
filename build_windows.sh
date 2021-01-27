#Script to process a windows executable from a working game build
#Main folder must contain a working game build
#dist folder must contain all the required dlls, from the official windows 64 bit love distribution

MAIN_FOLDER="."
FILES_FOLDER="files/"
DIST_FOLDER="dist/"
TITLE="game"

cd "$MAIN_FOLDER/$FILES_FOLDER"
zip -9 -r $TITLE.love . 
cd "../$DIST_FOLDER"
cat "love.exe" "../$FILES_FOLDER/$TITLE.love" > $TITLE.exe
zip -9 -r "game.zip" . 
mv game.zip ../
