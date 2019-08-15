# Dilbert.com



## Default

The following script should download all comics from Dilbert.com as of 2019-08-15 as long as the site doesn't change its looks and code structure a lot.

Recommended to use in tmux or some other long running terminal windows(eg on a remote device).

There's a sleep 6 command in there between downloading two comics to prevent hammering Dilbert.com for comics.

Also I've had issues where after a certain amount of downloads, dilbert.com would start throwing up SSL errors.

Usage:

```
bash -x dilbert -a
```

Then after all 10000+ images are downloaded, you can run a daily scrape:

```
bash -x dilbert -t
```

The -x flag after bash is for verbose output.

### date generator.py

This code fortunately generates a list of dates in the format dilbert.com uses, so can be used nicely in bash.

### dilbert.sh

This uses an awful mess of piping to download images from dilbert.com and convert them to yyyy-mm-dd format and save them in $HOME/Downloads/dilbert by default.


This will likely break if dilbert.com site layout changes.

## Running this with Cron

Once dilbert.sh has downloaded all images from the site, the script can be run daily to download the latest images.

Example cron job, every night at 2300:

```
#Ansible: dilbert scraping
0 23 * * * bash $HOME/bin/dilbert -t
```
