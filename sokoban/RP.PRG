procedure rp
set talk off

*================================================= 08/18/91 05:19pm ===*
*                                                                      *
*               ॠ������ ����誨 Soko-ban ��᫥��� �祡��         *
*                  楫� � ��業���� �������� �� ������            *
*                    � ������ �ணࠬ��஢���� �����                *
*                                                                      *
*                                                                      *
*               ------ ����� "� � � � � �  -  � � � �" ------         *
*                                                                      *
*========================================== (c) Insight corp., 1991 ===*

*============================================= ��।������ ����⠭� ===*

*------------------------------------------ ���� �ࠢ����� ������ ----
F_esc = 27
F_restart = 32  &&  䠪��᪨ - ��� �஡���, �� ��� ��� �� ���-
                        *�� ஫� ������, ���뢠�饩 ����ਭ� � ��砫�-
                        *��� ���ﭨ�
F_Left  = 19
F_Right =  4
F_Up    =  5
F_Down  = 24

*----------------------------����⠭��, �����騥 ����஢�� �ࠩ⮢ ---
   * ���⨬ �������� �� �� 䠪�, �� �ࠩ�� � �����ᮬ b      *)
   * �।�⠢���� ᮡ�� ���, ᬥ饭�� �� �_ctrl_bit, ��        *)
   * �������� ����� ��।����� ����, � ���஬ ��室���� '�窠'*)
   * - ����, �।�����祭��� ��� ��⠫������� �㤠 �騪��       *)

 * ᢮������ ��� �������� ������⢮
 *  ����, ���� ��� �窠�� � �窨 �७�� ������� ��ࠦ����
 *����� ᢮����묨 ��� ��������)

store 2 to C_free_place, S_free_place
store - S_free_place to Cb_free_place, Sb_free_place
 * 䨣�ઠ �����⥫� (��ꥪ�, ����� ������� �騪�)                  *
store 1 to C_man, S_man
store - S_man to Cb_man, Sb_man
 * �⥭� ����ਭ�                                                     *
store 9 to C_wall, S_wall
store - S_wall to Cb_wall, Sb_wall
 * ��� ��ꥪ� ��।������� - �騪�                                    *
store 4 to C_box, S_box
store - S_box to Cb_box, Sb_box

 *=====================================================================*)

dimension    game_field ( 20, 30 )
                      * ���ᨢ �।-   *)
                      * �⠢��� ᮡ�� ���������� ����ࠦ���� ��      *)
                      * ��࠭�, �� � �����, �� �������� �㭪樨     *)
                      * moving �����⢫��� �஢��� ���४⭮��     *)
                      * ��६�饭�� �� ����ਭ��                      *)

man_X=0       && ��� 楫�� �।�⠢��� ᮡ�� ⥪�騥 ����-   *)
man_Y=0       && ������ �����⥫�                              *)

score_all=0   && ��饥 ������⢮ ���� ��� �騪��              *)
score_new=0   && ⥪�饥 ������⢮ �騪��, 㫮������ �� ���� *)

kbrd_key=0    && ��६����� - ��� ᫥���饣� ����������        *)
              && � ���������� ᨬ����                          *)


bell = [? chr( 7 )]   && �㯥�-�㯥�-����ணࠬ�� ��� �뤠� ᨣ����

*---------------------------------------------------------------------*)
clear

&bell
*@ 5, 10 double 
do maze_init

&bell
&bell
do game_round

*------------------------------------------------ ࠧ��� ᫮����� ---*)
&bell
&bell
&bell
    if( score_new = score_all )
        @ 16, 20 say [*** �������! ***]
    else
        @ 16, 20 say [*** ᫠�-��-�! ***]
    endif
*--------------------------------------------------------------------*)
set console off
wait
set console on

clear
return      && -- end of procedure rp --



*=====================�㭪�� �뢮��� �� ��࠭ ����ࠦ���� �ࠩ� ===*)

function sprtout
parameters sprite_code
        *-------------------------------------------------------------*)
        * ��������� ⮬�, �� ��� �ணࠬ�� �������� ��� �뢮��     *)
        * �ࠩ� �� ��࠭ �⮩ �㭪樥�, �����                       *)
        * ����������� ���ଠ�� � ���譥� ���� �ࠩ�,             *)
        * ��� 梥�, �� ᮮ⢥��⢥���, �����砥� ������             *)
        * �஢������ ��������� � ����誥                              *)
        *-------------------------------------------------------------*)
