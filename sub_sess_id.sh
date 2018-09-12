proj=$1
subid=$2

if [[ $proj == "ABCD_NDAR" ]]; then
    tmp_label=$subid
    if [[ $tmp_label == "1" ]]; then
        sub="YCW83AC7"
        sess="S1"
    elif [[ $tmp_label == "S1" ]]; then
        sub="INV6F1LPHLT"
        sess="S1"
    elif [[ $tmp_label == "S_1" ]]; then
        sub="FDM0PRRA"
        sess="S1"
    else
        sub=$subid
        if [[ $sub == *_S* ]]; then
          sess=S${sub##*_S}
          sub=${sub%_S*}
        elif [[ $sub == *-S* ]]; then
          sess=S${sub##*-S}
          sub=${sub%-S*}
        else
          sess="S1"
        fi
    fi
    sub=$(echo ${sub//[-_]/})
elif [[ $proj == "Parra_MMMM" ]]; then
      sub=${subid#$proj-}
      sess=${sub##*-}
      sub=${sub%-*}
      sub=$(echo ${sub//[-_]/})
elif [[ $proj == "Pettit_tDCS" ]]; then
      sub=${subid#$proj-}
      sess=${sub##*_}
      sub=${sub%_*}
      sub=$(echo ${sub//[-_]/})
elif [[ $proj == "Sibley_Teen" ]]; then
      if [[ $subid == *Sibley_TEEN* ]]; then
        sub=${subid#Sibley_TEEN-}
      else
        sub=${subid#$proj-}
      fi
      sess=${sub##*-}
      sub=${sub%-*}
      sub=$(echo ${sub//[-_]/})
elif [[ $proj == "Sutherland_MIP" ]]; then
      sub=${subid#$proj-}
      sess=S${sub##*S}
      if [[ $sub == *-S* ]]; then
        sub=${sub%-*}
      else
        sub=${sub%S*}
      fi
      sub=$(echo ${sub//[-_]/})
elif [[ $proj == "Sutherland_ACE" ]]; then
      sub=${subid#$proj-}
      sess=${sub##*-}
      sub=${sub%-*}
      sub=$(echo ${sub//[-_]/})
elif [[ $proj == "Soto_GRT" ]]; then
      sub=${subid#$proj-}
      if [[ $sub == *0003S1-S1 ]]; then
        sub=${sub%-*}
        sess="S1"
      elif [[ $sub == *0003S1-S2 ]]; then
        sub=${sub%-*}
        sess="S2"
      elif [[ $sub == *0003S2-S2 ]]; then
        sub=${sub%-*}
        sess="S3"
      elif [[ $sub == *0003-S1-S1 ]]; then
        sub=${sub%-*}
        sub=${sub%-*}
        sess="S4"
      elif [[ $sub == *0003-S2-S2 ]]; then
        sub=${sub%-*}
        sub=${sub%-*}
        sess="S5"
      elif [[ $sub == *0003S3-S3 ]]; then
        sub=${sub%-*}
        sess="S6"
      elif [[ $sub == *0003S4-S4 ]]; then
        sub=${sub%-*}
        sess="S7"
      else
        sess=${sub##*-}
        sub=${sub%-*}
        if [[ $sub == *-S* ]]; then
          sess=${sub##*-}
          sub=${sub%-*}
        elif [[ $sub == *S* ]]; then
          sub=${sub%S*}
        fi
      fi
      sub=$(echo ${sub//[-_]/})
elif [[ $proj == "Dick_AHEAD" ]]; then
    sub=${subid##*$proj-}
    if [[ $sub == *_S1 ]]; then
      if [[ $sub == *-2_S1 ]]; then
        sess="S2"
        sub=${sub%-2_S1*}
      else
        sess="S1"
        sub=${sub%-_*}
      fi
    elif [[ $sub == *_1 ]]; then
      echo $subid >> $data_qc/qc-processed/$proj-processed
      proj_data=$(cat $data_qc/qc-processed/$proj-processed)
      continue
    else
      sess=${sub##*-}
      sub=${sub%-*}
      if [[ $sub == *-S* ]]; then
        if [[ $sub != *-ST* ]]; then
          sub=${sub%-*}
        fi
      fi
    fi
    sub=$(echo ${sub//[-_]/})
elif [[ $proj == "Dick_TRAIN" ]]; then
    sub=${subid#$proj-}
    sess=${sub##*-}
    sub=${sub%-*}
    sub=$(echo ${sub//[-_]/})
elif [[ $proj == "Mattfeld_RTV" ]]; then
    sub=${subid#$proj-}
    sess=${sub##*-}
    if [[ $sess != S* ]]; then
      sub=$sub-S1
      sess=${sub##*-}
    fi
    sub=${sub%-*}
    sub=$(echo ${sub//[-_]/})
elif [[ $proj == "McMakin_EMU" ]]; then
    tmp_label=$subid
    if [[ $tmp_label == "McMakin_EMU_R01_PT-S1-S1" ]]; then
      sub="R01_PT"
      sess="S1"
    elif [[ $tmp_label == "1" ]]; then
        sub="000-1001"
        sess="S1"
    elif [[ $tmp_label == "2" ]]; then
        sub="000-1005"
        sess="S2"
    elif [[ $tmp_label == "S_1" ]]; then
        sub="000-1004"
        sess="S1"
    elif [[ $tmp_label == "S_2" ]]; then
        sub="000-1004"
        sess="S2"
    else
      if [[ $tmp_label == MCMAKIN_EMU* ]]; then
        sub=${subid#MCMAKIN_EMU-}
      else
        sub=${subid#$proj-}
      fi
      if [[ $sub == *_Day2* ]]; then
        sess="S2"
        sub=${sub%_*}
      elif [[ $sub == *_1-S1 ]]; then
        sess="S1"
        sub=${sub%_*}
      elif [[ $sub == *_2-S2 ]]; then
        sess="S2"
        sub=${sub%_*}
      elif [[ $sub == *_1 ]]; then
        sess="S1"
        sub=${sub%_*}
        if [[ $sub == *_* ]]; then
          sub=${sub%_*}
        fi
      elif [[ $sub == *_2 ]]; then
        sess="S2"
        sub=${sub%_*}
        if [[ $sub == *_* ]]; then
          sub=${sub%_*}
        fi
      elif [[ $sub == *_S1 ]]; then
        sess="S1"
        sub=${sub%_*}
      elif [[ $sub == *_S2 ]]; then
        sess="S2"
        sub=${sub%_*}
      else
        sess=${sub##*-}
        sub=${sub%-*}
        if [[ $sub == *-S* ]]; then
          sub=${sub%-*}
        elif [[ $sub == *S* ]]; then
          sub=${sub%S*}
        fi
      fi
    fi
    sub=$(echo ${sub//[-_]/})
    if [[ $sub == "000" ]]; then
      sub="0001002"
      sess="S3"
    fi
fi

echo $sub $sess
