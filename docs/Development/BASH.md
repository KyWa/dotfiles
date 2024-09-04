# BASH Notes

## Yes/No Case Statement Example
```
case $repo_install in
    [yY][eE][sS][|[yY])
        echo "Yes"
        ;;
    [nN][oO]|[nN])
        echo "No"
        exit
        ;;
esac
```

## SED

### Mac/BSD sed
`sed -i '' -e 's/mineops-0/mineops-1/g' file`
`sed -i '' -e '/thingtodelete/d' file`
