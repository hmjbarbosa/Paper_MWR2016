#!/bin/ksh

# check if IN file exists
if [[ ! -e $1 ]]; then
    echo "Input file don't exist!"
    exit
fi

#
cat <<EOF > just_pwv.awk
{
  for (i=7; i<=105; i=i+5) {
    \$i=""; 
    x=i+1; \$x="";
    x=i+2; \$x="";
    x=i+4; \$x="";
  }; 
  print; 
}
EOF

# skip if OUT file already exists
if [[ ! -e ${1}_justpwv ]] ; then
    cat $1 | awk -f just_pwv.awk >  ${1}_justpwv
else
    echo "Output file already exists! Existing cowardly..."
fi

#
