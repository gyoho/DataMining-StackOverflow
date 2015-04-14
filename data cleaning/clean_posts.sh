
// Trancate <xml> and </xml> and <post> tag
$ head -n -1 Posts.xml | tail -n +3 > posts.xml

// there is 109328 links to question in PostLink.xml
$ cat PostLinks.xml | wc -l

// there is 28838 links to question in PostLink.xml
$ cat Comments.xml | grep http://askubuntu.com/ | wc -l


--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------


1:&lt;p&gt;Every time I turn on my computer, I see a message saying something like:&lt;/p&gt;&#xA;&#xA;&lt;pre&gt;&lt;code&gt;Your battery may be old or broken.&#xA;&lt;/code&gt;&lt;/pre&gt;&#xA;&#xA;&lt;p&gt;I am already aware that my battery is bad. How do I suppress this message?&lt;/p&gt;&#xA;

1:&lt;p&gt;Every time I turn on my computer, I see a message saying something like:&lt;/p&gt;  &lt;pre&gt;&lt;code&gt;Your battery may be old or broken. &lt;/code&gt;&lt;/pre&gt;  &lt;p&gt;I am already aware that my battery is bad. How do I suppress this message?&lt;/p&gt; 


1:<p>Every time I turn on my computer, I see a message saying something like:</p>  <pre><code>Your battery may be old or broken. </code></pre>  <p>I am already aware that my battery is bad. How do I suppress this message?</p> 


1:Every time I turn on my computer, I see a message saying something like:  Your battery may be old or broken.   I am already aware that my battery is bad. How do I suppress this message?

--------------------------------------------------------------------------------------------------------------------------------------

2:&lt;p&gt;Maybe &lt;a href=&quot;http://linux.aldeby.org/get-rid-of-your-battery-may-be-broken-notification.html&quot;&gt;these&lt;/a&gt; instructions will help you to get rid of that message.&lt;/p&gt;&#xA;&#xA;&lt;p&gt;Added instructions from the link, &lt;kbd&gt;Alt&lt;/kbd&gt;+&lt;kbd&gt;F2&lt;/kbd&gt;, then type in &lt;code&gt;gconf-editor&lt;/code&gt;. &lt;/p&gt;&#xA;&#xA;&lt;p&gt; Navigate to &lt;code&gt;/apps/gnome-power-manager/notify/low_capacity&lt;/code&gt; and untick the value.&lt;/p&gt;&#xA;&#xA;&lt;p&gt;Or a single command:&lt;/p&gt;&#xA;&#xA;&lt;pre&gt;&lt;code&gt;gconftool --set /apps/gnome-power-manager/notify/low_capacity --type boolean false&#xA;&lt;/code&gt;&lt;/pre&gt;&#xA;


2:&lt;p&gt;Maybe &lt;a href=&quot;http://linux.aldeby.org/get-rid-of-your-battery-may-be-broken-notification.html&quot;&gt;these&lt;/a&gt; instructions will help you to get rid of that message.&lt;/p&gt;  &lt;p&gt;Added instructions from the link, &lt;kbd&gt;Alt&lt;/kbd&gt;+&lt;kbd&gt;F2&lt;/kbd&gt;, then type in &lt;code&gt;gconf-editor&lt;/code&gt;. &lt;/p&gt;  &lt;p&gt;Navigate to &lt;code&gt;/apps/gnome-power-manager/notify/low_capacity&lt;/code&gt; and untick the value.&lt;/p&gt;  &lt;p&gt;Or a single command:&lt;/p&gt;  &lt;pre&gt;&lt;code&gt;gconftool --set /apps/gnome-power-manager/notify/low_capacity --type boolean false &lt;/code&gt;&lt;/pre&gt;


2:<p>Maybe <a href="http://linux.aldeby.org/get-rid-of-your-battery-may-be-broken-notification.html">these</a> instructions will help you to get rid of that message.</p>  <p>Added instructions from the link, <kbd>Alt</kbd>+<kbd>F2</kbd>, then type in <code>gconf-editor</code>. </p>  <p>Navigate to <code>/apps/gnome-power-manager/notify/low_capacity</code> and untick the value.</p>  <p>Or a single command:</p>  <pre><code>gconftool --set /apps/gnome-power-manager/notify/low_capacity --type boolean false </code></pre>


