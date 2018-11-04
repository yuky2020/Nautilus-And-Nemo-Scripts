#!/bin/bash



# How to back up your Gmail on Linux in four easy steps



# Open in terminal
tty -s; if [ $? -ne 0 ]; then gnome-terminal -e "$0"; exit; fi



if [ ! -d ~/gmail-archive ]; then
# Step 1: Install getmail
sudo apt-get install getmail4



# Step 2: Configure Gmail and getmail (first, turn on Imap in your Gmail account)
mkdir ~/.getmail
mkdir ~/gmail-archive
mkdir ~/gmail-archive/tmp ~/gmail-archive/new ~/gmail-archive/cur
touch ~/gmail-archive/gmail-backup.mbox
touch ~/.getmail/getmail.gmail
cat > ~/.getmail/getmail.gmail <<"End-of-message"
[retriever]
type = SimpleIMAPSSLRetriever
server = imap.gmail.com
username = youremail
password = yourpassword
mailboxes = ( "[Gmail]/All Mail", "[Gmail]/Sent Mail", "[Gmail]/Drafts" )

[destination]
type = MultiDestination
destinations = ('[mboxrd-destination]', '[maildir-destination]')

[mboxrd-destination]
type = Mboxrd
path = ~/gmail-archive/gmail-backup.mbox

[maildir-destination]
type = Maildir
path = ~/gmail-archive/

[options]
# print messages about each action (verbose = 2)
# Other options:
# 0 prints only warnings and errors
# 1 prints messages about retrieving and deleting messages only
verbose = 2
message_log = ~/.getmail/gmail.log
read_all = False
max_messages_per_session = 1000
received = false
delete = false
End-of-message
fi



# Step 3: Run getmail
for i in {1..n}; do getmail -r ~/.getmail/getmail.gmail; done
