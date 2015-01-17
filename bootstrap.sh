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
    if ! which ag; then
      brew install the_silver_searcher
    fi
fi


script_path=`$readlink -f \`dirname $0\``


# symlink the top-level files into dotfiles in ~/
for fname in `find $script_path -maxdepth 1 -type f -not -name "*.osx"`; do
    basefname=`basename $fname`
    outpath="`$readlink -f ~/`/.$basefname"

    if [[ $_is_osx && -f "$fname".osx ]]; then
        fname="$fname".osx
        basefname="$basefname".osx
    fi

    if [[ "$dryrun" ]]; then
        echo "rm -f $outpath"
        echo "ln -s $script_path/$basefname $outpath"
    else
        if [[ -f $outpath ]]; then
            rm -f $outpath
        fi

        ln -s $script_path/$basefname $outpath
    fi
done

# symlink files in subdirectories to ~/$subdir/
for dname in `find $script_path -maxdepth 1 -type d -not -wholename "$script_path" -not -name ".git"`; do
    cd $dname
    for fname in `find $dname -maxdepth 1 -type f -not -name "*.osx"`; do
        if [[ "$fname" == "manualsetup" ]]; then
          continue
        fi

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

mkdir -p ~/.vim/backup

# disable os x animations
if is_osx; then
    defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool NO
fi


# install vim bundles
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

bundle_path="$HOME/.vim/bundle"
mkdir -p $bundle_path
cd $bundle_path

git clone https://github.com/hail2u/vim-css3-syntax.git       2> /dev/null
git clone https://github.com/ciaranm/inkpot.git               2> /dev/null
#git clone https://github.com/mbbill/echofunc.git              2> /dev/null
git clone https://github.com/saltstack/salt-vim.git           2> /dev/null
git clone https://github.com/ap/vim-css-color.git             2> /dev/null
git clone https://github.com/tpope/vim-fugitive.git           2> /dev/null
git clone https://github.com/pangloss/vim-javascript.git      2> /dev/null
git clone https://github.com/jelera/vim-javascript-syntax.git 2> /dev/null
git clone https://github.com/hynek/vim-python-pep8-indent.git 2> /dev/null
git clone https://github.com/tpope/vim-surround.git           2> /dev/null
git clone https://github.com/tpope/vim-repeat.git             2> /dev/null
git clone https://github.com/wavded/vim-stylus.git            2> /dev/null
git clone https://github.com/mxw/vim-jsx.git                  2> /dev/null
git clone https://github.com/kien/ctrlp.vim.git               2> /dev/null
git clone https://github.com/mikewest/vimroom.git             2> /dev/null
git clone https://github.com/tpope/vim-rails.git              2> /dev/null
git clone https://github.com/tpope/vim-bundler.git            2> /dev/null
git clone https://github.com/itchyny/calendar.vim.git         2> /dev/null
git clone https://github.com/sjl/gundo.vim.git                2> /dev/null
git clone https://github.com/tpope/vim-commentary.git         2> /dev/null
git clone https://github.com/vim-scripts/greplace.vim.git     2> /dev/null
git clone https://github.com/scrooloose/syntastic.git         2> /dev/null
git clone https://github.com/SirVer/ultisnips.git             2> /dev/null
git clone https://github.com/honza/vim-snippets.git           2> /dev/null
git clone https://github.com/fatih/vim-go.git                 2> /dev/null
git clone https://github.com/majutsushi/tagbar.git            2> /dev/null
git clone https://github.com/jiangmiao/auto-pairs.git         2> /dev/null
git clone https://github.com/rking/ag.vim.git                 2> /dev/null
git clone https://github.com/vshih/vim-make.git               2> /dev/null
git clone https://github.com/mtth/scratch.vim.git             2> /dev/null
git clone git@github.com:facebook/vim-flow.git                2> /dev/null

git clone https://github.com/marijnh/tern_for_vim.git 2> /dev/null
cd tern_for_vim
npm install
cd -

