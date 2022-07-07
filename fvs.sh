path="$HOME/Library"; # Change this to your flutter sdk path's parent directory.
curr_ver="$(cat "$path/flutter/version")";

if [ $1 ] ; then
case $1 in
    -v | --version )
        echo "Flutter SDK version: $curr_ver";
        exit 0;
        ;;
    -l | --list )
        echo "Available Flutter SDK versions:";
        echo "* $curr_ver";
        find $path -maxdepth 1 -type d -name "flutter-*" | sed 's/^.*flutter-//' | sed 's/\/.*//';
        exit 0;
        ;;
    -s | --switch )
        if [ $2 ] ; then
            if [ -d "$path/flutter-$2" ] ; then
                echo "Switching to Flutter SDK version: $2";
                rm -rf "$path/flutter-$curr_ver";
                mv "$path/flutter" "$path/flutter-$curr_ver";
                mv "$path/flutter-$2" "$path/flutter";
                echo "Switched to Flutter SDK version: $2";
                flutter doctor;
                exit 0;
            else
                echo "Flutter SDK version $2 not found.";
                exit 1;
            fi
        else
            echo "No version specified.";
            exit 1;
        fi
        ;;
    -i | --import )
        echo "Importing new Flutter SDK from Downloads folder.";
        versions=$(find $HOME/Downloads -maxdepth 1 -type f -name "flutter_macos_*" | sed 's/^.*flutter_macos_//' | sed 's/\-stable.zip//');
        if [ $versions ] ; then
            echo "Available versions:";
            echo "$versions";
            echo "Are you sure you want to import these versions? (y/n)";
            read version;
            if [ $version = "y" ] ; then
                for ver in $versions; do
                    echo "Importing version: $ver..";
                    rm -rf "$path/flutter-$curr_ver";
                    mv "$path/flutter" "$path/flutter-$curr_ver";
                    cd $path;
                    unzip -q "$HOME/Downloads/flutter_macos_$ver-stable.zip";
                    rm "$HOME/Downloads/flutter_macos_$ver-stable.zip";
                    mv "$path/flutter" "$path/flutter-$ver";
                    mv "$path/flutter-$curr_ver" "$path/flutter";
                    echo "Imported version: $ver";
                done
                exit 0;
            else
                echo "Aborting..";
                exit 1;
            fi
        else 
            echo "No versions found in download folder.";
            exit 1;
        fi
        ;;
    -h | --help )
        echo "Usage: fvs [option] [version]";
        echo "Options:";
        echo "  -v, --version     Show current Flutter SDK version.";
        echo "  -l, --list        List available Flutter SDK versions.";
        echo "  -s, --switch      Switch to a different Flutter SDK version.";
        echo "  -i, --import      Import a new Flutter SDK from Downloads folder.";
        echo "  -h, --help        Show this help.";
        exit 0;
        ;;
    * )
        echo "Usage: fvs.sh [ -v | -l | -s | -i | -h ]";
        exit 1;
        ;;
esac
else
    echo "Current Flutter version:$curr_ver.";
    
fi