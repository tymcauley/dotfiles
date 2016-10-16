import pip
import platform
from subprocess import call
import sys

# I can only upgrade user packages on CentOS platforms.
user_upgrades_only = False
user_flag = ""
if (platform.uname()[0] == "Linux") and ("centos" in platform.platform()):
    user_upgrades_only = True
    user_flag = "--user --no-deps "

# Change pip command based on which version of python is running this script.
if sys.version_info >= (3, 0):
    pip_command = "pip3"
else:
    pip_command = "pip"

# Run all necessary pip upgrade commands.
for dist in pip.get_installed_distributions(user_only=user_upgrades_only):
    call(pip_command + " install --upgrade " + user_flag + dist.project_name, shell=True)
