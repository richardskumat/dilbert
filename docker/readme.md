# Dilbert docker readme

This a docker image of https://gitlab.com/richardskumat/dilbert that intends to download all/daily comics from
dilbert.com.

## Usage to download all comics

Caveat:

Seems the container takes a very long time to catch to itself if it has already some comics.

Early testing shows it's already slow if only a couple dozen images are downloaded, trying to make it faster atm.

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

Use the -v flag for permanent storage of the downloaded comics.

## Usage to download today's comic

Caveat:

Due to date-generator not taking time zone differences into account, this might not always download the day's image.

Here's a sample command to download all comics:

```
docker run -d --name dilbert --rm -v $HOME/Pictures/dilbert:/home/user/Pictures/dilbert qwe1/dilbert:latest -t
```