do case
   case (sprite_code = C_free_place)
        sprite_pict = [  ]
   case sprite_code = Cb_free_place
        sprite_pict = [. ]
   case (sprite_code = C_man) .or. (sprite_code = Cb_man)
        sprite_pict = [><]
   case (sprite_code = C_wall) .or. (sprite_code = Cb_wall)
        sprite_pict = chr(178)+chr(178)
     *-------------------------------------------------------------*
	 *| ����� �।�⠢��� �� 䠪�, �� �� ����� S_man �  Sb_man |
	 *| �뢮����� ���� � �� �� ��㭮� �ࠩ�, � �� ����� S_box � |
	 *| Sb_box - ࠧ��, �� ���� ����������� ��⮬���᪨ �뢮����|
	 *| �� ��࠭ �ࠢ����� ���⨭�� ��� �騪� (������襭��, �᫨ |
	 *| �� ���⮬ ���� � ����襭��, �᫨ �� ����, �।�����祭��� |
	 *| �騪�) � �����⥫� ( ���� � �� �� ���⨭�� � �� ���⮬ ���� |
	 *| � �� ���� ��� �騪�                                         |
     *-------------------------------------------------------------*)
   case (sprite_code = C_box)
        sprite_pict = [<>]
   case (sprite_code = Cb_box)
        sprite_pict = chr(17)+chr(16)
   otherwise
        sprite_pict = [  ]
endcase
return( sprite_pict )

*=====================================================================*)

procedure sprite_show
parameters sprite_x, sprite_y, sprite_type
        *-------------------------------------------------------------*)
        * ��楤�� ���ᯥ稢��� �����᪨� �뢮� ����᪮�� ��ࠧ� *)
        * �� �ࠩ� � �।���� ��� �ணࠬ��, ����� �� �ந�室��   *)
        * ���४�� ᮤ�ন���� ���ᨢ� game_field[];                 *)
        *                                                             *)
        * � ������ ��楤�� �����ন������ ������� ���稪� ����     *)
        *-------------------------------------------------------------*)

     * �஢�ઠ ����室����� ���४�஢��� ���稪 �窮� *)
     if( game_field( sprite_x, sprite_y ) = Cb_box )
          if( sprite_type <> C_box )
            * �᫨ �� ���न���, �� ���ன ⮫쪮 �� ��� �騪,
		    *������ ��-�騪, 㬥����� ���稪 ������⢠ ���⠢������
		    *�� ���� �騪��
					     score_new = score_new - 1
           endif
     endif

     if( game_field( sprite_x, sprite_y ) < 0 )
          if( sprite_type = C_box )
            * �᫨ �� ���न���, �� ���ன ������ ����� �騪,
		    *������ ��� �騪�, 㢥����� ���稪 ������⢠ ���⠢-
		    *������ �� ���� �騪��
                 score_new = score_new + 1
          endif
     endif

     game_field( sprite_x, sprite_y ) = ;
         sign( game_field( sprite_x, sprite_y )) * ;
             abs( sprite_type )
   if( sprite_type < 0 )
       game_field( sprite_x, sprite_y ) = ;
          - game_field( sprite_x, sprite_y )
    endif

     @ sprite_x, sprite_y*2 ;
         say sprtout( game_field( sprite_x, sprite_y ) )
return


*=====================================================================*)

procedure maze_init
        *-------------------------------------------------------------*
        * ��楤�� ���樠������� ���ᨢ game_field[], ᮤ�ঠ騩    *
        * ���� ����ਭ�, �騪�, ���� ��� ���                        *
        * � ⠪�� ��⠭�������� ���稪� ����誨: ��饥 ������⢮    *
        * ���� ��� ��⠭���� �騪�� score_all, ������⢮ 㦥         *
        * ��⠭�������� �� ���� �騪�� score_new                     *
        *-------------------------------------------------------------*

dimension maze( 20 )

*                     0         1         2         3
*                     1234567890123456789012345678901
        maze( 01 ) = '000000000000000000000000000000'
        maze( 02 ) = '000000099999000000000000000000'
        maze( 03 ) = '000000090009000000000000000000'
        maze( 04 ) = '000000094009000000000000000000'
      	maze( 05 ) = '000009990049990000000000000000'
        maze( 06 ) = '000009004004090000000000000000'
        maze( 07 ) = '000999090999090000099999900000'
        maze( 08 ) = '000900090999099999990033900000'
        maze( 09 ) = '000904004000000000000033900000'
        maze( 10 ) = '000999990999909199990033900000'
        maze( 11 ) = '000000090000009990099999900000'
        maze( 12 ) = '000000099999999000000000000000'
        maze( 13 ) = '000000000000000000000000000000'

*---------------- ��砫쭠� ���樠������ ���ᨢ� & ���⪠ ��࠭� ---

    i = 1
    do while( i <= 20 )
       j = 1
       do while( j <= 30 )
          game_field( i,j ) = C_free_place
          j = j + 1
        enddo
        i = i + 1
     enddo

