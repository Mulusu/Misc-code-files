# This script parses the select.def file of MUGEN and
# deletes character folders that are not mentioned there
# Assuming char folder structure chars/[category]/[character]
# Will NOT remove those commented out in select.def

import os
import shutil

# The path to the select.def
selectfile = "data/db/select.def"

# The chars directory
chardir = "chars"

# Counter of how many folders have been deleted
deleted = 0

# List of paths to be removed
remlist = []

def main():
    f = open(selectfile)
    lines = f.readlines()
    
    # Lists every folder in chars
    categories = [d for d in os.listdir("chars") if os.path.isdir(os.path.join(chardir, d))]
    for category in categories:
        characterdirs = [d for d in os.listdir(os.path.join(chardir,category)) if os.path.isdir(os.path.join(chardir,category,d))]
        for char in characterdirs:
            charpath = category+"/"+char
            found = False
            for line in lines:
                line = line.split(",")[0].rsplit("/",1)[0].lstrip(";").strip()

                # Character is in select file
                if(line.lower() == charpath.lower()):
                    found = True
                    break
               
            # Character was not in select file, remove folder
            if not found:
                print(charpath)
                remlist.append("chars/"+charpath)
    
    
    print("\nThe folders above will be removed!")
    answer = input("Remove them now? Y/N  [N]")
    if(answer == 'y'):
        for path in remlist:
            print("Removing "+path+"...")
            shutil.rmtree(path)
        print("DONE!")
    else:
        print("Remove cancelled, no changes made.")
    input("Press any key to quit")

if __name__ == "__main__":
    main()
    