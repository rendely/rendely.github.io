z(){
#Open zshrc quickly
  code ~/.zshrc
}

zs(){
#Source zshrc quickly
  source ~/.zshrc
  echo 'Updated ~/.zshrc'
}

zsb(){
#Backup zshrc quickly
  current_dir=${PWD} #Get current directory
  cd /Users/matthewrendely/code/github-rendely/rendely.github.io
  cat ~/.zshrc > zshrc
  git add zshrc
  git commit -m "Auto update zshrc"
  git push
  cd $current_dir
}

zsa(){
#Prints all the zshrc functions and a description
grep -A 1 -E '\(\)\{' ~/.zshrc
}

fastclone(){
#Clone repo, cd into it, install it and open in VScode
  repo="$1"
  slug=$(echo "$repo" | sed 's|.*/||; s/\.git$//;')
  echo "repo: $repo"
  echo "slug: $slug"
  if [ -d "$slug" ]; then
    echo "Directory already exists!"
  else
    echo "Cloning $repo"
    git clone $repo
    echo "cd into $slug"
    cd $slug
    echo "npm installing"
    npm install
    echo "open VS code"
    code .
    echo "open component files"
    code src/components/*
  fi
}

component(){
#Quickly create a new react component file
  component="$1"  # The component is the first argument to the function
  current_dir=${PWD##*/} #Get current directory
  if [ "$current_dir" != "components" ]; then  # Check if we're already in the components directory
    echo "Please navigate to the 'components' directory first."
    return
  fi

  if [ -e "$component.js" ]; then  # Check if the file exists
    echo "$component.js already exists."  # If it does, print a message saying so
  else
    touch "$component.js"  # If it doesn't, create the file
    cat <<END_TEXT > "$component.js"  # Add the text to the file
import React from 'react'

function $component(){
  return ()
}

export default $component

END_TEXT
    echo "Created $component.js and copied import statement to clipboard"
    echo "import $component from './$component';" | pbcopy
    code -r "$component.js"
  fi
}

cdg(){
#Quickly cd into folder based on partial keyword match 
  numResults=($(ls | grep $1 | wc -l))
  if [[ $numResults[1] = 1 ]]; then
    cd `ls | grep $1`
  else
    echo 'no single folder identified'
  fi 

}

bail(){
#Add bail to the npm test for Flatiron code
  sed -i '' 's/results.json"/results.json --bail"/g' package.json
}
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.1.3


#Fix python paths
path+=('/Users/matthewrendely/Library/Python/3.8/bin')
if which pyenv > /dev/null; then
     eval "$(pyenv init - )";
     export PIPENV_VENV_IN_PROJECT=1
fi