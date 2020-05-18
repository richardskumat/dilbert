# Dilbert docker readme

This a docker image of https://gitlab.com/richardskumat/dilbert that intends to download all/daily comics from
dilbert.com.

## Usage to download all comics

Caveat:

Seems the container takes a very long time to catch to itself if it has already some comics.

Here's a sample command to download all comics:

```
docker run -d --name dilbert --rm -v $HOME/Pictures/dilbert:/home/user/Pictures/dilbert qwe1/dilbert:latest -a
```

Note on downloading all comics:

It will take a long time to download as the scraper script(dilbert.sh in the git repo at https://gitlab.com/richardskumat/dilbert) has
a sleep 6 command to avoid hammering dilbert.com.

Docker run parameters:

Use --name dilbert to make killing this container simpler.

Use the -d flag to put the container to run in the background.

If you want to stop the container, run if it's called dilbert:

docker kill dilbert

Use the --rm flag to remove the container once it's killed/stopped.

Use the -v flag to mount/bind a volume/directory for the downloaded comics.

The -a flag instructs the dilbert.sh inside the container to download all comics.

However, it seems using -a makes the docker run command uninterruptable,
so the ct in that case has to be killed.

## PUID/GUID

The ct can read env vars PUID and GUID to change the uid
and gid the download script runs under, which is nice for
if your user id differs from the default 1000/1000 of
Debian.

Example command:

```bash
docker run --name dilbert -e PUID=6969 -e GUID=6969 qwe1/dilbert -t
```

```bash
dwight@schrute:/tmp/dilbert# ls /var/lib/docker/volumes/6c714938b5221808990f28b056cf57067e13d7ec2788e52bdfc7ad1808e7277f/_data/ -lah
total 120K
drwxr-xr-x 2 6969 6969 4.0K May 18 14:52 .
drwxr-xr-x 3 root root 4.0K May 18 14:52 ..
-rw-r--r-- 1 6969 6969 112K May 18 14:52 2020-05-18.gif
```

## Usage to download today's comic

Caveat:

Due to date-generator not taking time zone differences into account, this might not always download the day's image.

Here's a sample command to download today's comic:

```
docker run -d --name dilbert --rm -v $HOME/Pictures/dilbert:/home/user/Pictures/dilbert qwe1/dilbert:latest -t
```

The -t flag instructs the dilbert.sh inside the container to download today's comic.