2:Maybe these instructions will help you to get rid of that message.  Added instructions from the link, Alt+F2, then type in gconf-editor.   Navigate to /apps/gnome-power-manager/notify/low_capacity and untick the value.  Or a single command:  gconftool --set /apps/gnome-power-manager/notify/low_capacity --type boolean false

-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

/***
1. Extract Body  <ref: http://stackoverflow.com/questions/5080988/how-to-extract-string-following-a-pattern-with-grep-regex-or-perl>
- Use grep and regex
- Body="..." --> all part within the quote
- Since it uses '&quot' to express "" in data, it's safe to just consider the outmost quote

$ grep -Po 'Body="\K.*?(?=")' posts.xml > contents_extracted_body.txt
<ref: CMPE239/askubuntu.com/posts.xml>

Caution!!
$ wc -l contents_extracted_body.txt 
423900
=> num of line doesn't match the last line number
***/

1. Extract Body with Id
// replace every row with Id and Body
$ sed 's/find/replace/' file
- with /' : remove only the first occurence
- with /g': remove all occurences

// Backreferences - Remembering patterns with \(, \) and \1
ref: http://www.grymoire.com/Unix/Regular.html#toc-uh-10

// find part: Text="..." part
regex: Text=".*http:\/\/askubuntu.com\/questions\/
// replace part: the id in link <remember the pattern>
regex: <row\sId="([0-9]*)".*Body="([^"]*)".*>

** Use extended regex flag '-r' \( and \) => ( and )   i.e) no need backslash
$ sed -r 's/<row\sId="([0-9]*)".*Body="([^"]*)".*>/\1:\t\2/' posts.xml > id-body.txt


In tag=Body remove every symblo listed below
-- HTML entities --

2. X:exclude    O:replace with ' '
<ref: http://dev.w3.org/html5/html-author/charref>
- &#xA = newline character
$ sed 's/&#xA;/ /g' id-body.txt > id-contents_excluded_newline.txt
<ref: http://www.theunixschool.com/2014/08/sed-examples-remove-delete-chars-from-line-file.html>

3. decode  i.e) use GNU 'decode'
$ cat id-contents_excluded_newline.txt | recode HTML_4.0 > id-contents_decoded.txt
<ref:http://stackoverflow.com/questions/3322820/find-replace-htmlentities-using-the-standard-linux-toolchain>
$ cat id-contents_excluded_newline.txt | php -R 'echo html_entity_decode($argn);' > id-contents_decoded.txt
<ref: http://serverfault.com/questions/440805/how-can-i-easily-convert-html-special-entities-from-a-standard-input-stream-in-l>

4. remove HTML tags: character match
$ sed 's/<[^>]*>//g' id-contents_decoded.txt > id-contents_removed_HTML-tags.txt
Regex symbols: <ref:https://qualysguard.qualys.com/qwebhelp/fo_help/module_pc/policies/regular_expression_symbols.htm>
Regex tester: <ref: http://www.regexr.com/>


4. Remove symblos
- *

- remove grammar characters {,.?!:;()} and &gt and &lt
$ sed 's/[,.?!;()]//g' id-contents_removed_HTML-tags.txt | sed 's/&gt//g' | sed 's/&lt//g' > id-contents_deleted_grammer_symbols.txt

- replace {@/-} with ' '
$ sed 's/[*@/-]/ /g' id-contents_deleted_grammer_symbols.txt > id-contents_erased_specia_chars.txt

- word: --> word   BUT NOT) number: 
$ sed -r 's/([A-Za-z]):/\1/g' id-contents_erased_specia_chars.txt > id-content.txt



*This is italicized*, and so is _this_.
**This is bold**, and so is __this__.
Use ***italics and bold together*** if you ___have to___.