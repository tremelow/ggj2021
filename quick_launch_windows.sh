#Script to process a windows executable from a working game build
#Main folder must contain a working game build
#dist folder must contain all the required dlls, from the official windows 64 bit love distribution

MAIN_FOLDER="."
FILES_FOLDER="$MAIN_FOLDER/files/"
DIST_FOLDER="$MAIN_FOLDER/dist/"
TITLE="game"

"$DIST_FOLDER/love.exe" $FILES_FOLDER
