## How to install

```sh
./install.sh
./install2.sh

nvim +PlugInstall +qall
```

Your computer will reboot 2 times in the process :B

## How to profile its performance

```
# Open a file

:profile start profile.log
:profile func*
:profile file*

# Do slow actions here

:profile pause
:noautocmd qa!
```
