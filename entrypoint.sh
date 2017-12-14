
pwd
SHELLSCRIPTS=$(echo [0-9]*_*)
echo "SHELLSCRIPTS=$SHELLSCRIPTS"

for CMD in $SHELLSCRIPTS 
do
   echo running $CMD
   echo $CMD | grep -q _source_ && source ./$CMD $@ || sh ./$CMD $@
   RETURNVALUE=$?
   echo "RETURNVALUE=$RETURNVALUE"
   [ "$RETURNVALUE" != "0" ] && exit $RETURNVALUE
done

exit
source ./0_source_set_credentials && \
   sh ./1_create_bucket.sh && \
   sh ./2_* && \
   sh ./3_* && \
   sh ./4_* && \
   sh ./5_*

