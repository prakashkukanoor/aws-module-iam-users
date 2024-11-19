# aws-module-iam
Module to create IAM user, user group

# generate public and private keys
gpg --list-secret-keys
gpg --full-generate-key
gpg --armor --export <email>@gmail.com > public-key.asc
gpg --armor --export-secret-keys <key-from-above-command> > private-key.asc

# decrypt the message

echo "-----BEGIN PGP MESSAGE----- 
<encrypted content>
-----END PGP MESSAGE-----" | gpg --decrypt



