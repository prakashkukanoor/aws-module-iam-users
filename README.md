# aws-module-iam
Module to create IAM user, user group

# Generate public and private keys using gpg
- Install Homebrew (Mac os)
[Home Brew](https://formulae.brew.sh/formula/gnupg)

- List existing keys
```
gpg --list-secret-keys
```

- Generate new keys
```
gpg --full-generate-key
gpg --armor --export <email>@gmail.com > public-key.asc
gpg --armor --export-secret-keys <key-from-above-command> > private-key.asc
```

- Decrypt the content
```
echo "-----BEGIN PGP MESSAGE----- 
<encrypted content>
-----END PGP MESSAGE-----" | gpg --decrypt
```





