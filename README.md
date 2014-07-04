dotfiles
========
Using
-----
```
    git clone git@github.com:cdunn2001/dotfiles.git
```
Then, in `dotfiles/.git/config`, change
```
    core.worktree = /Users/cdunn
```
or whatever. Then
```
    ln -s dotfiles/.git .
    git co HEAD -- .
```
