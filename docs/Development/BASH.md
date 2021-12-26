# BASH Notes

## Yes/No Case Statement Example
case $repo_install in
    [yY][eE][sS][|[yY])
        echo "Yes"
        ;;
    [nN][oO]|[nN])
        echo "No"
        exit
        ;;
esac
