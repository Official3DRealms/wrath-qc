float mpalpha;
float showscores;
void() draw_multiplayer_scoreboard =
{
	local float num, totalplayersconnected;
	string mpstring, playername, playerping,playerpl, playerfrags;

	num = 0;
	totalplayersconnected = 0;
	vector colorimg = '1 1 1';
	vector posimage2 =fixed_vector( '272 60 0 ');
	DstringJournal(posimage2,"NAME                                        PING                                        PL%                                         FRAGS", 1, mpalpha,   colorimg, ' 10 8 0');
	posimage2 += '0 12 0';
	DFill (posimage2,0.5,1,'0.3 0.3 0.35','410 4 0',0); //void(vector pos, float alph, float escala, vector coloracion, vector siz, float flag) DFill 
	posimage2 += '0 5 0';

	while ((num < maxclients) && (num == totalplayersconnected))
	{
		posimage2 += '0 24 0';
		playername = getplayerkeyvalue(num, "name");
		playerping  = getplayerkeyvalue(num, "ping");
		playerpl  = getplayerkeyvalue(num, "pl");
		playerfrags  = getplayerkeyvalue(num, "frags");
		vector vector_sep;
		mpstring = strcat (playername);
		DstringJournal(posimage2,mpstring, 1, mpalpha, colorimg, ' 10 8 0');
		vector_sep_x = (190 - strlen (playername));
		posimage2 += fixed_vector (vector_sep);
		mpstring = strcat (playerping);
		DstringJournal(posimage2,mpstring, 1, mpalpha, colorimg, ' 10 8 0');
		vector_sep_x =(167 - strlen (playerping));
		posimage2 += fixed_vector (vector_sep);
		mpstring = strcat (playerpl);
		DstringJournal(posimage2,mpstring, 1, mpalpha, colorimg, ' 10 8 0');
		vector_sep_x =(167 - strlen (playerpl));
		posimage2 += fixed_vector (vector_sep);
		mpstring = strcat (playerfrags);
		DstringJournal(posimage2,mpstring, 1, mpalpha, colorimg, ' 10 8 0');

		if(playername != "")
		{
			totalplayersconnected ++;
		}
		num ++;		
	}

};
