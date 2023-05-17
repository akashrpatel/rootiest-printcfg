#!/bin/bash
# Copyright (C) 2023 Chris Laprade (chris@rootiest.com)
# 
# This file is part of printcfg.
# 
# printcfg is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# printcfg is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with printcfg.  If not, see <http://www.gnu.org/licenses/>.

# Set the owner and repo name
owner="rootiest"
repo="printcfg"

# Define the klipper config file
config=~/printer_data/config
printer=~/printer_data/config/printer.cfg
moonraker=~/printer_data/config/moonraker.conf
user_vars=$config/$repo/print_variables.cfg

# Check if any parameters were provided
if [ $# -eq 0 ]
then
    ssrc_vars=$config/$repo/profiles/default.cfg
else
    # Set the src_vars file
    if [ -n "$1" ]
    then
        src_vars=$config/$repo/profiles/$1
    fi
fi

# Check that user variables file exists
if [ ! -f $user_vars ]; then
    echo -e "\e[31mUser variables file does not exist.\e[0m"
    exit 1
fi

# Find version of user variables
user_vars_version=$(grep -oP '(variable_version: ).*' $user_vars)
user_vars_version=${user_vars_version#variable_version: }
src_vars_version=$(grep -oP '(variable_version: ).*' $src_vars)
src_vars_version=${src_vars_version#variable_version: }

# Check if user variables file is up to date
if [ "$user_vars_version" != "$src_vars_version" ]; then
    echo -e "\e[31mUser variables file is not up to date.\e[0m"
    echo "User version:   $user_vars_version"
    echo "Source version: $src_vars_version"
    echo -e "\e[31mPlease update the user variables file.\e[0m"
    exit 1
else
    echo -e "\e[32mUser variables file is up to date.\e[0m"
fi
fi