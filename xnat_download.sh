if [ ! -e ~/xnatpassfile ]; then
  read -p 'Username: ' uservar
  read -sp 'Password: ' passvar
  printf "{\"password\": \"$passvar\", \"user\": \"$uservar\", \"server\": \"http://xnat.fiu.edu\"}" > ~/xnatpassfile
fi


while [[ $# -gt 0 ]]; do
    case $1 in
    -p|--project) proj="$2" ; shift;;
    -c|--credentials) passfile="$2" ; shift;;
    -o|--outputdir) outdir="$2" ; shift;;
    -s|--session) sess="$2" ; shift;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1. Try $0 -h" 1>&2; exit 1;;
    (*) break;;
    esac
    shift
done

if [ -e ~/xnatpassfile ]; then
  /xget-public/xget -passfile $passfile -s $sess -o $outdir -proj $proj
fi
