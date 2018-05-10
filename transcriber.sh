#!/bin/bash

KALDI_root=/var/www/lamachine2/weblamachine/opt/kaldi/egs/fame/resources #shouldn't really be hard-coded here
inputdir=$1
scratchdir=$2
outdir=$3

cd $KALDI_root
for inputfile in $inputdir/*; do

  filename=$(basename "$inputfile")
  extension="${filename##*.}"
  file_id=$(basename "$inputfile" .$extension)
  sox $inputfile -e signed-integer -c 1 -r 16000 -b 16 $scratchdir/${file_id}.wav
  recog_dir_name=${file_id}_$(date +"%y_%m_%d_%H_%m_%S")
  target_dir=$scratchdir/${recog_dir_name}
  mkdir -p $target_dir

  ./recognize.sh $scratchdir/${file_id}.wav $target_dir
  cp $target_dir/${recog_dir_name}.txt $outdir/${file_id}.txt
  cp $target_dir/${recog_dir_name}.ctm $outdir/${file_id}.ctm
  cp $target_dir/${recog_dir_name}.rttm $outdir/${file_id}.rttm
  ./scripts/ctm2xml.py $outdir $file_id $scratchdir
  rm -f $scratchdir/${file_id}.wav

done
