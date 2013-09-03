!/bin/bash
# author: http://gary-rowe.com/agilestack/2012/12/14/how-to-deploy-static-sites-with-git/

echo "Running post-receive"

# Target/working directory - use standard nginx
targetdir=/var/www/html
echo "cd $targetdir"
cd $targetdir

# Zip up what was there before, put it to an archive for emergency purposes
# /var/www/backups/example.YYYYMMMDDHHMMSSz.tgz

time_suffix=`date "+%Y-%m-%d-%H-%M-%S"`
echo "Backup timestamp $time_suffix"
tar czf ../backups/example.$time_suffix.tgz *

# Remove the existing data
echo "Remove $targetdir ..."
rm -fr $targetdir/*

# Check out the local copy of the git repo
echo "Check out local copy"
export GIT_WORK_TREE=/var/git/fbiframe
export GIT_DIR=/var/git/fbiframe
cd $GIT_WORK_TREE
git checkout -f


# Copy everything from fbiframe downwards to the above directory (so there's no src dir in the target)
echo "Copying to $targetdir"
cp -r /var/git/fbiframe/www/* $targetdir
sudo cp -r /var/git/fbiframe/www/* /usr/share/nginx/www
# No TTY interactivity so this is not possible (left in to highlight failing)
# echo "/etc/init.d/nginx restart"
# /etc/init.d/nginx restart