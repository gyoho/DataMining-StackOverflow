
// there is 21318 links to a question in Text field in comment
$ cat comments.xml | grep  http://askubuntu.com/questions/ | wc -l
21318

// extract comments only contains link
$ cat comments.xml | grep  http://askubuntu.com/questions/ > comments_with_link.xml

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

[Row data]
<row Id="5590" PostId="5378" Score="1" Text="If all you want is the terminal to remain open after a command, there are [much simpler solutions](http://askubuntu.com/questions/3359/with-a-launcher-for-a-terminal-application-how-can-i-keep-the-terminal-open-afte)." CreationDate="2010-10-10T03:21:52.713" UserId="1859" />

<row Id="5669" PostId="5636" Score="0" Text="This is related to (a part of) [this](http://askubuntu.com/q/4502/270) question, see this [answer](http://askubuntu.com/questions/4502/how-can-i-find-out-why-a-package-was-installed/4503#4503) for details." CreationDate="2010-10-10T14:34:00.707" UserId="270" />

[Extracted link ID]
<row Id="5590" PostId="5378" Score="1" Text="3359" CreationDate="2010-10-10T03:21:52.713" UserId="1859" />
<row Id="5669" PostId="5636" Score="0" Text="4502" CreationDate="2010-10-10T14:34:00.707" UserId="270" />

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

// replace the contents of Text with only the refering question id
$ sed 's/find/replace/' file
- with /' : remove only the first occurence
- with /g': remove all occurences

// Backreferences - Remembering patterns with \(, \) and \1
ref: http://www.grymoire.com/Unix/Regular.html#toc-uh-10

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

// find part: Text="..." part
regex: Text=".*http:\/\/askubuntu.com\/questions\/
// replace part: the id in link <remember the pattern>
regex: \([0-9]*\)

** Use extended regex flag '-r' \( and \) => ( and )   i.e) no need backslash
$ sed -r 's/Text=".*http:\/\/askubuntu.com\/questions\/([0-9]*)[^"]*"/Text="\1"/' comments_with_link.xml > comments_with_link_extracted_url.xml


--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

<ref: http://stackoverflow.com/questions/4677843/extract-and-replace-a-token-in-shell-script>
<ref: http://www.grymoire.com/Unix/Sed.html#toc-uh-4>