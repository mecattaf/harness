# First things to do on new device setup

```
        sign in with google chrome
        signin with gh
        signin with tailscale
        curl -fsSL https://claude.ai/install.sh | bash
```


Then setting up the whisperlivekit:
```
  # should be already done automatically
  # loginctl enable-linger $USER
  systemctl --user daemon-reload
  systemctl --user enable --now asr-toolbox
 
```
