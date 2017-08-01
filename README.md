Install script for a laravel project on a mac computer. This script will create a new sparsebundle image to serve as your dev environment and check out your git repo configure your laravel project by auto replacing with a proper .env then performs a migrate and seed. You will be left at the terminal with a fully functioning vagrant local dev environment.

# First steps
Edit both .env.install.example and .env.conf.example and rename to .env.install and .env.conf

# Execute it
bash install.sh

# Special Notes
You will be prompted for your stack password (specified in .env.conf) and for the sudo password a few times

-To delete an old or bad virtualbox

vboxmanage list vms (copy the part between {} the hash)

vboxmanage unregistervm hash --delete