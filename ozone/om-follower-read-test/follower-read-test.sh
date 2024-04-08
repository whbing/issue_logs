# create test bucket if not exist
# bucket=test-follower-read and bucket=test-follower-read-linear test two cases
vol=s3v
bucket=test-follower-read
ozone sh bucket info $vol/$bucket > /dev/null 2>&1
if [ $? -ne 0 ]; then
    ozone sh bucket create $vol/$bucket
fi

prefix=followerReadTest
size=4096
thread=100

# WRITE
ozone freon ockrw -r 1000000 -t $thread --linear --contiguous --duration 120s --size $size -v $vol -b $bucket -p $prefix

sleep 3
# READ
ozone freon ockrw -r 1000 -t $thread --linear --contiguous --percentage-read 101 --read-metadata-only=false --duration 180s --size $size -v $vol -b $bucket -p $prefix

sleep 3
# 50% WRITE 50% READ
ozone freon ockrw -r 1000 -t $thread --linear --contiguous --percentage-read 50 --read-metadata-only=false --duration 180s --size $size -v $vol -b $bucket -p $prefix

# ONLY meta
sleep 3
# READ meta
ozone freon ockrw -r 1000 -t $thread --linear --contiguous --percentage-read 101 --read-metadata-only=true --duration 180s --size $size -v $vol -b $bucket -p $prefix

sleep 3
# 50% WRITE 50% READ meta
ozone freon ockrw -r 1000 -t $thread --linear --contiguous --percentage-read 50 --read-metadata-only=true --duration 180s --size $size -v $vol -b $bucket -p $prefix

