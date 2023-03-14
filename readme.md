# Dilbert.com

2023-03-13

Dilbert.com now redirects to https://linktr.ee/scottadams, making the code in this
repo useless.
## Default

The following script should download all comics from Dilbert.com as of 2022-08-01 as long as the site doesn't change its looks and code structure a lot.

Recommended to use in tmux or some other long running terminal windows(eg on a remote device).

There's a sleep 6 command in there at the of the download() to prevent hammering Dilbert.com for comics.

Usage:

```
bash -x dilbert -a
```

Then after all 12000+ images are downloaded, you can run a daily scrape:

```
bash -x dilbert -t
```

The -x flag after bash is for verbose output.

### date generator.py

This code fortunately generates a list of dates in the format dilbert.com uses, so can be used nicely in bash.

### dilbert.sh

This uses an awful mess of piping to download images from dilbert.com and convert them to yyyy-mm-dd format and save them in $HOME/Pictures/dilbert by default.


This will likely break if dilbert.com site layout changes.

## Known issue

date-generator.py errors out on last day on every month.

Need to rethink the whole repo how to workaround date generation for bash to work
or just rewrite the script in python anyway.

## Running this with Cron

Once dilbert.sh has downloaded all images from the site, the script can be run daily to download the latest images.

Example cron job, every night at 2300:

```
#Ansible: dilbert scraping
0 23 * * * bash $HOME/bin/dilbert -t
```
