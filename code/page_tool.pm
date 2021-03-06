package page_tool;
use strict;
use diceware;
use html;
use http;
use loom_login;
use random;
use page;

sub respond
	{
	page::top_link(page::highlight_link(html::top_url(),"Home"));
	page::top_link(page::highlight_link(html::top_url("help",1),"Advanced"));
	page::top_link(page::highlight_link(html::top_url("function","folder_tools"),"Tools",1));

	if (http::get("random_id") ne "")
		{
		my $id = random::hex();
		http::put("id",$id);
		http::put("passphrase","");
		}
	elsif (http::get("random_passphrase") ne "")
		{
		http::put("passphrase",diceware::passphrase(5));
		http::put("id","");
		}
	elsif (http::get("hash_passphrase") ne "")
		{
		my $passphrase = http::get("passphrase");
		my $id = loom_login::passphrase_location($passphrase);
		http::put("id",$id);
		}

	page::set_title("Tools");

	my $hidden = html::hidden_fields(http::slice(qw(function session)));

	my $passphrase = http::get("passphrase");
	my $q_passphrase = html::quote($passphrase);

	my $id = http::get("id");
	my $q_id = html::quote($id);

	my $input_size_id = 32 + 4;

	my $table = "";
	$table .= <<EOM;
<table border=0 cellpadding=5 style='border-collapse:collapse'>
<colgroup>
<col width=100>
</colgroup>
EOM

	$table .= <<EOM;
<tr>
<td>Identifier:</td>
<td>
<input type=text class=mono name=id size=$input_size_id value="$q_id">
<input type=submit class=small name=random_id value="Random">
</td>
</tr>
<tr>
<td>Passphrase:</td>
<td>
<input type=text class=small name=passphrase size=50 value="$q_passphrase">
<input type=submit class=small name=random_passphrase value="Random">
<input type=submit class=small name=hash_passphrase value="Hash">
</td>
</tr>
EOM

	$table .= <<EOM;
</table>
EOM

	page::emit(<<EOM
<form method=post action="" autocomplete=off>
$hidden
EOM
);

	page::emit(<<EOM
<h1> Tools </h1>
On this panel, you may generate a new random identifier or random passphrase.
You may also compute the "hash" of a passphrase, which converts a passphrase
into an identifier.  You may enter the passphrase manually if you don't want
to use a random one.
<p>
$table
EOM
);

	page::emit(<<EOM
</form>
EOM
);

	return;
	}

return 1;
