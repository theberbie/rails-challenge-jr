# TMWSD

Message creators(or anyone with the token) can view and create urls.

URLS are created int he following format:

```
messages/:token
```
Message created without a password are sent in the following format:
```
messages/auth/:auth
```

Once a message is viewed, refreshing the page deletes the token shared with friends.

The creator of the message can still access the message and created new URLS.

Demo: http://tmwsd-everlywell.herokuapp.com/
