#!/bin/bash


dryrun=""
if [[ "$1" ]]; then
    dryrun="1"
fi

readlink="readlink"

unamestr=`uname`
is_osx() {
    if [[ "$unamestr" == "Darwin" ]]; then
        return 0
    fi
    return 1
}

_is_osx=""
if is_osx; then
    _is_osx="1"
    readlink="greadlink"
    if ! which $readlink; then
        brew install coreutils
    fi
fi


script_path=`$readlink -f \`dirname $0\``


# symlink the top-level files into dotfiles in ~/
for fname in `find $script_path -maxdepth 1 -type f -not -name "*.osx"`; do
    fname=`basename $fname`
    outpath="`$readlink -f ~/`/.$fname"

    if [[ $_is_osx && -f "$fname".osx ]]; then
        fname="$fname".osx
    fi

    if [[ "$dryrun" ]]; then
        echo "rm -f $outpath"
        echo "ln -s $script_path/$fname $outpath"
    else
        if [[ -f $outpath ]]; then
            rm -f $outpath
        fi

        ln -s $script_path/$fname $outpath
    fi
done

# symlink files in subdirectories to ~/$subdir/
for dname in `find $script_path -maxdepth 1 -type d -not -wholename "$script_path" -not -name ".git"`; do
    cd $dname
    for fname in `find $dname -maxdepth 1 -type f -not -name "*.osx"`; do
        outdir=`$readlink -f ~/${PWD##*/}`
        outpath="$outdir/`basename $fname`"

        if [[ $_is_osx && -f "$fname".osx ]]; then
            fname="$fname".osx
        fi

        if [[ "$dryrun" ]]; then
            echo "mkdir -p $outdir"
            echo "rm -f $outpath"
            echo "ln -s $fname $outpath"
        else
            mkdir -p $outdir
            if [[ -f $outpath ]]; then
                rm -f $outpath
            fi

            ln -s $fname $outpath
        fi

    done
done

# setup one more level... this is gross!
for dname in `find $script_path -maxdepth 1 -type d -not -wholename "$script_path" -not -name ".git"`; do
    cd $dname
    basedname="${PWD##*/}"
    for subdname in `find $dname/ -maxdepth 1 -type d -not -wholename "$dname/"`; do
        cd $subdname
        basesubdname="${PWD##*/}"

        outdir="$HOME/$basedname/$basesubdname"
        mkdir -p $outdir

        for finalname in `find . -type f -not -name "*.osx"`; do
            finalname=`basename $finalname`
            finalpath="$subdname/$finalname"
            finaloutpath="$HOME/$basedname/$basesubdname/$finalname"

            if [[ "$dryrun" ]]; then
                echo "rm -f $finaloutpath"
                echo "ln -s $finalpath $finaloutpath"
            else
                if [[ -f $finaloutpath ]]; then
                    rm -f $finaloutpath
                fi
                ln -s $finalpath $finaloutpath
            fi

        done
    done
done

if [[ "$dryrun" ]]; then
    echo "exiting before installing vim bundles as this is dry run"
    exit
fi

# install vim bundles
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

bundle_path="$HOME/.vim/bundle"
mkdir -p $bundle_path
cd $bundle_path

git clone https://github.com/hail2u/vim-css3-syntax.git 2> /dev/null
git clone https://github.com/ciaranm/inkpot.git 2> /dev/null
git clone https://github.com/mbbill/echofunc.git 2> /dev/null
git clone https://github.com/saltstack/salt-vim.git 2> /dev/null
git clone https://github.com/ap/vim-css-color.git 2> /dev/null
git clone https://github.com/tpope/vim-fugitive.git 2> /dev/null
git clone https://github.com/pangloss/vim-javascript.git 2> /dev/null
git clone https://github.com/jelera/vim-javascript-syntax.git 2> /dev/null
git clone https://github.com/hynek/vim-python-pep8-indent.git 2> /dev/null
git clone https://github.com/tpope/vim-surround.git 2> /dev/null
git clone https://github.com/tpope/vim-repeat.git 2> /dev/null
git clone https://github.com/jnwhiteh/vim-golang 2> /dev/null
git clone git@github.com:Blackrush/vim-gocode.git 2> /dev/null

git clone https://github.com/marijnh/tern_for_vim.git 2> /dev/null
cd tern_for_vim
npm install
cd -

