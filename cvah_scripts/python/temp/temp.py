#!/usr/bin/python3

import glob
import os

APP_DIR = str('/cm/AppStore/appStore_3.2.1')
PREV_APP_DIR = str('/cm/AppStore/appStore_3.2')
TEAMS = ["cpt", "mdt"]


for TEAM in range(len(TEAMS)):
    os.chdir(APP_DIR+'/'+TEAM)
    APPSTORELISTING = open('AppStoreListing.txt','w')
    CHANGELOG = open('AppStoreListingChangeLog.txt','w')
    APPSTORELISTING.write('Application, Version')
    CHANGELOG.write('Application, Version, Old Version')
    APPSTORELISTING.close()
    CHANGELOG.close()
    APPSTORELISTING = open('AppStoreListing.txt','a')
    CHANGELOG = open('AppStoreListingChangeLog.txt','a')
    for root, dirs, files in os.walk("."):
        for LIST in files:
            os.chdir(LIST)
            VFILE = open('version.txt','r')
            VERSION = VFILE.readline()
            VFILE.close()
            os.chdir('..')
            APPSTORELISTING.write("%s, \n" % TEAM)
            VFILE.close()
            VFILE = open(os.path.join(PREV_APP_DIR, TEAM, '/version.txt'),'r')
            OLD_VERSION = VFILE.readline()
            VFILE.close()
            if OLD_VERSION == VERSION:
                CHANGELOG.write(LIST+','+VERSION+','+OLD_VERSION)
    APPSTORELISTING.close()
    CHANGELOG.close()