*-------------------------------------------- ���뢠��� ����ਭ� ---

    score_all = 0
    score_new = 0

    i = 1
    do while( i <= 13 )
       j = 1
       do while( j <= 30 )
          do case
             case substr( maze( i ), j, 1 ) = '0'
                  do sprite_show with i, j, S_free_place
             case substr( maze( i ), j, 1 ) = '9'
                  do sprite_show with i, j, S_wall
             case substr( maze( i ), j, 1 ) = '4'
                  do sprite_show with i, j, S_box
             case substr( maze( i ), j, 1 ) = '3'
                  do sprite_show with i, j, Sb_free_place
                  score_all = score_all + 1
             case substr( maze( i ), j, 1 ) = '7'
                  do sprite_show with i, j, Sb_box
                  score_all = score_all + 1
                  score_new = score_new + 1
             case substr( maze( i ), j, 1 ) = '1'
                  do sprite_show with i, j, S_man
                  man_X = i
                  man_Y = j
             case substr( maze( i ), j, 1 ) = '2'
                  do sprite_show with i, j, Sb_man
                  man_X = i
                  man_Y = j
                  score_all = score_all + 1
             otherwise
                  do sprite_show with i, j, S_free_place
            endcase
          j = j + 1
        enddo
        i = i + 1
     enddo

return

*=====================================================================

procedure moving
parameters dlt_x, dlt_Y
        *-------------------------------------------------------------*
        * ��楤�� �����⢫�� ��ࠡ��� �������� � �������� ���ࠢ-*
        * �����                                                       *
        *                                                             *
        * ���ࠢ����� �������� ��ன ᬥ饭�� dlt_x, dlt_y            *
        *                                                             *
        * ⠪, ���ਬ��, �᫨ dlt_x = 0, a dlt_y = + 1, � �� �����-*
        * ��, �� ��ࠡ��뢠���� ��������           ^                 *
        * � ���ࠢ����� ����, � ����,              | ( 0, - 1 )      *
        * ᮣ��᭮ ᫥���饩 ��⥬�                |                 *
        * ���न���:                         <-- -- + -- -->          *
        *                               ( - 1, 0 )  |     ( + 1, 0 )  *
        *                                           |                 *
        *                                           V ( 0, + 1 )      *
        *-------------------------------------------------------------*

		* ᢮����� �� ᫥���饥 ����?

if( abs(game_field(man_X+dlt_X,man_Y+dlt_Y)) = S_free_place)
          * ��६�饭�� �����⥫� �� ᫥���饥 ����
          man_X = man_X + dlt_X
          man_Y = man_Y + dlt_Y
else && �஢�ਬ, ����� �� �騪
    if( abs(game_field(man_X+dlt_X, man_Y+dlt_Y)) = S_box )
        * � ᢮����� �� ���� �� �騪��?
        if( abs(game_field(man_X+dlt_X*2, man_Y+dlt_Y*2)) ;
                           = S_free_place )
             * ��६��⨬ �騪 � �����⥫� �� ���� � ������ ���ࠢ�����
             do sprite_show with man_X+dlt_X, man_Y+dlt_Y, S_free_place
             do sprite_show with man_X+dlt_X*2, man_Y+dlt_Y*2, S_box
             man_X = man_X + dlt_X
             man_Y = man_Y + dlt_Y
         endif
    endif
endif
return

*=====================================================================*

procedure game_round

        *-------------------------------------------------------------*
        *                                                             *
        *                �᭮���� 横� ����誨                        *
        *                                                             *
        *-------------------------------------------------------------*

game_yes = .t.

do while( game_yes )

		* �뢮��� �����⥫� �� ⥪�饩 ���न���
    do sprite_show with man_X, man_Y, S_man

    		* ������ ������� � ����������
    * �ࠧ� �� ����⨬, �� ���짮������ �������� inkey() � ������
    * ��砥 (� ���� � ������ �몥) ���� ���஦��: ����� �� ������� 
    * �� ������ ᨬ��� � ����������, � �ந������ ���� ���������� �
    * ��᫥���騬 ������ ᨬ����
    kbrd_key = 0
    DO WHILE .NOT.( (kbrd_key = F_esc).or.(kbrd_key = F_restart).or.;
                    (kbrd_key = F_Left).or.(kbrd_key = F_Right).or.;
                    (kbrd_key = F_Up).or.(kbrd_key = F_Down) )
       kbrd_key = 0
       DO WHILE kbrd_key = 0
          kbrd_key = INKEY()
       ENDDO
    ENDDO



		* ��ࠥ� �����⥫� �� ⥪�饩 ���न���
    do sprite_show with man_X, man_Y, S_free_place

		* ��ࠡ��뢠�� �ࠢ������ �������
    do case
       case (kbrd_key = F_Left )
            do moving with 0, -1

       case (kbrd_key = F_Right )
            do moving with 0, +1

       case (kbrd_key = F_Up )
            do moving with -1, 0

       case (kbrd_key = F_Down )
            do moving with +1, 0

    endcase

	* � ⠪ �� �� ���, ���� ���� �� ��⠭���� �� �騪� �� ����, ����
	*�� ������ ��� F_esc, ���� ��� F_restart

  if(  (score_new = score_all) ;
	     .or. (kbrd_key = F_esc) .or. (kbrd_key = F_restart) )
	  game_yes = .f.
   endif
enddo

return
