#!/usr/bin/env bash

#NauTwitter.sh: A simple nautilus script to update your Twitter microblog
#(C) 2008 Jose A. Agudo
#Licensed under the terms of the GNU GPLv3 or later
if [ -e 
$HOME/.nautwitter.login ]; then
	source $HOME/.nautwitter.login
else
	username=$(zenity --entry --title="Enter username" --text="Twitter _username or email:")
	# Enter Twitter password here
	password=$(zenity --entry  --title="Enter password" --text="Twitter _password:" --hide-text)
	printf "#!/usr/bin/env bash\nusername=$username\npassword=$password" > $HOME/.nautwitter.login
	chmod +x $HOME/.nautwitter.login
	
fi

doTweet()
{
message=$(zenity --entry --text="What are you doing?")
count=$(echo $message | perl -ne 'while(/./g){++$count}; print $count')
if [ "$count" -gt '140' ]; then
	zenity --info --title="Status Update" --text="Post exceeds 140 characters.  Please re-enter..."
    else
      tResponse=$(curl -s -u $username:$password -d status="$message" -d source=nautwitter -H "X-Twitter-Client: NauTwitter" -H "X-Twitter-Client-Version: 1.0" -H "X-Twitter-Client-URL: http://tonyagudo.net/twitter/twitter.xml" http://twitter.com/statuses/update.xml)
      if [ $? -eq '0' ]; then
        zenity --info --text="Message sent to Twitter's server successfully."
      else
        zenity --info --text="Message undeliverable."
      fi
fi
main
}



reTweet()
{
message=$(zenity --entry --entry-text="RT " --text="What are you doing?")
count=$(echo $message | perl -ne 'while(/./g){++$count}; print $count')
if [ "$count" -gt '140' ]; then
	zenity --info --title="Status Update" --text="Post exceeds 140 characters.  Please re-enter..."
    else
      tResponse=$(curl -s -u $username:$password -d status="$message" -d source=nautwitter -H "X-Twitter-Client: NauTwitter" -H "X-Twitter-Client-Version: 1.0" -H "X-Twitter-Client-URL: http://tonyagudo.net/twitter/twitter.xml" http://twitter.com/statuses/update.xml)
      if [ $? -eq '0' ]; then
        zenity --info --text="Message sent to Twitter's server successfully."
      else
        zenity --info --text="Message undeliverable."
      fi
fi
main
}

getTimeline()
{
tempfile=$HOME/timeline.tmp
curl -s -u $username:$password http://twitter.com/statuses/friends_timeline.xml | perl -ne 'if(m/<text>(.*)<\/text>/){$text=$1;}if(m/<name>(.*)<\/name>/){print $1," - ",$text,"\n";}' > $tempfile
zenity --text-info --title="Friend's Time Line" --filename=$tempfile
rm $tempfile
main
}

getPublicTimeline()
{
tempfile=$HOME/pub_timeline.tmp
curl http://twitter.com/statuses/public_timeline.xml | perl -ne 'if(m/<text>(.*)<\/text>/){$text=$1;}if(m/<name>(.*)<\/name>/){print $1," - ",$text,"\n";}' > $tempfile
zenity --text-info --title="Public Time Line" --filename=$tempfile
rm $tempfile
main
}

do_follow()
{
newfriend=$(zenity --entry  --text="username of person to follow:")
curl -u $username:$password -d "" http://twitter.com/friendships/create/$newfriend.xml
zenity --info --text="You are now following $newfriend"
main
}

do_unfollow()
{
unfriend=$(zenity --entry  --text="username of person to unfollow:")
curl -u $username:$password -d "" http://twitter.com/friendships/destroy/$unfriend.xml
zenity --info --text="you have unfollowed $unfriend"
main
}

do_direct_message()
{
recipient=$(zenity --entry  --text="username of person to DM:")
message=$(zenity --entry  --text="DM message:")
curl -u $username:$password -d "text=$message&user=$recipient" http://twitter.com/direct_messages/new.xml
zenity --info --text="You have sent $recipienta direct message."
main
}

#list_direct_messages()
#{
#tempfile=$HOME/dm.tmp
#curl -u user:password http://twitter.com/direct_messages.xml | perl -ne 'if(m/<text>(.*)<\/text>/){$text=$1;}if(m/<name>(.*)<\/name>/){print $1," - ",$text,"\n";}' > $tempfile
#zenity --text-info --title="Your Direct Messages" --filename=$tempfile
#rm $tempfile
#main
#}

get_mentions()
{
tempfile=$HOME/mentions.tmp
curl -s -u $username:$password http://twitter.com/statuses/mentions.xml | perl -ne 'if(m/<text>(.*)<\/text>/){$text=$1;}if(m/<name>(.*)<\/name>/){print $1," - ",$text,"\n";}' > $tempfile
zenity --text-info --title="Mentions" --filename=$tempfile
rm $tempfile
main
}

main()
{
action=$(zenity --list --title="NauTwitter main menu" --column="Action" "PublicTimeline" "Timeline" "Mentions" "DoTweet" "ReTweet" "Follow" "Unfollow" "DM" "Exit")
case $action in
	Timeline) getTimeline;;
	PublicTimeline) getPublicTimeline;;
	Mentions) get_mentions;;
	DoTweet) doTweet;;
	ReTweet) reTweet;;
	Follow) do_follow;;
	Unfollow) do_unfollow;;
	DM) do_direct_message;;
	*) exit;;
esac
}

main
