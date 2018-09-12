if [ ! -e ~/xnatpassfile ] & [ ! -e ~/xnatconfigfile ]; then
  read -p 'Username: ' uservar
  read -sp 'Password: ' passvar
  printf "{\"password\": \"$passvar\", \"user\": \"$uservar\", \"server\": \"http://xnat.fiu.edu\"}" > ~/xnatconfigfile
  printf "+$uservar@http://xnat.fiu.edu:8080/xnat=$passvar" > ~/xnatpassfile
fi

while [[ $# -gt 0 ]]; do
    case $1 in
    -a|--auto) autocheck="$2"; shift;;
    -p|--project) proj="$2" ; shift;;
    -o|--outputdir) outdir="$2" ; shift;;
    -s|--session) expsess="$2" ; shift;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1. Try $0 -h" 1>&2; exit 1;;
    (*) break;;
    esac
    shift
done

function download_experiment {

  # create a temporary directory with the subject filters
  # if the temporary directory exists (it should not), create it
  if [ ! -d $outdir/$proj ]; then
    mkdir -p $outdir/$proj
  fi

  # download the subject file into the temporary directory
  /xget-public/xget -passfile ~/xnatpassfile -s ${exps[i]} -o $outdir/$proj -proj $proj
  unzip $outdir/$proj/${exps[i]}_acq.zip -d $outdir/$proj/
  rm $outdir/$proj/${exps[i]}_acq.zip
  tar -C $outdir/$proj/${labels[i]} -cf $outdir/$proj/sub-"$sub"_ses-${sess}.tar scans/
  rm -r $outdir/$proj/${labels[i]}
  printf "sub-%s_ses-%s.tar\n" $sub $sess >> ~/XNAT-data-transfer/$proj-processed

  # get date and time
  date_time=
  date_time=$(date)
  # append the email message
  echo "Data transferred from XNAT to FIU-HPC for Project: $proj Subject: $sub Session: $sess on $date_time" >> ~/XNAT-data-transfer/$proj-processed-message

}

# call a python script to get a list of experiments in the XNAT project
exps=($(python /scripts/xnat_list.py ~/xnatconfigfile $proj 'experiments'))
labels=($(python /scripts/xnat_list.py ~/xnatconfigfile $proj 'labels'))

#for each subject identified
for ((i=0;i<${#exps[@]};i++)); do
  labelinfo=($(bash /scripts/sub_sess_id.sh $proj ${labels[i]}))
  sub=${labelinfo[0]}
  sess=${labelinfo[1]}
  if [[ $autocheck == "y" ]] | [[ $autocheck == "yes" ]]; then

    if [ -e ~/XNAT-data-transfer/$proj-processed ]; then
      proj_data=`cat ~/XNAT-data-transfer/$proj-processed`
      # if the subject has not previously been processed
      if [[ $proj_data != *sub-"$sub"_ses-"$sess".tar* ]]; then
        download_experiment
      fi
    else
      mkdir ~/XNAT-data-transfer
      download_experiment
    fi

  else
    if [[ $expsess == XNAT_* ]]; then
      if [[ ${exps[i]} == $expsess ]]; then
        if [ ! -e ~/XNAT-data-transfer/$proj-processed ]; then
          mkdir ~/XNAT-data-transfer
        else
          proj_data=`cat ~/XNAT-data-transfer/$proj-processed`
          if [[ $proj_data != *sub-"$sub"_ses-"$sess".tar* ]]; then
            download_experiment
          else
            echo "Experiment session has already been downloaded!"
            exit
          fi
        fi
      else
        echo "Experiment session '$expsess' is not in project '$proj'!"
        exit
      fi
    else
      echo "Experiment session should start with 'XNAT_*'!"
      exit
    fi
  fi
done

if [ -e ~/XNAT-data-transfer/$proj-processed-message ]; then
  mail -s 'FIU XNAT-HPC Data Transfer Update Project $proj' $USER@fiu.edu < ~/XNAT-data-transfer/$proj-processed-message
  rm ~/XNAT-data-transfer/$proj-processed-message
fi
