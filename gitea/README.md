# gitea

After the `setup` script has run, the website *still* requires a click to finish the installation.
Once that is done it will break since the OpenID login has not yet been configured.  Run this to
fix it.

```
./add-auth
```
