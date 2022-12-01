function automatic_iterm_tab_color_cwd () {
RES=`python -c "import random; import os; \
             random.seed('red'   + os.getcwd()); a=(random.randint(0,255)+255); \
             random.seed('green' + os.getcwd()); b=(random.randint(0,255)+255); \
             random.seed('blue'  + os.getcwd()); c=(random.randint(0,255)+255); \
             print(str(a)+' '+str(b)+' '+str(c));
             "`
tc $RES
}

automatic_iterm_tab_color_cwd 
autoload -U add-zsh-hook
add-zsh-hook chpwd automatic_iterm_tab_color_cwd 
