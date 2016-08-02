git config --global pretty.myline '%C(auto)%h %d %s (%Cblue%an, %Cred%ad%Creset)'
git config --global alias.lll 'log --graph --decorate --oneline --all --color --pretty=myline --date=relative'
git config --global alias.ll 'log --graph --decorate --oneline --all --color --pretty=myline --date=relative --max-count=10'
git config --global alias.whenadded 'lll --diff-filter=A'
git config --global alias.dif 'diff'
git config --global alias.co 'checkout'
git config --global alias.dif 'diff'
git config --global alias.aliases '!git config --global -l | grep alias | cut -c 7-'
git config --global push.default 'tracking'