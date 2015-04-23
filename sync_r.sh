#! /bin/bash

mstr="@microstrategy.com"
if [[ `whoami` != 'cp2' ]] ; then
        echo "run it with the cp2 account"
        exit 1
fi
if [[ -z ${BuildNum} ]]; then
        echo "please provide a build number";
        exit 1
fi

#if pwd | grep -q rel_view ; then
	mode="rel"
	view="/home/cp2/views/cp2_DDA_lnx_rel_view"
	copyto="/user4/Builds/${BuildNum}/RELEASE/BIN/copyto.pl"
#fi

echo "cd $view"
cd $view

echo "cleartool update -over BuildScripts/conspecs"
cleartool update -over BuildScripts/conspecs

if [ ! -f BuildScripts/conspecs/${BuildNum}_cs.txt ]; then
        echo "cs file for build $BuildNum not found"
	echo `pwd`/BuildScripts/conspecs/${BuildNum}_cs.txt
        exit 1
fi

cs="cs.txt"
if [ -f $cs ] ; then
        echo "rm -f $cs"
        rm -f $cs
fi

echo "cat BuildScripts/conspecs/${BuildNum}_cs.txt | grep -v load > $cs"
cat BuildScripts/conspecs/${BuildNum}_cs.txt | grep -v load > $cs

echo "cleartool catcs | grep load >> $cs"
cleartool catcs | grep load >> $cs

#unco checkout before update
echo "cleartool lsco -cview -me -s -avobs"
co_files=`cleartool lsco -cview -me -s -avobs`
if [ ! -z "$co_files" ]; then
        echo "cleartool unco"
        cleartool unco -rm $co_files
else
        echo "No checkouts."
fi

echo "cleartool setcs -over $cs"
cleartool setcs -over $cs

if [ ! -f $copyto ]; then
        echo "File $copyto not found"
        exit 1
fi

echo "perl $copyto . "
yes | perl $copyto .


to="jingwang$mstr"
if [[ ! -z $2 ]]; then
        cc="-c $2$mstr"
fi
from="jingwang$mstr"

#echo -e "View $view is synced to build ${BuildNum} on $(uname -n). \n\nThis is an automated email." | mail -s "Delta $mode view synced to ${BuildNum} on $(uname -n)" $to $cc -- -f $from

