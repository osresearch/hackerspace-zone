#!/bin/bash
die() { echo >&2 "gitea: ERROR $*" ; exit 1 ; }
info() { echo >&2 "gitea: $*" ; }

if grep -q "^git:" /etc/passwd ; then
	info "git user already exists"
	exit 0
fi

SSHDIR="/home/git/.ssh"
addgroup --gid 2222 git \
	|| die "unable to create git group"
adduser \
	--uid 2222 \
	--gid 2222 \
	--disabled-password \
	--gecos "Gitea Proxy User" \
	git \
	|| die "unable to add git user"

rm -f "$SSHDIR/id_rsa" "$SSHDIR/id_rsa.pub" "$SSHDIR/authorized_keys"

sudo -u git ssh-keygen \
	-t rsa \
	-b 4096 \
	-C "Gitea Proxy User Key" \
	-N "" \
	-f "$SSHDIR/id_rsa" \
|| die "unable to create host key"

sudo -u git tee -a "$SSHDIR/authorized_keys" < "$SSHDIR/id_rsa.pub" \
	|| die "unable to setup authorized key"
chmod 600 "$SSHDIR/authorized_keys"

cat <<"EOF" > "/usr/local/bin/gitea"
#!/bin/sh
ssh -p 2222 -o StrictHostKeyChecking=no git@127.0.0.1 "SSH_ORIGINAL_COMMAND=\"$SSH_ORIGINAL_COMMAND\" $0 $@"
EOF
chmod +x "/usr/local/bin/gitea"

