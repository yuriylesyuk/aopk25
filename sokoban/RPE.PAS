program Russian__Soko_ban;

        (*======================================== 02/15/91 06:36pm ===*)
        (*                                                             *)
        (*   the realization of game Soko-ban pursue only study aims   *)
        (*     and pointed at complex from programming view places     *)
        (*                                                             *)
        (*                                                             *)
        (*    ------  "The Knowledge is a Power" version  ------       *)
        (*                                                             *)
        (*================================= (c) Insight corp., 1991 ===*)

uses    crt;

(*=========================================== constant's definition ===*)

const   F_key = 256;  (* offset for recognition of control             *)
                      (* keys                                          *)

(*------------------------------------------- codes of control keys ---*)
        F_esc = 27;
        F_restart = 32;  (* factly - space's code, but for us it is      
                         key that reset maze in begin state            *)
        F_Left  = F_key + $4b;
        F_Right = F_key + $4d;
        F_Up    = F_key + $48;
        F_Down  = F_key + $50;

(*------------- constants, that are masks for operating game's array ---*)

        C_ctrl_bit = $80;
        C_bit_mask = $7f;

(*------------------------------ constants, that set sprite's coding ---*)
  (* pay attention at fact that sprites with index b             *)
  (* everyone is code shifted at C_ctrl_bit, that                *)
  (* permit easily determine field, in that is 'point' -         *)
  (* a place defined for pushing boxes in it                     *)


(* free space for moving                                               +)
  (by the way, places beneath points from a point of look of this+)
  expression is free for moving)                                 *)

	S_free_place = 0;      Sb_free_place = C_ctrl_bit + S_free_place;
(* mover's figure (object that move boxes)                             *)
	S_man = 1;             Sb_man = C_ctrl_bit + S_man;
(* wall of maze                                                        *)
	S_wall = 9;            Sb_wall = C_ctrl_bit + S_wall;
(* code of object of moving - box                                      *)
	S_box = 4;             Sb_box = C_ctrl_bit + S_box;

(*=====================================================================*)

var     game_field: array [1..20, 1..30] of integer; (* array is       *)
                      (* equivalence of image at screen, but in codes  *)
                      (* that permit perform testing of correct moving *)
                      (* through maze by function moving()             *)

        man_X,        (* a couple of integer is current positions of   *)
        man_Y,        (* mover                                         *)

        score_all,    (* a whole number of places for boxes            *)
        score_new,    (* a current number of boxes fitted at room      *)

        kbrd_key:     (* variable - code of next entered               *)
        integer;      (* from keyboard symbol                          *)

(*======================= get symbol from keyboard: system function ===*)

function getkey: integer;
        (*-------------------------------------------------------------*)
        (* function return next entered from keyboard symbol           *)
        (*                                                             *)
        (* if at keyboard was pressed control code,                    *)
        (* flag - first byte is 00                                     *)
        (* (up-down-left-right), then code is shifted at value         *)
        (* F_key                                                       *)
        (*-------------------------------------------------------------*)
var  next_char : char;
begin
     next_char := readkey;
     if( next_char = chr( 00 ) )
     then
          getkey := F_key + ord( readkey )
     else
          getkey := ord( next_char )
end;

(*========================== function out at screen image of sprite ===*)

procedure sprite_out( sprite_type: integer );
        (*-------------------------------------------------------------*)
        (* thanks to, that whole program is used for out of sprite     *)
        (* at screen this function, here is localized information      *)
        (* about external view of sprite, its color that correspondedly*)
        (* take more easy the task performing changes in game          *) 
        (*-------------------------------------------------------------*)
begin
     case sprite_type of
          S_free_place: write( '  ' );
          Sb_free_place: write( '. ');
          S_man,
          Sb_man     : write( '><' );
          S_wall,
          Sb_wall : write( chr(178)+chr(178) );
        (*-------------------------------------------------------------*
         | there is interested the fact that at codes S_man and Sb_man |
         | is printed the same picture of sprite, and codes S_box and  |
         | Sb_box cause different ones, that gives the possibility     |
         | automaticly print out at screen right picture for box (not  |
         | colored, if at free place and colored, if at field that is  |
         | assigned for box) and mover (same picture either at free    |
         | place and a field for box)                                  |
         *-------------------------------------------------------------*)
          S_box : write( '<>' );
          Sb_box : write( chr(17)+chr(16) );
     end;
end;

(*=====================================================================*)

procedure sprite_show( sprite_x, sprite_y,
                       sprite_type: integer );
        (*-------------------------------------------------------------*)
        (* this procedure provide a logical out of grafic image        *)
        (* of sprite in through of whole program; here also performing *)
        (* the correction of contest of array game_field[];            *)
        (*                                                             *)
        (* in given procedure is supported game's counter              *)
        (*-------------------------------------------------------------*)

begin
     (* testing: is needed to correct bonus's counter? *)
     if( game_field[ sprite_x, sprite_y ] = Sb_box )
     then
          if( sprite_type <> S_box )
          then (* if at coordinate, at that in that moment was become
     box, is writing non-box, decrease a fitted at places boxes counter *)
					     score_new := score_new - 1;
     if( (game_field[ sprite_x, sprite_y ] and C_ctrl_bit ) <> 0 )
     then
          if( sprite_type = S_box )
          then (* if at coordinate, at that must be box, 
     is writing code of box, increase a counter of fitted at places
     for boxes counter                                           *)
                 score_new := score_new + 1 ;

     game_field[ sprite_x, sprite_y ] :=
         (game_field[ sprite_x, sprite_y ] and C_ctrl_bit )
              or ( sprite_type ) ;
     gotoXY( sprite_y*2, sprite_x );
     sprite_out( game_field[ sprite_x, sprite_y ] )
end;


(*=====================================================================*)

procedure maze_init;
        (*-------------------------------------------------------------*)
        (* the procedure initialize array game_field[], that keep      *)
        (* a maze's field, boxes, rooms for its, and also              *)
        (* install counters of game: whole number of rooms             *)
        (* for placing boxes - score_all, a number already             *)
        (* installed at place boxes - score_new                        *)
        (*-------------------------------------------------------------*)

var i, j: integer;

    maze : array [ 1..20 ] of string[ 31 ];

begin
(*                     0         1         2         3  *)
(*                     1234567890123456789012345678901  *)
        maze[ 01 ] := '000000000000000000000000000000';
        maze[ 02 ] := '000000099999000000000000000000';
        maze[ 03 ] := '000000090009000000000000000000';
        maze[ 04 ] := '000000094009000000000000000000';
      	maze[ 05 ] := '000009990049990000000000000000';
        maze[ 06 ] := '000009004004090000000000000000';
        maze[ 07 ] := '000999090999090000099999900000';
        maze[ 08 ] := '000900090999099999990033900000';
        maze[ 09 ] := '000904004000000000000033900000';
        maze[ 10 ] := '000999990999909199990033900000';
        maze[ 11 ] := '000000090000009990099999900000';
        maze[ 12 ] := '000000099999999000000000000000';
        maze[ 13 ] := '000000000000000000000000000000';

(*-------- starting initialisation of array & a clearing of screen ---*)

    for i:=1 to 20 do
        for j:=1 to 30 do
            begin
            game_field[ i,j ] := 0 ;
            sprite_show( i,j, S_free_place );
            end;

(*----------------------------------------------- scanning of maze ---*)

    score_all := 0;
    score_new := 0;

    for i:=1 to 13 do
        for j:=1 to 30 do
            case maze[ i ][ j ] of
               '0': sprite_show( i, j, S_free_place );
               '9': sprite_show( i, j, S_wall );
               '4': sprite_show( i, j, S_box );
               '3': begin
                    sprite_show( i, j, Sb_free_place );
                    score_all := score_all + 1
                    end;
               '7': begin
                    sprite_show( i, j, Sb_box );
                    score_all := score_all + 1;
                    score_new := score_new + 1
                    end;
               '1': begin
                    sprite_show( i, j, S_man );
                    man_X := i;
                    man_Y := j;
                    end;
               '2': begin
                    sprite_show( i, j, Sb_man );
                    man_X := i;
                    man_Y := j;
                    score_all := score_all + 1
                    end;
               else
                    sprite_show( i, j, S_free_place );
            end
end;

(*=====================================================================*)

procedure moving( dlt_x, dlt_Y : integer );
        (*-------------------------------------------------------------*)
        (* procedure perform doing at needed direction                 *)
        (*                                                             *)
        (* direction is setted by a couple of values dlt_x, dlt_y      *)
        (*                                                             *)
        (* so, in example, if dlt_x = 0, a dlt_y = + 1, then           *)
        (* is performed a move at down direction                       *) 
        (*                                           ^                 *)
        (* in agree with follow                      | ( 0, - 1 )      *)
        (* system of                                 |                 *)
        (* coordinates:                       <-- -- + -- -->          *)
        (*                               ( - 1, 0 )  |     ( + 1, 0 )  *)
        (*                                           |                 *)
        (*                                           V ( 0, + 1 )      *)
        (*-------------------------------------------------------------*)

begin
     (* is free next field? *)
		 if((game_field[man_X+dlt_X,man_Y+dlt_Y])and C_bit_mask = S_free_place)
     then begin
          (* moving mover at next field *)
          man_X := man_X + dlt_X;
          man_Y := man_Y + dlt_Y
          end
     else (* test, may be this is box *)
        if( game_field[man_X+dlt_X, man_Y+dlt_Y]and C_bit_mask = S_box )
        then
            (* is free the field after box? *)
            if( game_field[man_X+dlt_X*2, man_Y+dlt_Y*2]and C_bit_mask
                           = S_free_place )
           then
           begin
             (* move box and mover in field at given direction *)
             sprite_show( man_X+dlt_X, man_Y+dlt_Y, S_free_place );
             sprite_show( man_X+dlt_X*2, man_Y+dlt_Y*2, S_box );
             man_X := man_X + dlt_X;
             man_Y := man_Y + dlt_Y
           end;
end;

(*=====================================================================*)

procedure game_round;

        (*-------------------------------------------------------------*)
        (*                                                             *)
        (*                   main loop of game                         *)
        (*                                                             *)
        (*-------------------------------------------------------------*)

begin
  repeat

    (* print out mover at current coordinate *)
    sprite_show( man_X, man_Y, S_man );

    (* enter code from keyboard *)
    kbrd_key := getkey;

    (* erase mover at current coordinate *)
    sprite_show( man_X, man_Y, S_free_place );

    (* perform control key *)
    case kbrd_key of
         F_Left : moving( 0, -1 );

         F_Right: moving( 0, +1 );

         F_Up   : moving( -1, 0 );

         F_Down : moving( +1, 0 );

    end;

  (* and that way until either placed all boxes at its room, or
  don't enter code F_esc, or code F_restart                         *)

  until(  (score_new = score_all) (* is all boxes at its rooms? *)
	     or (kbrd_key = F_esc) or (kbrd_key = F_restart) );
end;

(*=====================================================================*)

begin
        (*-------------------------------------------------------------*)
        (*                                                             *)
        (*                                                             *)
        (*                                                             *)
        (*                                                             *)
        (*                                                             *)
        (*                                                             *)
        (*-------------------------------------------------------------*)

(*---------------------------------------------------------------------*)

    maze_init;

    game_round;

(*------------------------------------------------ the program self ---*)

    if( score_new = score_all )
    then
        begin
        gotoXY( 12, 20 );
        write( '*** a good boy! ***');
        kbrd_key := getkey;
        end
    else
        begin
        gotoXY( 12, 20 );
        write( '*** oh, you are too week! ***' );
        kbrd_key := getkey;
        end
(*--------------------------------------------------------------------*)

end.
